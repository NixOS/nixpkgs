from toolz import curried as tlz

from .lib import (
    flatten,
    over,
    references_graph_to_igraph
)

from .pipe import pipe

MAX_LAYERS = 127


def create_list_of_lists_of_strings(deeply_nested_lists_or_dicts_of_graphs):
    list_of_graphs = flatten(deeply_nested_lists_or_dicts_of_graphs)

    return list(
        filter(
            # remove empty layers
            lambda xs: len(xs) > 0,
            tlz.map(
                lambda g: g.vs["name"],
                list_of_graphs
            )
        )
    )


def flatten_references_graph(references_graph, pipeline, exclude_paths=None):
    if exclude_paths is not None:
        exclude_paths = frozenset(exclude_paths)
        references_graph = tlz.compose(
            tlz.map(over(
                "references",
                lambda xs: frozenset(xs).difference(exclude_paths)
            )),
            tlz.remove(lambda node: node["path"] in exclude_paths)
        )(references_graph)

    igraph_graph = references_graph_to_igraph(references_graph)

    return create_list_of_lists_of_strings(pipe(
        pipeline,
        igraph_graph
    ))
