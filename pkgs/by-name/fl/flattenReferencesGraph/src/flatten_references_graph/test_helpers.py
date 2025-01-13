from toolz import curried as tlz

from .lib import (
    not_None,
    graph_vertex_index_to_name
)


def edges_as_set(graph):
    return frozenset(
        (
            graph_vertex_index_to_name(graph, e.source),
            graph_vertex_index_to_name(graph, e.target)
        ) for e in graph.es
    )


class CustomAssertions:
    def assertGraphEqual(self, g1, g2):
        self.assertSetEqual(
            frozenset(g1.vs["name"]),
            frozenset(g2.vs["name"])
        )

        self.assertSetEqual(
            edges_as_set(g1),
            edges_as_set(g2)
        )

        for name in g1.vs["name"]:
            def get_vertex_attrs(g):
                return tlz.valfilter(not_None, g.vs.find(name).attributes())

            self.assertDictEqual(
                get_vertex_attrs(g1),
                get_vertex_attrs(g2),
            )
