import unittest

from . import test_helpers as th

from .subcomponent import (
    subcomponent_out,
    subcomponent_in
)

from .lib import (
    pick_keys,
    directed_graph,
    empty_directed_graph
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
        ("A", "C"),
        ("B", "D"),
        ("B", "E"),
        ("Root2", "B"),
        ("Root3", "C"),
    ]

    detached_vertices = ["X"]

    vertex_props = vertex_props_dict.items()

    return directed_graph(edges, detached_vertices, vertex_props)


class CustomAssertions:
    def assertResultKeys(self, result):
        self.assertListEqual(
            list(result.keys()),
            ["main", "rest"]
        )

        return result


class Test(
    unittest.TestCase,
    CustomAssertions,
    th.CustomAssertions
):

    def test_empty_paths(self):
        def test(func):
            input_graph = make_test_graph()

            result = self.assertResultKeys(
                func([], input_graph)
            )

            self.assertGraphEqual(
                result["main"],
                empty_directed_graph()
            )

            self.assertGraphEqual(
                result["rest"],
                input_graph
            )

        test(subcomponent_out)
        test(subcomponent_in)

    def test_empty_graph(self):
        def test(func):
            empty_graph = empty_directed_graph()

            def test_empty(paths):
                result = self.assertResultKeys(
                    func(paths, empty_graph)
                )

                self.assertGraphEqual(
                    result["main"],
                    empty_graph
                )

                self.assertGraphEqual(
                    result["rest"],
                    empty_graph
                )

            test_empty([])
            test_empty(["B"])

        test(subcomponent_out)
        test(subcomponent_in)

    def test_subcomponent_out(self):
        result = self.assertResultKeys(
            subcomponent_out(["B"], make_test_graph())
        )

        self.assertGraphEqual(
            result["main"],
            directed_graph(
                [
                    ("B", "D"),
                    ("B", "E")
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
                    ("A", "C"),
                    ("Root3", "C")
                ],
                ["Root2", "X"],
                pick_keys(["Root1", "X"], vertex_props_dict).items()
            )
        )

    def test_subcomponent_out_multi(self):
        result = self.assertResultKeys(
            subcomponent_out(["B", "Root3"], make_test_graph())
        )

        self.assertGraphEqual(
            result["main"],
            directed_graph(
                [
                    ("B", "D"),
                    ("B", "E"),
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

    def test_subcomponent_in(self):
        result = self.assertResultKeys(
            subcomponent_in(["B"], make_test_graph())
        )

        self.assertGraphEqual(
            result["main"],
            directed_graph(
                [
                    ("Root1", "A"),
                    ("A", "B"),
                    ("Root2", "B")
                ],
                None,
                pick_keys(["Root1", "B"], vertex_props_dict).items()
            )
        )

        self.assertGraphEqual(
            result["rest"],
            directed_graph(
                [("Root3", "C")],
                ["D", "E", "X"],
                pick_keys(["X"], vertex_props_dict).items()
            )
        )

    def test_subcomponent_in_multi(self):
        result = self.assertResultKeys(
            subcomponent_in(["B", "Root3"], make_test_graph())
        )

        self.assertGraphEqual(
            result["main"],
            directed_graph(
                [
                    ("Root1", "A"),
                    ("A", "B"),
                    ("Root2", "B"),
                ],
                ["Root3"],
                pick_keys(["Root1", "B"], vertex_props_dict).items()

            )
        )

        self.assertGraphEqual(
            result["rest"],
            directed_graph(
                [],
                ["C", "D", "E", "X"],
                pick_keys(["X"], vertex_props_dict).items()
            )
        )
