from toolz import curried as tlz
from toolz import curry

from .lib import (
    debug,
    debug_plot,
    DEBUG_PLOT,
    find_vertex_by_name_or_none,
    graph_is_empty,
    is_None,
    subcomponent_multi,
    unnest_iterable
)


@curry
def coerce_to_singly_rooted_graph(fake_root_name, graph):
    """Add single root to the graph connected to all existing roots.

    If graph has only one root, return the graph unchanged and the name
    of the root vertex.

    Otherwise return a modified graph (copy) and a name of the added root
    vertex.
    """
    roots = graph.vs.select(lambda v: len(graph.predecessors(v)) == 0)
    root_names = roots["name"]

    if len(root_names) == 1:
        return graph, root_names[0]
    else:
        edges = [(fake_root_name, v) for v in root_names]
        graph_with_root = graph + fake_root_name + edges
        return graph_with_root, fake_root_name


@curry
def remove_vertex(vertex_name, graph):
    """Remove vertex with given name, returning copy of input graph if vertex
    with given name is found in the graph
    """
    vertex = find_vertex_by_name_or_none(graph)(vertex_name)

    return graph - vertex_name if vertex else graph


def get_children_of(graph, vertex_names):
    return unnest_iterable(map(
        graph.successors,
        tlz.remove(
            is_None,
            map(
                find_vertex_by_name_or_none(graph),
                vertex_names
            )
        )
    ))


def as_list(x):
    return x if isinstance(x, list) else [x]


@curry
def split_path_spec_to_indices(graph, split_path_spec):
    debug("split_path_spec", split_path_spec)
    if isinstance(split_path_spec, dict):
        if "children_of" in split_path_spec:
            children_of = split_path_spec["children_of"]

            return get_children_of(graph, as_list(children_of))
        else:
            raise Exception(
                "Unexpected split path spec: dict with invalid keys."
                "Valid: [\"children_of\"]"
            )
    else:
        vertex = find_vertex_by_name_or_none(graph)(split_path_spec)
        return [] if is_None(vertex) else [vertex.index]


call_count = 0


@curry
def split_paths(split_paths, graph_in):
    debug("____")
    debug("split_paths:", split_paths)
    debug("graph_in:", graph_in)

    if DEBUG_PLOT:
        global call_count
        graph_name_prefix = f"split_paths_{call_count}_"
        call_count += 1

    # Convert list of split_paths into list of vertex indices. Ignores
    # split_paths which don"t match any vertices in the graph.
    # All edges pointing at the indices will be deleted from the graph.
    split_path_indices = list(unnest_iterable(map(
        split_path_spec_to_indices(graph_in),
        split_paths
    )))

    debug("split_path_indices:", split_path_indices)

    # Short circuit if there is nothing to do (split_paths didn"t match any
    # vertices in the graph).
    if len(split_path_indices) == 0:
        if DEBUG_PLOT:
            layout = graph_in.layout('tree')
            debug_plot(graph_in, f"{graph_name_prefix}input", layout=layout)
            debug_plot(graph_in, f"{graph_name_prefix}result", layout=layout)

        return {"rest": graph_in}

    # If graph has multiple roots, add a single one connecting all existing
    # roots to make it easy to split the graph into 2 sets of vertices after
    # deleting edges pointing at split_path_indices.
    fake_root_name = "__root__"
    graph, root_name = coerce_to_singly_rooted_graph(fake_root_name, graph_in)

    debug("root_name", root_name)

    if (
        find_vertex_by_name_or_none(graph)(root_name).index
        in split_path_indices
    ):
        if DEBUG_PLOT:
            layout = graph_in.layout('tree')
            debug_plot(graph_in, f"{graph_name_prefix}input", layout=layout)
            debug_plot(
                graph_in,
                f"{graph_name_prefix}result",
                layout=layout,
                vertex_color="green"
            )

        return {"main": graph_in}

    # Copy graph if coerce_to_singly_rooted_graph has not already created
    # a copy, since we are going to mutate the graph and don"t want to
    # mutate a function argument.
    graph = graph if graph is not graph_in else graph.copy()

    if DEBUG_PLOT:
        layout = graph.layout('tree')
        debug_plot(graph, f"{graph_name_prefix}input", layout=layout)

    # Get incidences of all vertices which can be reached split_path_indices
    # (including split_path_indices). This is a set of all split_paths and their
    # dependencies.
    split_off_vertex_indices = frozenset(
        subcomponent_multi(graph, split_path_indices))
    debug("split_off_vertex_indices", split_off_vertex_indices)

    # Delete edges which point at any of the vertices in split_path_indices.
    graph.delete_edges(_target_in=split_path_indices)

    if DEBUG_PLOT:
        debug_plot(graph, f"{graph_name_prefix}deleted_edges", layout=layout)

    # Get incidences of all vertices which can be reached from the root. Since
    # edges pointing at split_path_indices have been deleted, none of the
    # split_path_indices will be included. Dependencies of rest_with_common will
    # only be included if they can be reached from any vertex which is itself
    # not in split_off_vertex_indices.
    rest_with_common = frozenset(graph.subcomponent(root_name, mode="out"))
    debug("rest_with_common", rest_with_common)

    # Get a set of all dependencies common to split_path_indices and the rest
    # of the graph.
    common = split_off_vertex_indices.intersection(rest_with_common)
    debug("common", common)

    # Get a set of vertices which cannot be reached from split_path_indices.
    rest_without_common = rest_with_common.difference(common)
    debug("rest_without_common", rest_without_common)

    # Get a set of split_path_indices and their dependencies which cannot be
    # reached from the rest of the graph.
    split_off_without_common = split_off_vertex_indices.difference(common)
    debug("split_off_without_common", split_off_without_common)

    if DEBUG_PLOT:
        def choose_color(index):
            if (index in split_off_without_common):
                return "green"
            elif (index in rest_without_common):
                return "red"
            else:
                return "purple"

        vertex_color = [choose_color(v.index) for v in graph.vs]

        debug_plot(
            graph,
            f"{graph_name_prefix}result",
            layout=layout,
            vertex_color=vertex_color
        )

    # Return subgraphs based on calculated sets of vertices.

    result_keys = ["main", "common", "rest"]
    result_values = [
        # Split paths and their deps (unreachable from rest of the graph).
        graph.induced_subgraph(split_off_without_common),
        # Dependencies of split paths which can be reached from the rest of the
        # graph.
        graph.induced_subgraph(common),
        # Rest of the graph (without dependencies common with split paths).
        graph.induced_subgraph(rest_without_common),
    ]

    debug('result_values', result_values[0].vs["name"])

    return tlz.valfilter(
        tlz.complement(graph_is_empty),
        dict(zip(
            result_keys,
            (
                result_values if root_name != fake_root_name
                # If root was added, remove it
                else tlz.map(remove_vertex(fake_root_name), result_values)
            )
        ))
    )
