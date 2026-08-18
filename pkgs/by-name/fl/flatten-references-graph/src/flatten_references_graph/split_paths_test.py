import unittest
from toolz import curry

from . import test_helpers as th

from .split_paths import (
    split_paths
)

from .lib import (
    directed_graph,
    pick_keys
)


if __name__ == "__main__":
    unittest.main()


# Making sure vertex attrs are preserved.
vertex_props_dict = {
    "Root1": {"a": 1, "b": 1},
    "B": {"b": 2},
    "X": {"x": 3}
}


def make_test_graph():
    edges = [
        ("Root1", "A"),
        ("A", "B"),
        ("A", "D"),
        ("D", "E"),
        ("B", "D"),
        ("B", "F"),
        ("Root2", "B"),
        ("Root3", "C")
    ]

    detached_vertices = ["X"]

    vertex_props = vertex_props_dict.items()

    return directed_graph(edges, detached_vertices, vertex_props)


class CustomAssertions:
    @curry
    def assertResultKeys(self, keys, result):
        self.assertListEqual(
            list(result.keys()),
            keys
        )

        return result


class Test(
    unittest.TestCase,
    CustomAssertions,
    th.CustomAssertions
):

    def test_empty_paths(self):
        input_graph = make_test_graph()

        result = self.assertResultKeys(
            ["rest"],
            split_paths([], input_graph)
        )

        self.assertGraphEqual(
            result["rest"],
            input_graph
        )

    def test_empty_graph(self):
        empty_graph = directed_graph([])

        def test_empty(paths):
            result = self.assertResultKeys(
                ["rest"],
                split_paths(paths, empty_graph)
            )

            self.assertGraphEqual(
                result["rest"],
                empty_graph
            )

        test_empty([])
        test_empty(["B"])

    def test_split_paths_single(self):
        result = self.assertResultKeys(
            ["main", "common", "rest"],
            split_paths(["B"], make_test_graph())
        )

        self.assertGraphEqual(
            result["main"],
            directed_graph(
                [
                    ("B", "F")
                ],
                None,
                pick_keys(["B"], vertex_props_dict).items()
            )
        )

        self.assertGraphEqual(
            result["rest"],
            directed_graph(
                [
                    ("Root1", "A"),
                    ("Root3", "C")
                ],
                ["Root2", "X"],
                pick_keys(["Root1", "X"], vertex_props_dict).items()
            )
        )

        self.assertGraphEqual(
            result["common"],
            directed_graph([("D", "E")])
        )

    def test_split_paths_multi(self):
        result = self.assertResultKeys(
            ["main", "common", "rest"],
            split_paths(["B", "Root3"], make_test_graph())
        )

        self.assertGraphEqual(
            result["main"],
            directed_graph(
                [
                    ("B", "F"),
                    ("Root3", "C")
                ],
                None,
                pick_keys(["B"], vertex_props_dict).items()
            )
        )

        self.assertGraphEqual(
            result["rest"],
            directed_graph(
                [("Root1", "A")],
                ["Root2", "X"],
                pick_keys(["Root1", "X"], vertex_props_dict).items()
            )
        )

        self.assertGraphEqual(
            result["common"],
            directed_graph([("D", "E")])
        )

    def test_split_no_common(self):
        result = self.assertResultKeys(
            ["main", "rest"],
            split_paths(["D"], make_test_graph())
        )

        self.assertGraphEqual(
            result["main"],
            directed_graph([("D", "E")])
        )

        self.assertGraphEqual(
            result["rest"],
            directed_graph(
                [
                    ("Root1", "A"),
                    ("A", "B"),
                    ("B", "F"),
                    ("Root2", "B"),
                    ("Root3", "C"),
                ],
                ["X"],
                pick_keys(["Root1", "B", "X"], vertex_props_dict).items()
            )
        )
