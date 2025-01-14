# IMPORTANT: Making changes?
#
# Validate your changes with python3 ./closure-graph.py --test


# Using a simple algorithm, convert the references to a path in to a
# sorted list of dependent paths based on how often they're referenced
# and how deep in the tree they live. Equally-"popular" paths are then
# sorted by name.
#
# The existing writeClosure prints the paths in a simple ascii-based
# sorting of the paths.
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

import sys
import json
import unittest

from pprint import pprint
from collections import defaultdict


def debug(msg, *args, **kwargs):
    if False:
        print(
            "DEBUG: {}".format(
                msg.format(*args, **kwargs)
            ),
            file=sys.stderr
        )


# Find paths in the original dataset which are never referenced by
# any other paths
def find_roots(closures):
    roots = [];

    for closure in closures:
        path = closure['path']
        if not any_refer_to(path, closures):
            roots.append(path)

    return roots

class TestFindRoots(unittest.TestCase):
    def test_find_roots(self):
        self.assertCountEqual(
            find_roots([
                {
                    "path": "/nix/store/foo",
                    "references": [
                        "/nix/store/foo",
                        "/nix/store/bar"
                    ]
                },
                {
                    "path": "/nix/store/bar",
                    "references": [
                        "/nix/store/bar",
                        "/nix/store/tux"
                    ]
                },
                {
                    "path": "/nix/store/hello",
                    "references": [
                    ]
                }
            ]),
            ["/nix/store/foo", "/nix/store/hello"]
        )


def any_refer_to(path, closures):
    for closure in closures:
        if path != closure['path']:
            if path in closure['references']:
                return True
    return False

class TestAnyReferTo(unittest.TestCase):
    def test_has_references(self):
        self.assertTrue(
            any_refer_to(
                "/nix/store/bar",
                [
                    {
                        "path": "/nix/store/foo",
                        "references": [
                            "/nix/store/bar"
                        ]
                    },
                ]
            ),
        )
    def test_no_references(self):
        self.assertFalse(
            any_refer_to(
                "/nix/store/foo",
                [
                    {
                        "path": "/nix/store/foo",
                        "references": [
                            "/nix/store/foo",
                            "/nix/store/bar"
                        ]
                    },
                ]
            ),
        )

def all_paths(closures):
    paths = []
    for closure in closures:
        paths.append(closure['path'])
        paths.extend(closure['references'])
    paths.sort()
    return list(set(paths))


class TestAllPaths(unittest.TestCase):
    def test_returns_all_paths(self):
        self.assertCountEqual(
            all_paths([
                {
                    "path": "/nix/store/foo",
                    "references": [
                        "/nix/store/foo",
                        "/nix/store/bar"
                    ]
                },
                {
                    "path": "/nix/store/bar",
                    "references": [
                        "/nix/store/bar",
                        "/nix/store/tux"
                    ]
                },
                {
                    "path": "/nix/store/hello",
                    "references": [
                    ]
                }
            ]),
            ["/nix/store/foo", "/nix/store/bar", "/nix/store/hello", "/nix/store/tux",]
        )
    def test_no_references(self):
        self.assertFalse(
            any_refer_to(
                "/nix/store/foo",
                [
                    {
                        "path": "/nix/store/foo",
                        "references": [
                            "/nix/store/foo",
                            "/nix/store/bar"
                        ]
                    },
                ]
            ),
        )

# Convert:
#
# [
#    { path: /nix/store/foo, references: [ /nix/store/foo, /nix/store/bar, /nix/store/baz ] },
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
    lookup = {}

    for closure in closures:
        # paths often self-refer
        nonreferential_paths = [ref for ref in closure['references'] if ref != closure['path']]
        lookup[closure['path']] = nonreferential_paths

    return lookup

class TestMakeLookup(unittest.TestCase):
    def test_returns_lookp(self):
        self.assertDictEqual(
            make_lookup([
                {
                    "path": "/nix/store/foo",
                    "references": [
                        "/nix/store/foo",
                        "/nix/store/bar"
                    ]
                },
                {
                    "path": "/nix/store/bar",
                    "references": [
                        "/nix/store/bar",
                        "/nix/store/tux"
                    ]
                },
                {
                    "path": "/nix/store/hello",
                    "references": [
                    ]
                }
            ]),
            {
                "/nix/store/foo": [ "/nix/store/bar" ],
                "/nix/store/bar": [ "/nix/store/tux" ],
                "/nix/store/hello": [ ],
            }
        )

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
subgraphs_cache = {}
def make_graph_segment_from_root(root, lookup):
    global subgraphs_cache
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
            subgraphs_cache[ref] = make_graph_segment_from_root(ref, lookup)
        else:
            debug("Subgraph Cache hit on {}".format(ref))
        children[ref] = subgraphs_cache[ref]
    return children

