# Using a simple algorithm, convert the references to a path in to a
# sorted list of dependent paths based on how often they're referenced
# and how deep in the tree they live. Equally-"popular" paths are then
# sorted by name.
#
# The existing writeClosure prints the paths in a simple ascii-based sorting of the paths.
#
# Sorting the paths by graph improves the chances that the difference
# between two builds appear near the end of the list, instead of near
# the beginning. This makes a difference for Nix builds which export a
# closure for another program to consume, if that program implements its
# own level of binary diffing.
#
# For an example, Docker Images. If each store path is a separate layer
# then Docker Images can be very efficiently transfered between systems,
# and we get very good cache reuse between images built with the same
# version of Nixpkgs. However, since Docker only reliably supports a
# small number of layers (42) it is important to pick the individual
# layers carefully. By storing very popular store paths in the first 40
# layers, we improve the chances that the next Docker image will share
# many of those layers.*
#
# Given the dependency tree:
#
#     A - B - C - D -\
#      \   \   \      \
#       \   \   \      \
#        \   \ - E ---- F
#         \- G
#
# Nodes which have multiple references are duplicated:
#
#     A - B - C - D - F
#      \   \   \
#       \   \   \- E - F
#        \   \
#         \   \- E - F
#          \
#           \- G
#
# Each leaf node is now replaced by a counter defaulted to 1:
#
#     A - B - C - D - (F:1)
#      \   \   \
#       \   \   \- E - (F:1)
#        \   \
#         \   \- E - (F:1)
#          \
#           \- (G:1)
#
# Then each leaf counter is merged with its parent node, replacing the
# parent node with a counter of 1, and each existing counter being
# incremented by 1. That is to say `- D - (F:1)` becomes `- (D:1, F:2)`:
#
#     A - B - C - (D:1, F:2)
#      \   \   \
#       \   \   \- (E:1, F:2)
#        \   \
#         \   \- (E:1, F:2)
#          \
#           \- (G:1)
#
# Then each leaf counter is merged with its parent node again, merging
# any counters, then incrementing each:
#
#     A - B - (C:1, D:2, E:2, F:5)
#      \   \
#       \   \- (E:1, F:2)
#        \
#         \- (G:1)
#
# And again:
#
#     A - (B:1, C:2, D:3, E:4, F:8)
#      \
#       \- (G:1)
#
# And again:
#
#     (A:1, B:2, C:3, D:4, E:5, F:9, G:2)
#
# and then paths have the following "popularity":
#
#     A     1
#     B     2
#     C     3
#     D     4
#     E     5
#     F     9
#     G     2
#
# and the popularity contest would result in the paths being printed as:
#
#     F
#     E
#     D
#     C
#     B
#     G
#     A
#
# * Note: People who have used a Dockerfile before assume Docker's
# Layers are inherently ordered. However, this is not true -- Docker
# layers are content-addressable and are not explicitly layered until
# they are composed in to an Image.

import igraph as igraph

from collections import defaultdict
from operator import eq
from toolz import curried as tlz
from toolz import curry

from .lib import (
    debug,
    directed_graph,
    igraph_to_reference_graph,
    over,
    pick_keys,
    reference_graph_node_keys_to_keep
)

eq = curry(eq)

pick_keys_to_keep = pick_keys(reference_graph_node_keys_to_keep)


# Find paths in the original dataset which are never referenced by
# any other paths
def find_roots(closures):
    debug('closures', closures)
    roots = []

    for closure in closures:
        path = closure['path']
        if not any_refer_to(path, closures):
            roots.append(path)

    return roots


def any_refer_to(path, closures):
    for closure in closures:
        if path != closure['path']:
            if path in closure['references']:
                return True
    return False


def all_paths(closures):
    paths = []
    for closure in closures:
        paths.append(closure['path'])
        paths.extend(closure['references'])
    paths.sort()
    return list(set(paths))


# Convert:
#
# [
#    { path: /nix/store/foo, references: [ /nix/store/foo, /nix/store/bar, /nix/store/baz ] },      # noqa: E501
#    { path: /nix/store/bar, references: [ /nix/store/bar, /nix/store/baz ] },
#    { path: /nix/store/baz, references: [ /nix/store/baz, /nix/store/tux ] },
#    { path: /nix/store/tux, references: [ /nix/store/tux ] }
#  ]
#
# To:
#    {
#      /nix/store/foo: [ /nix/store/bar, /nix/store/baz ],
#      /nix/store/bar: [ /nix/store/baz ],
#      /nix/store/baz: [ /nix/store/tux ] },
#      /nix/store/tux: [ ]
#    }
#
# Note that it drops self-references to avoid loops.


def make_lookup(closures):
    return {
        # remove self reference
        node["path"]: over("references", tlz.remove(eq(node["path"])), node)
        for node in closures
    }


# Convert:
#
# /nix/store/foo with
#  {
#    /nix/store/foo: [ /nix/store/bar, /nix/store/baz ],
#    /nix/store/bar: [ /nix/store/baz ],
#    /nix/store/baz: [ /nix/store/tux ] },
#    /nix/store/tux: [ ]
#  }
#
# To:
#
# {
#   /nix/store/bar: {
#                    /nix/store/baz: {
#                                     /nix/store/tux: {}
#                    }
#   },
#   /nix/store/baz: {
#                   /nix/store/tux: {}
#   }
# }


