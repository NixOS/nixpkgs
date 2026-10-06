import unittest

from toolz import curried as tlz

from . import test_helpers as th

from .lib import (
    directed_graph,
    igraph_to_reference_graph,
    limit_layers,
    pick_keys,
    references_graph_to_igraph,
    reference_graph_node_keys_to_keep,
    reorder
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


class TestReorder(unittest.TestCase):

    def test_reorder_two_keys_swaps_main_and_rest(self):
        g1 = directed_graph([], ["A"])
        g2 = directed_graph([], ["B"])
        d = {"main": g1, "rest": g2}
        result = reorder(["rest", "main"], d)
        self.assertEqual(list(result.keys()), ["rest", "main"])
        self.assertIs(result["rest"], g2)
        self.assertIs(result["main"], g1)

    def test_reorder_three_keys_split_paths_order(self):
        g_main   = directed_graph([], ["A"])
        g_common = directed_graph([], ["B"])
        g_rest   = directed_graph([], ["C"])
        d = {"main": g_main, "common": g_common, "rest": g_rest}
        result = reorder(["rest", "common", "main"], d)
        self.assertEqual(list(result.keys()), ["rest", "common", "main"])

    def test_reorder_missing_keys_are_ignored(self):
        g1 = directed_graph([], ["A"])
        g2 = directed_graph([], ["B"])
        d = {"main": g1, "rest": g2}
        # "common" is not in dict — should be silently skipped
        result = reorder(["rest", "common", "main"], d)
        self.assertEqual(list(result.keys()), ["rest", "main"])

    def test_reorder_extra_keys_appended_in_original_order(self):
        g1 = directed_graph([], ["A"])
        g2 = directed_graph([], ["B"])
        g3 = directed_graph([], ["C"])
        g4 = directed_graph([], ["D"])
        d = {"main": g1, "rest": g2, "extra1": g3, "extra2": g4}
        result = reorder(["rest", "main"], d)
        self.assertEqual(list(result.keys()), ["rest", "main", "extra1", "extra2"])

    def test_reorder_non_dict_passthrough(self):
        graphs = [directed_graph([], ["A"]), directed_graph([], ["B"])]
        result = reorder(["rest", "main"], graphs)
        self.assertIs(result, graphs)
