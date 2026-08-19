from toolz import curry
from toolz import curried as tlz
from operator import attrgetter

from .lib import (
    debug,
    debug_plot,
    DEBUG_PLOT,
    find_vertex_by_name_or_none,
    is_None,
    subcomponent_multi
)


call_counts = {
    "in": 0,
    "out": 0
}


@curry
def subcomponent(mode, paths, graph):
    if DEBUG_PLOT:
        global call_counts
        graph_name_prefix = f"subcomponent_{mode}_{call_counts[mode]}_"
        call_counts[mode] += 1

        layout = graph.layout('tree')
        debug_plot(graph, f"{graph_name_prefix}input", layout=layout)

    path_indices = tlz.compose(
        tlz.map(attrgetter('index')),
        tlz.remove(is_None),
        tlz.map(find_vertex_by_name_or_none(graph))
    )(paths)

    debug("path_indices", path_indices)

    main_indices = list(subcomponent_multi(graph, path_indices, mode))

    debug('main_indices', main_indices)

    if DEBUG_PLOT:
        def choose_color(index):
            if (index in main_indices):
                return "green"
            else:
                return "red"

        vertex_color = [choose_color(v.index) for v in graph.vs]

        debug_plot(
            graph,
            f"{graph_name_prefix}result",
            layout=layout,
            vertex_color=vertex_color
        )

    return {
        "main": graph.induced_subgraph(main_indices),
        "rest": graph - main_indices
    }


subcomponent_in = subcomponent("in")

subcomponent_out = subcomponent("out")