def make_graph_segment_from_root(subgraphs_cache, root, lookup):
    children = {}
    for ref in lookup[root]:
        # make_graph_segment_from_root is a pure function, and will
        # always return the same result based on a given input. Thus,
        # cache computation.
        #
        # Python's assignment will use a pointer, preventing memory
        # bloat for large graphs.
        if ref not in subgraphs_cache:
            debug("Subgraph Cache miss on {}".format(ref))
            subgraphs_cache[ref] = make_graph_segment_from_root(
                subgraphs_cache, ref, lookup
            )
        else:
            debug("Subgraph Cache hit on {}".format(ref))
        children[ref] = subgraphs_cache[ref]
    return children


# Convert a graph segment in to a popularity-counted dictionary:
#
# From:
# {
#    /nix/store/foo: {
#                      /nix/store/bar: {
#                                        /nix/store/baz: {
#                                                           /nix/store/tux: {}
#                                        }
#                      }
#                      /nix/store/baz: {
#                                         /nix/store/tux: {}
#                      }
#    }
# }
#
# to:
# [
#   /nix/store/foo: 1
#   /nix/store/bar: 2
#   /nix/store/baz: 4
#   /nix/store/tux: 6
# ]

def graph_popularity_contest(popularity_cache, full_graph):
    popularity = defaultdict(int)
    for path, subgraph in full_graph.items():
        popularity[path] += 1
        # graph_popularity_contest is a pure function, and will
        # always return the same result based on a given input. Thus,
        # cache computation.
        #
        # Python's assignment will use a pointer, preventing memory
        # bloat for large graphs.
        if path not in popularity_cache:
            debug("Popularity Cache miss on", path)
            popularity_cache[path] = graph_popularity_contest(
                popularity_cache, subgraph
            )
        else:
            debug("Popularity Cache hit on", path)

        subcontest = popularity_cache[path]
        for subpath, subpopularity in subcontest.items():
            debug("Calculating popularity for", subpath)
            popularity[subpath] += subpopularity + 1

    return popularity

# Emit a list of packages by popularity, most first:
#
# From:
# [
#   /nix/store/foo: 1
#   /nix/store/bar: 1
#   /nix/store/baz: 2
#   /nix/store/tux: 2
# ]
#
# To:
# [ /nix/store/baz /nix/store/tux /nix/store/bar /nix/store/foo ]


def order_by_popularity(paths):
    paths_by_popularity = defaultdict(list)
    popularities = []
    for path, popularity in paths.items():
        popularities.append(popularity)
        paths_by_popularity[popularity].append(path)

    popularities = sorted(set(popularities))

    flat_ordered = []
    for popularity in popularities:
        paths = paths_by_popularity[popularity]
        paths.sort(key=package_name)

        flat_ordered.extend(reversed(paths))
    return list(reversed(flat_ordered))


def package_name(path):
    parts = path.split('-')
    start = parts.pop(0)
    # don't throw away any data, so the order is always the same.
    # even in cases where only the hash at the start has changed.
    parts.append(start)
    return '-'.join(parts)


@curry
def popularity_contest(graph):
    # Data comes in as an igraph directed graph or in the format produced
    # by nix's exportReferencesGraph:
    # [
    #    { path: /nix/store/foo, references: [ /nix/store/foo, /nix/store/bar, /nix/store/baz ] },  # noqa: E501
    #    { path: /nix/store/bar, references: [ /nix/store/bar, /nix/store/baz ] },                  # noqa: E501
    #    { path: /nix/store/baz, references: [ /nix/store/baz, /nix/store/tux ] },                  # noqa: E501
    #    { path: /nix/store/tux, references: [ /nix/store/tux ] }
    #  ]
    #
    # We want to get out a list of paths ordered by how universally,
    # important they are, ie: tux is referenced by every path, transitively
    # so it should be #1
    #
    # [
    #   /nix/store/tux,
    #   /nix/store/baz,
    #   /nix/store/bar,
    #   /nix/store/foo,
    # ]
    #
    # NOTE: the output is actually a list of igraph graphs with a single vertex
    # with v["name"] == path, and some properties (defined in
    # reference_graph_node_keys_to_keep) from the nodes of the input graph
    # copied as vertex attributes.
    debug('graph', graph)

    if isinstance(graph, igraph.Graph):
        graph = igraph_to_reference_graph(graph)

    debug("Finding roots")
    roots = find_roots(graph)

    debug("Making lookup")
    lookup = make_lookup(graph)

    full_graph = {}
    subgraphs_cache = {}
    for root in roots:
        debug("Making full graph for", root)
        full_graph[root] = make_graph_segment_from_root(
            subgraphs_cache,
            root,
            tlz.valmap(
                tlz.get("references"),
                lookup
            )
        )

    debug("Running contest")
    contest = graph_popularity_contest({}, full_graph)

    debug("Ordering by popularity")
    ordered = order_by_popularity(contest)

    debug("Checking for missing paths")
    missing = []

    for path in all_paths(graph):
        if path not in ordered:
            missing.append(path)

    ordered.extend(missing)

    return map(
        # Turn each path into a graph with 1 vertex.
        lambda path: directed_graph(
            # No edges
            [],
            # One vertex, with name=path
            [path],
            # Setting desired attributes on the vertex.
            [(path, pick_keys_to_keep(lookup[path]))]
        ),
        ordered
    )
