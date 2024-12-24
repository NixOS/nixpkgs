import unittest
from toolz import curry
from toolz import curried as tlz

from . import test_helpers as th

from .popularity_contest import (
    all_paths,
    any_refer_to,
    find_roots,
    graph_popularity_contest,
    make_graph_segment_from_root,
    make_lookup,
    popularity_contest,
    order_by_popularity
)

from .lib import (
    directed_graph,
    igraph_to_reference_graph,
    over
)


if __name__ == "__main__":
    unittest.main()


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

    def test_empty_graph(self):
        def test_empty(graph):
            self.assertListEqual(
                list(popularity_contest(graph)),
                []
            )

        # popularity_contest works with igraph graph or refurence_graph in
        # form a list of dicts (as returned by nix's exportReferencesGraph)
        test_empty(directed_graph([]))
        test_empty([])

    def test_popularity_contest(self):
        # Making sure vertex attrs are preserved.
        vertex_props_dict = {
            "Root1": {"narSize": 1, "closureSize": 2},
            "B": {"narSize": 3, "closureSize": 4},
            "X": {"narSize": 5, "closureSize": 6},
        }
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

        def test(graph):
            result = list(popularity_contest(graph))

            expected_paths = [
                'E',
                'D',
                'F',
                'B',
                'A',
                'C',
                'Root1',
                'Root2',
                'Root3',
                'X'
            ]

            self.assertEqual(
                len(result),
                len(expected_paths)
            )

            for (index, path) in enumerate(expected_paths):
                path_props = vertex_props_dict.get(path) or {}

                self.assertGraphEqual(
                    result[index],
                    directed_graph([], [path], [(path, path_props)])
                )

        graph = directed_graph(edges, detached_vertices, vertex_props)

        test(graph)
        test(igraph_to_reference_graph(graph))


class TestFindRoots(unittest.TestCase):
    def test_find_roots(self):
        self.assertCountEqual(
            find_roots([
                {
                    "path": "/nix/store/foo",
                    "references": [
                        "/nix/store/foo",
                        "/nix/store/bar"
                    ]
                },
                {
                    "path": "/nix/store/bar",
                    "references": [
                        "/nix/store/bar",
                        "/nix/store/tux"
                    ]
                },
                {
                    "path": "/nix/store/hello",
                    "references": [
                    ]
                }
            ]),
            ["/nix/store/foo", "/nix/store/hello"]
        )


class TestAnyReferTo(unittest.TestCase):
    def test_has_references(self):
        self.assertTrue(
            any_refer_to(
                "/nix/store/bar",
                [
                    {
                        "path": "/nix/store/foo",
                        "references": [
                            "/nix/store/bar"
                        ]
                    },
                ]
            ),
        )

    def test_no_references(self):
        self.assertFalse(
            any_refer_to(
                "/nix/store/foo",
                [
                    {
                        "path": "/nix/store/foo",
                        "references": [
                            "/nix/store/foo",
                            "/nix/store/bar"
                        ]
                    },
                ]
            ),
        )


class TestAllPaths(unittest.TestCase):
    def test_returns_all_paths(self):
        self.assertCountEqual(
            all_paths([
                {
                    "path": "/nix/store/foo",
                    "references": [
                        "/nix/store/foo",
                        "/nix/store/bar"
                    ]
                },
                {
                    "path": "/nix/store/bar",
                    "references": [
                        "/nix/store/bar",
                        "/nix/store/tux"
                    ]
                },
                {
                    "path": "/nix/store/hello",
                    "references": [
                    ]
                }
            ]),
            ["/nix/store/foo", "/nix/store/bar",
                "/nix/store/hello", "/nix/store/tux", ]
        )

    def test_no_references(self):
        self.assertFalse(
            any_refer_to(
                "/nix/store/foo",
                [
                    {
                        "path": "/nix/store/foo",
                        "references": [
                            "/nix/store/foo",
                            "/nix/store/bar"
                        ]
                    },
                ]
            ),
        )


class TestMakeLookup(unittest.TestCase):
    def test_returns_lookp(self):
        self.assertDictEqual(
            # "references" in the result are iterators so we need
            # to convert them to a list before asserting.
            tlz.valmap(over("references", list), make_lookup([
                {
                    "path": "/nix/store/foo",
                    "references": [
                        "/nix/store/foo",
                        "/nix/store/bar",
                        "/nix/store/hello"
                    ]
                },
                {
                    "path": "/nix/store/bar",
                    "references": [
                        "/nix/store/bar",
                        "/nix/store/tux"
                    ]
                },
                {
                    "path": "/nix/store/hello",
                    "references": [
                    ]
                }
            ])),
            {
                "/nix/store/foo": {
                    "path": "/nix/store/foo",
                    "references": [
                        "/nix/store/bar",
                        "/nix/store/hello"
                    ]
                },
                "/nix/store/bar": {
                    "path": "/nix/store/bar",
                    "references": [
                        "/nix/store/tux"
                    ]
                },
                "/nix/store/hello": {
                    "path": "/nix/store/hello",
                    "references": [
                    ]
                }
            }
        )


class TestMakeGraphSegmentFromRoot(unittest.TestCase):
    def test_returns_graph(self):
        self.assertDictEqual(
            make_graph_segment_from_root({}, "/nix/store/foo", {
                "/nix/store/foo": ["/nix/store/bar"],
                "/nix/store/bar": ["/nix/store/tux"],
                "/nix/store/tux": [],
                "/nix/store/hello": [],
            }),
            {
                "/nix/store/bar": {
                    "/nix/store/tux": {}
                }
            }
        )

    def test_returns_graph_tiny(self):
        self.assertDictEqual(
            make_graph_segment_from_root({}, "/nix/store/tux", {
                "/nix/store/foo": ["/nix/store/bar"],
                "/nix/store/bar": ["/nix/store/tux"],
                "/nix/store/tux": [],
            }),
            {}
        )


class TestGraphPopularityContest(unittest.TestCase):
    def test_counts_popularity(self):
        self.assertDictEqual(
            graph_popularity_contest({}, {
                "/nix/store/foo": {
                    "/nix/store/bar": {
                        "/nix/store/baz": {
                            "/nix/store/tux": {}
                        }
                    },
                    "/nix/store/baz": {
                        "/nix/store/tux": {}
                    }
                }
            }),
            {
                "/nix/store/foo": 1,
                "/nix/store/bar": 2,
                "/nix/store/baz": 4,
                "/nix/store/tux": 6,
            }
        )


class TestOrderByPopularity(unittest.TestCase):
    def test_returns_in_order(self):
        self.assertEqual(
            order_by_popularity({
                "/nix/store/foo": 1,
                "/nix/store/bar": 1,
                "/nix/store/baz": 2,
                "/nix/store/tux": 2,
            }),
            [
                "/nix/store/baz",
                "/nix/store/tux",
                "/nix/store/bar",
                "/nix/store/foo"
            ]
        )
