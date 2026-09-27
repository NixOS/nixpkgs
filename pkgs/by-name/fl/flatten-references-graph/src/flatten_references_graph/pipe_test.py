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

    def test_reorder_rest_before_main(self):
        # Verify that ["reorder" ["rest" "main"]] puts the rest-graph layers
        # before the main (split-off) layers, equivalent to the double-reverse
        # workaround but expressed directly.
        #
        # Graph: Root -> A -> B -> D
        #                  -> C
        # Split off B and its deps; rest should come first.
        graph = directed_graph(
            [
                ("Root", "A"),
                ("A", "B"),
                ("A", "C"),
                ("B", "D"),
            ]
        )

        # Without reorder: main (B+D) comes before rest (Root, A, C)
        result_without = list(pipe(
            [
                ["subcomponent_out", ["B"]],
                ["flatten"],
            ],
            graph
        ))
        # main graph contains B and D
        main_names = set(result_without[0].vs["name"])
        self.assertIn("B", main_names)

        # With reorder: rest (Root, A, C) comes before main (B+D)
        result_with = list(pipe(
            [
                ["subcomponent_out", ["B"]],
                ["reorder", ["rest", "main"]],
                ["flatten"],
            ],
            graph
        ))
        rest_names = set(result_with[0].vs["name"])
        self.assertIn("A", rest_names)
        self.assertNotIn("B", rest_names)

    def test_reorder_three_keys_split_paths(self):
        # split_paths returns {"main", "common", "rest"} — verify reorder
        # can express "rest, common, main" ordering for stable shared layers first.
        graph = make_test_graph()
        result = list(pipe(
            [
                ["split_paths", ["B"]],
                ["reorder", ["rest", "common", "main"]],
                ["flatten"],
                ["limit_layers", 3],
            ],
            graph
        ))
        # rest should be first: contains Root1, A, C (no B or its exclusive deps)
        first_names = set(result[0].vs["name"])
        self.assertNotIn("B", first_names)
