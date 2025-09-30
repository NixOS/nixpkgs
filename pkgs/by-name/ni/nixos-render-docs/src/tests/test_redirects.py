import json
import unittest
from pathlib import Path

from nixos_render_docs.manual import HTMLConverter, HTMLParameters
from nixos_render_docs.redirects import Redirects, RedirectsError


class TestRedirects(unittest.TestCase):
    def setup_test(self, sources, raw_redirects):
        with open(Path(__file__).parent / 'index.md', 'w') as infile:
            indexHTML = ["# Redirects test suite {#redirects-test-suite}\n## Setup steps"]
            for path in sources.keys():
                outpath = f"{path.split('.md')[0]}.html"
                indexHTML.append(f"```{{=include=}} appendix html:into-file=//{outpath}\n{path}\n```")
            infile.write("\n".join(indexHTML))

        for filename, content in sources.items():
            with open(Path(__file__).parent / filename, 'w') as infile:
                infile.write(content)

        redirects = Redirects({"redirects-test-suite": ["index.html#redirects-test-suite"]} | raw_redirects, '')
        return HTMLConverter("1.0.0", HTMLParameters("", [], [], 2, 2, 2, Path("")), {}, redirects)

    def run_test(self, md: HTMLConverter):
        md.convert(Path(__file__).parent / 'index.md', Path(__file__).parent / 'index.html')

    def assert_redirect_error(self, expected_errors: dict, md: HTMLConverter):
        with self.assertRaises(RuntimeError) as context:
            self.run_test(md)

        exception = context.exception.__cause__
        self.assertIsInstance(exception, RedirectsError)

        for attr, expected_values in expected_errors.items():
            self.assertTrue(hasattr(exception, attr))
            actual_values = getattr(exception, attr)
            self.assertEqual(set(actual_values), set(expected_values))

    def test_identifier_added(self):
        """Test adding a new identifier to the source."""
        before = self.setup_test(
            sources={"foo.md": "# Foo {#foo}"},
            raw_redirects={"foo": ["foo.html#foo"]},
        )
        self.run_test(before)

        intermediate = self.setup_test(
            sources={"foo.md": "# Foo {#foo}\n## Bar {#bar}"},
            raw_redirects={"foo": ["foo.html#foo"]},
        )
        self.assert_redirect_error({"identifiers_without_redirects": ["bar"]}, intermediate)

        after = self.setup_test(
            sources={"foo.md": "# Foo {#foo}\n## Bar {#bar}"},
            raw_redirects={"foo": ["foo.html#foo"], "bar": ["foo.html#bar"]},
        )
        self.run_test(after)

    def test_identifier_removed(self):
        """Test removing an identifier from the source."""
        before = self.setup_test(
            sources={"foo.md": "# Foo {#foo}\n## Bar {#bar}"},
            raw_redirects={"foo": ["foo.html#foo"], "bar": ["foo.html#bar"]},
        )
        self.run_test(before)

        intermediate = self.setup_test(
            sources={"foo.md": "# Foo {#foo}"},
            raw_redirects={"foo": ["foo.html#foo"], "bar": ["foo.html#bar"]},
        )
        self.assert_redirect_error({"orphan_identifiers": ["bar"]}, intermediate)

        after = self.setup_test(
            sources={"foo.md": "# Foo {#foo}"},
            raw_redirects={"foo": ["foo.html#foo"]},
        )
        self.run_test(after)

    def test_identifier_renamed(self):
        """Test renaming an identifier in the source."""
        before = self.setup_test(
            sources={"foo.md": "# Foo {#foo}\n## Bar {#bar}"},
            raw_redirects={"foo": ["foo.html#foo"], "bar": ["foo.html#bar"]},
        )
        self.run_test(before)

        intermediate = self.setup_test(
            sources={"foo.md": "# Foo Prime {#foo-prime}\n## Bar {#bar}"},
            raw_redirects={"foo": ["foo.html#foo"], "bar": ["foo.html#bar"]},
        )
        self.assert_redirect_error(
            {
                "identifiers_without_redirects": ["foo-prime"],
                "orphan_identifiers": ["foo"]
            },
            intermediate
        )

        after = self.setup_test(
            sources={"foo.md": "# Foo Prime {#foo-prime}\n## Bar {#bar}"},
            raw_redirects={"foo-prime": ["foo.html#foo-prime", "foo.html#foo"], "bar": ["foo.html#bar"]},
        )
        self.run_test(after)

    def test_leaf_identifier_moved_to_different_file(self):
        """Test moving a leaf identifier to a different output path."""
        before = self.setup_test(
            sources={"foo.md": "# Foo {#foo}\n## Bar {#bar}"},
            raw_redirects={"foo": ["foo.html#foo"], "bar": ["foo.html#bar"]},
        )
        self.run_test(before)

        intermediate = self.setup_test(
            sources={
                "foo.md": "# Foo {#foo}",
                "bar.md": "# Bar {#bar}"
            },
            raw_redirects={"foo": ["foo.html#foo"], "bar": ["foo.html#foo"]},
        )
        self.assert_redirect_error({"identifiers_missing_current_outpath": ["bar"]}, intermediate)

        after = self.setup_test(
            sources={
                "foo.md": "# Foo {#foo}",
                "bar.md": "# Bar {#bar}"
            },
            raw_redirects={"foo": ["foo.html#foo"], "bar": ["bar.html#bar", "foo.html#bar"]},
        )
        self.run_test(after)

    def test_non_leaf_identifier_moved_to_different_file(self):
        """Test moving a non-leaf identifier to a different output path."""
        before = self.setup_test(
            sources={"foo.md": "# Foo {#foo}\n## Bar {#bar}\n### Baz {#baz}"},
            raw_redirects={"foo": ["foo.html#foo"], "bar": ["foo.html#bar"], "baz": ["foo.html#baz"]},
        )
        self.run_test(before)

        intermediate = self.setup_test(
            sources={
                "foo.md": "# Foo {#foo}",
                "bar.md": "# Bar {#bar}\n## Baz {#baz}"
            },
            raw_redirects={"foo": ["foo.html#foo"], "bar": ["foo.html#bar"], "baz": ["foo.html#baz"]},
        )
        self.assert_redirect_error({"identifiers_missing_current_outpath": ["bar", "baz"]}, intermediate)

        after = self.setup_test(
            sources={
                "foo.md": "# Foo {#foo}",
                "bar.md": "# Bar {#bar}\n## Baz {#baz}"
            },
            raw_redirects={
                "foo": ["foo.html#foo"],
                "bar": ["bar.html#bar", "foo.html#bar"],
                "baz": ["bar.html#baz", "foo.html#baz"]
            },
        )
        self.run_test(after)

    def test_conflicting_anchors(self):
        """Test for conflicting anchors."""
        md = self.setup_test(
            sources={"foo.md": "# Foo {#foo}\n## Bar {#bar}"},
            raw_redirects={
                "foo": ["foo.html#foo", "foo.html#bar"],
                "bar": ["foo.html#bar"],
            }
        )
        self.assert_redirect_error({"conflicting_anchors": ["bar"]}, md)

    def test_divergent_redirect(self):
        """Test for divergent redirects."""
        md = self.setup_test(
            sources={
                "foo.md": "# Foo {#foo}",
                "bar.md": "# Bar {#bar}"
            },
            raw_redirects={
                "foo": ["foo.html#foo", "old-foo.html"],
                "bar": ["bar.html#bar", "old-foo.html"]
            }
        )
        self.assert_redirect_error({"divergent_redirects": ["old-foo.html"]}, md)

    def test_no_client_redirects(self):
        """Test fetching client side redirects and ignore server-side ones."""
        md = self.setup_test(
            sources={"foo.md": "# Foo {#foo}\n## Bar {#bar}"},
            raw_redirects={"foo": ["foo.html#foo"], "bar": ["foo.html#bar", "bar.html"]}
        )
        self.run_test(md)
        self.assertEqual(md._redirects.get_client_redirects("foo.html"), {})

    def test_basic_redirect_matching(self):
        """Test client-side redirects getter with a simple redirect mapping"""
        md = self.setup_test(
            sources={"foo.md": "# Foo {#foo}\n## Bar {#bar}"},
            raw_redirects={
                'foo': ['foo.html#foo', 'foo.html#some-section', 'foo.html#another-section'],
                'bar': ['foo.html#bar'],
            },
        )
        self.run_test(md)

        client_redirects = md._redirects.get_client_redirects("foo.html")
        expected_redirects = {'some-section': 'foo.html#foo', 'another-section': 'foo.html#foo'}
        self.assertEqual(client_redirects, expected_redirects)

    def test_advanced_redirect_matching(self):
        """Test client-side redirects getter with a complex redirect mapping"""
        md = self.setup_test(
            sources={"foo.md": "# Foo {#foo}", "bar.md": "# Bar {#bar}"},
            raw_redirects={
                'foo': ['foo.html#foo', 'foo.html#some-section', 'bar.html#foo'],
                'bar': ['bar.html#bar', 'bar.html#another-section'],
            },
        )
        self.run_test(md)
        self.assertEqual(md._redirects.get_client_redirects("index.html"), {})

        client_redirects = md._redirects.get_client_redirects("foo.html")
        expected_redirects = {'some-section': 'foo.html#foo'}
        self.assertEqual(client_redirects, expected_redirects)

        client_redirects = md._redirects.get_client_redirects("bar.html")
        expected_redirects = {'foo': 'foo.html#foo', 'another-section': 'bar.html#bar'}
        self.assertEqual(client_redirects, expected_redirects)

    def test_server_redirects(self):
        """Test server-side redirects getter"""
        md = self.setup_test(
            sources={"foo.md": "# Foo {#foo}", "bar.md": "# Bar {#bar}"},
            raw_redirects={
                'foo': ['foo.html#foo', 'foo-prime.html'],
                'bar': ['bar.html#bar', 'bar-prime.html'],
            },
        )
        self.run_test(md)

        server_redirects = md._redirects.get_server_redirects()
        expected_redirects = {'foo-prime.html': 'foo.html', 'bar-prime.html': 'bar.html'}
        self.assertEqual(server_redirects, expected_redirects)

    def test_client_redirects_to_ghost_paths(self):
        """Test implicit inference of client-side redirects to ghost paths"""
        md = self.setup_test(
            sources={"foo.md": "# Foo {#foo}", "bar.md": "# Bar {#bar}"},
            raw_redirects={
                'foo': ['foo.html#foo', 'foo-prime.html'],
                'bar': ['bar.html#bar', 'foo-prime.html#old'],
            },
        )
        self.run_test(md)

        client_redirects = md._redirects.get_client_redirects("foo.html")
        expected_redirects = {'old': 'bar.html#bar'}
        self.assertEqual(client_redirects, expected_redirects)
