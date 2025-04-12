import unittest
from .pipe import pipe

from . import test_helpers as th

from .lib import (
    directed_graph,
)


if __name__ == "__main__":
    unittest.main()


def make_test_graph():
    edges = [
        ("Root1", "A"),
        ("A", "B"),
        ("A", "C"),
        ("B", "D"),
        ("B", "E"),
        ("E", "F"),
        ("B", "G"),
        ("Root2", "B"),
        ("Root3", "C"),
    ]

    return directed_graph(edges)


class CustomAssertions:
    def runAndAssertResult(self, graph, pipeline, expected_graph_args):
        result = list(pipe(pipeline, graph))

        for (index, expected_graph_arg) in enumerate(expected_graph_args):

            self.assertGraphEqual(
                directed_graph(*expected_graph_arg),
                result[index]
            )


if __name__ == "__main__":
    unittest.main()


class Test(
    unittest.TestCase,
    CustomAssertions,
    th.CustomAssertions
):

    def test_1(self):
        pipeline = [
            ["split_paths", ["B"]],
            [
                "over",
                "main",
                [
                    "pipe",
                    [
                        ["subcomponent_in", ["B"]],
                        [
                            "over",
                            "rest",
                            ["popularity_contest"]
                        ]
                    ]
                ]
            ],
            ["flatten"],
            ["map", ["remove_paths", "Root3"]],
            ["limit_layers", 5],
        ]

        expected_graph_args = [
            # "B"" separated from the rest by "split_paths" and
            # "subcomponent_in' stages.
            ([], ["B"]),
            # Deps of "B", split into individual layers by "popularity_contest",
            # with "F" being most popular
            ([], ["F"]),
            ([], ["D"]),
            ([], ["E"]),
            # "rest" output of "split_paths" stage with "G" merged into it by
            # "limit_layers" stage.
            (
                [
                    ("Root1", "A"),
                    ("A", "C")
                ],
                ["Root2", "G"]
            )
        ]

        self.runAndAssertResult(
            make_test_graph(),
            pipeline,
            expected_graph_args
        )

    def test_2(self):
        graph = directed_graph(
            [
                ("Root1", "A"),
                ("A", "B"),
            ],
            ["Root2"]
        )
        self.runAndAssertResult(
            graph,
            [
                ["popularity_contest"],
            ],
            [
                # Ordered from most to least popular
                ([], ["B"]),
                ([], ["A"]),
                ([], ["Root1"]),
                ([], ["Root2"])
            ]
        )

        self.runAndAssertResult(
            graph,
            [
                ["popularity_contest"],
                ["limit_layers", 3],
            ],
            [
                # Most popular first
                ([], ["B"]),
                ([], ["A"]),
                # Least popular combined
                ([], ["Root1", "Root2"]),
            ]
        )

        self.runAndAssertResult(
            graph,
            [
                ["popularity_contest"],
                ["reverse"],
                ["limit_layers", 3],
            ],
            [
                # Least popular first
                ([], ["Root2"]),
                ([], ["Root1"]),
                # Most popular first
                ([], ["A", "B"])
            ]
        )
