import unittest
from .flatten_references_graph import flatten_references_graph
# from .lib import path_relative_to_file, load_json

if __name__ == "__main__":
    unittest.main()

references_graph = [
    {
        "closureSize": 1,
        "narHash": "sha256:a",
        "narSize": 2,
        "path": "A",
        "references": [
            "A",
            "C",
        ]
    },
    {
        "closureSize": 3,
        "narHash": "sha256:b",
        "narSize": 4,
        "path": "B",
        "references": [
            "C",
            "D"
        ]
    },
    {
        "closureSize": 5,
        "narHash": "sha256:c",
        "narSize": 6,
        "path": "C",
        "references": [
            "C"
        ]
    },
    {
        "closureSize": 7,
        "narHash": "sha256:d",
        "narSize": 8,
        "path": "D",
        "references": [
            "D"
        ]
    }
]


class Test(unittest.TestCase):

    def test_flatten_references_graph(self):
        pipeline = [
            ["split_paths", ["B"]],
        ]

        result = flatten_references_graph(references_graph, pipeline)

        self.assertEqual(
            result,
            [
                # B and it's exclusive deps
                ["B", "D"],
                # Common deps
                ["C"],
                # Rest (without common deps)
                ["A"]
            ]
        )

        pipeline = [
            ["split_paths", ["B"]],
            ["over", "main", ["subcomponent_in", ["B"]]],
        ]

        result = flatten_references_graph(references_graph, pipeline)

        self.assertEqual(
            result,
            [
                ["B"],
                ["D"],
                ["C"],
                ["A"]
            ]
        )

    def test_flatten_references_graph_exclude_paths(self):
        pipeline = [
            ["split_paths", ["B"]],
        ]

        result = flatten_references_graph(
            references_graph,
            pipeline,
            exclude_paths=["A"]
        )

        self.assertEqual(
            result,
            [
                # A was excluded so there is no "rest" or "common" layer
                ["B", "C", "D"]
            ]
        )

        result = flatten_references_graph(
            references_graph,
            pipeline,
            exclude_paths=["D"]
        )

        self.assertEqual(
            result,
            [
                # D removed from this layer
                ["B"],
                ["C"],
                ["A"]
            ]
        )