class TestMakeGraphSegmentFromRoot(unittest.TestCase):
    def test_returns_graph(self):
        self.assertDictEqual(
            make_graph_segment_from_root("/nix/store/foo", {
                "/nix/store/foo": [ "/nix/store/bar" ],
                "/nix/store/bar": [ "/nix/store/tux" ],
                "/nix/store/tux": [ ],
                "/nix/store/hello": [ ],
            }),
            {
                "/nix/store/bar": {
                    "/nix/store/tux": {}
                }
            }
        )
    def test_returns_graph_tiny(self):
        self.assertDictEqual(
            make_graph_segment_from_root("/nix/store/tux", {
                "/nix/store/foo": [ "/nix/store/bar" ],
                "/nix/store/bar": [ "/nix/store/tux" ],
                "/nix/store/tux": [ ],
            }),
            {}
        )

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
popularity_cache = {}
def graph_popularity_contest(full_graph):
    global popularity_cache
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
            debug("Popularity Cache miss on {}", path)
            popularity_cache[path] = graph_popularity_contest(subgraph)
        else:
            debug("Popularity Cache hit on {}", path)

        subcontest = popularity_cache[path]
        for subpath, subpopularity in subcontest.items():
            debug("Calculating popularity for {}", subpath)
            popularity[subpath] += subpopularity + 1

    return popularity

class TestGraphPopularityContest(unittest.TestCase):
    def test_counts_popularity(self):
        self.assertDictEqual(
            graph_popularity_contest({
                "/nix/store/foo": {
                    "/nix/store/bar": {
                        "/nix/store/baz": {
                            "/nix/store/tux": {}
                        }
                    },
                    "/nix/store/baz": {
                        "/nix/store/tux": {}
                    }
                }
            }),
            {
                   "/nix/store/foo": 1,
                   "/nix/store/bar": 2,
                   "/nix/store/baz": 4,
                   "/nix/store/tux": 6,
            }
        )

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

    popularities = list(set(popularities))
    popularities.sort()

    flat_ordered = []
    for popularity in popularities:
        paths = paths_by_popularity[popularity]
        paths.sort(key=package_name)

        flat_ordered.extend(reversed(paths))
    return list(reversed(flat_ordered))


class TestOrderByPopularity(unittest.TestCase):
    def test_returns_in_order(self):
        self.assertEqual(
            order_by_popularity({
                   "/nix/store/foo": 1,
                   "/nix/store/bar": 1,
                   "/nix/store/baz": 2,
                   "/nix/store/tux": 2,
            }),
            [
                "/nix/store/baz",
                "/nix/store/tux",
                "/nix/store/bar",
                "/nix/store/foo"
            ]
        )

def package_name(path):
    parts = path.split('-')
    start = parts.pop(0)
    # don't throw away any data, so the order is always the same.
    # even in cases where only the hash at the start has changed.
    parts.append(start)
    return '-'.join(parts)

def main():
    filename = sys.argv[1]
    key = sys.argv[2]

    debug("Loading from {}", filename)
    with open(filename) as f:
        data = json.load(f)

    # Data comes in as:
    # [
    #    { path: /nix/store/foo, references: [ /nix/store/foo, /nix/store/bar, /nix/store/baz ] },
    #    { path: /nix/store/bar, references: [ /nix/store/bar, /nix/store/baz ] },
    #    { path: /nix/store/baz, references: [ /nix/store/baz, /nix/store/tux ] },
    #    { path: /nix/store/tux, references: [ /nix/store/tux ] }
    #  ]
    #
    # and we want to get out a list of paths ordered by how universally,
    # important they are, ie: tux is referenced by every path, transitively
    # so it should be #1
    #
    # [
    #   /nix/store/tux,
    #   /nix/store/baz,
    #   /nix/store/bar,
    #   /nix/store/foo,
    # ]
    graph = data[key]

    debug("Finding roots from {}", key)
    roots = find_roots(graph);
    debug("Making lookup for {}", key)
    lookup = make_lookup(graph)

    full_graph = {}
    for root in roots:
        debug("Making full graph for {}", root)
        full_graph[root] = make_graph_segment_from_root(root, lookup)

    debug("Running contest")
    contest = graph_popularity_contest(full_graph)
    debug("Ordering by popularity")
    ordered = order_by_popularity(contest)
    debug("Checking for missing paths")
    missing = []
    for path in all_paths(graph):
        if path not in ordered:
            missing.append(path)

    ordered.extend(missing)
    print("\n".join(ordered))

if "--test" in sys.argv:
    # Don't pass --test otherwise unittest gets mad
    unittest.main(argv = [f for f in sys.argv if f != "--test" ])
else:
    main()
