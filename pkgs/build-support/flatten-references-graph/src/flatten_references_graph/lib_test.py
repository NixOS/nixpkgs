import unittest

from toolz import curried as tlz

from . import test_helpers as th

from .lib import (
    directed_graph,
    igraph_to_reference_graph,
    pick_keys,
    references_graph_to_igraph,
    reference_graph_node_keys_to_keep
)

if __name__ == "__main__":
    unittest.main()


references_graph = [
    {
        "closureSize": 3,
        "narHash": "sha256:d",
        "narSize": 0,
        "path": "D",
        "references": [
            "D"
        ]
    },
    {
        "closureSize": 3,
        "narHash": "sha256:b",
        "narSize": 4,
        "path": "B",
        "references": [
            "B"
        ]
    },
    {
        "closureSize": 3,
        "narHash": "sha256:e",
        "narSize": 5,
        "path": "E",
        "references": [
            "E"
        ]
    },
    {
        "closureSize": 1,
        "narHash": "sha256:a",
        "narSize": 10,
        "path": "A",
        "references": [
            # most of the time references contain self path, but not always.
            "C",
            "B",
        ]
    },
    {
        "closureSize": 5,
        "narHash": "sha256:c",
        "narSize": 6,
        "path": "C",
        "references": [
            "C",
            "E",
            "D"
        ]
    },
    {
        "closureSize": 5,
        "narHash": "sha256:f",
        "narSize": 2,
        "path": "F",
        "references": [
            "F"
        ]
    }
]


class TestLib(unittest.TestCase, th.CustomAssertions):

    def test_references_graph_to_igraph(self):

        graph = references_graph_to_igraph(references_graph)

        # print(graph)
        # print_vs(graph)
        # print(graph.dfs(find_vertex_by_name_or_none(graph)("A").index))
        # print([
        #     (graph.vs[x]["name"], graph.vs[x]["narSize"]) for x in
        #     graph.dfs(find_vertex_by_name_or_none(graph)("A").index)[0]
        # ])
        # self.assertEqual(3, len(graph.vs))

        pick_preserved_keys = pick_keys(reference_graph_node_keys_to_keep)

        self.assertGraphEqual(
            graph,
            directed_graph(
                [
                    ("A", "B"),
                    ("A", "C"),
                    ("C", "E"),
                    ("C", "D"),
                ],
                ["F"],
                # Add "narSize" and "closureSize" attributes to each node.
                map(
                    lambda node: (node["path"], pick_preserved_keys(node)),
                    references_graph
                )
            )
        )

        return

        def vertex_props_as_array(v):
            return [v["name"], v["closureSize"], v["narSize"]]

        self.assertListEqual(
            vertex_props_as_array(graph.vs[0]),
            ["A", 1, 2]
        )

        self.assertListEqual(
            vertex_props_as_array(graph.vs[1]),
            ["B", 3, 4]
        )

        self.assertListEqual(
            vertex_props_as_array(graph.vs[2]),
            ["C", 5, 6]
        )

        self.assertEqual(3, len(graph.es))

        def edgePropsAsArray(e):
            return [e["source"], e["target"]]

        self.assertListEqual(
            edgePropsAsArray(graph.es[0]),
            ["A", "B"]
        )

        self.assertListEqual(
            edgePropsAsArray(graph.es[1]),
            ["A", "C"]
        )

        self.assertListEqual(
            edgePropsAsArray(graph.es[2]),
            ["B", "C"]
        )

    def test_igraph_to_reference_graph(self):

        graph = references_graph_to_igraph(references_graph)

        nodes_by_path = {
            node["path"]: node for node in references_graph
        }

        result = igraph_to_reference_graph(graph)

        self.assertEqual(
            len(result),
            len(references_graph)
        )

        pick_preserved_keys = pick_keys([
            "path",
            *reference_graph_node_keys_to_keep
        ])

        for node in result:
            original_node = nodes_by_path[node["path"]]

            self.assertDictEqual(
                pick_preserved_keys(original_node),
                pick_preserved_keys(node)
            )

            revove_self_ref = tlz.remove(lambda a: a == node["path"])

            self.assertListEqual(
                sorted(node["references"]),
                sorted(revove_self_ref(original_node["references"]))
            )
