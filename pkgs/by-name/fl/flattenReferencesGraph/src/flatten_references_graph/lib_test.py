import unittest

from toolz import curried as tlz

from . import test_helpers as th

from .lib import (
    directed_graph,
    igraph_to_reference_graph,
    limit_layers,
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

    def test_references_graph_to_igraph_one_node(self):

        references_graph = [
            {
                'closureSize': 168,
                'narHash': 'sha256:0dl4',
                'narSize': 168,
                'path': 'A',
                'references': []
            }
        ]

        graph = references_graph_to_igraph(references_graph)

        pick_preserved_keys = pick_keys(reference_graph_node_keys_to_keep)

        self.assertGraphEqual(
            graph,
            directed_graph(
                [],
                ["A"],
                # Add "narSize" and "closureSize" attributes to each node.
                map(
                    lambda node: (node["path"], pick_preserved_keys(node)),
                    references_graph
                )
            )
        )

    def test_references_graph_to_igraph_zero_nodes(self):

        references_graph = []

        graph = references_graph_to_igraph(references_graph)

        self.assertGraphEqual(
            graph,
            directed_graph(
                [],
                [],
                []
            )
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

    def test_limit_layers_nothing_to_do(self):
        graph = references_graph_to_igraph(references_graph)

        layers = [graph]
        result = limit_layers(1, layers)
        result_list = list(result)

        self.assertEqual(
            len(result_list),
            1
        )

        self.assertGraphEqual(graph, result_list[0])
