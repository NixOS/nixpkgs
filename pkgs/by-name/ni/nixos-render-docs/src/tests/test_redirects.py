import json
import unittest
import shutil
from pathlib import Path
import pytest

from nixos_render_docs.manual import HTMLConverter, HTMLParameters
from nixos_render_docs.redirects import Redirects, RedirectsError

class TestRedirects(unittest.TestCase):
    @pytest.fixture(autouse=True)
    def inittmp(self, tmp_path):
        self.tmp_path = tmp_path

    def setup_test(self, sources, raw_redirects, tmp_path: Path):

        with open(tmp_path / 'index.md', 'w') as infile:
            indexHTML = ["# Redirects test suite {#redirects-test-suite}\n## Setup steps"]
            for path in sources.keys():
                outpath = f"{path.split('.md')[0]}.html"
                indexHTML.append(f"```{{=include=}} appendix html:into-file=//{outpath}\n{path}\n```")
            infile.write("\n".join(indexHTML))

        for filename, content in sources.items():
            with open(tmp_path / filename, 'w') as infile:
                infile.write(content)

        redirects = Redirects({"redirects-test-suite": ["index.html#redirects-test-suite"]} | raw_redirects, '')
        return HTMLConverter("1.0.0", HTMLParameters("", [], [], 2, 2, 2, tmp_path, True), {}, redirects)

    def run_test(self, md: HTMLConverter, tmp_path: Path):
        md.convert(tmp_path / 'index.md', tmp_path / 'index.html')

    def assert_redirect_error(self, expected_errors: dict, md: HTMLConverter, tmp_path: Path):
        with self.assertRaises(RuntimeError) as context:
            self.run_test(md, tmp_path)

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
            tmp_path=self.tmp_path
        )
        self.run_test(before, self.tmp_path)

        intermediate = self.setup_test(
            sources={"foo.md": "# Foo {#foo}\n## Bar {#bar}"},
            raw_redirects={"foo": ["foo.html#foo"]},
            tmp_path=self.tmp_path
        )
        self.assert_redirect_error({"identifiers_without_redirects": ["bar"]}, intermediate, self.tmp_path)

        after = self.setup_test(
            sources={"foo.md": "# Foo {#foo}\n## Bar {#bar}"},
            raw_redirects={"foo": ["foo.html#foo"], "bar": ["foo.html#bar"]},
            tmp_path=self.tmp_path
        )
        self.run_test(after, self.tmp_path)

    def test_identifier_removed(self):
        """Test removing an identifier from the source."""
        before = self.setup_test(
            sources={"foo.md": "# Foo {#foo}\n## Bar {#bar}"},
            raw_redirects={"foo": ["foo.html#foo"], "bar": ["foo.html#bar"]},
            tmp_path=self.tmp_path
        )
        self.run_test(before, self.tmp_path)

        intermediate = self.setup_test(
            sources={"foo.md": "# Foo {#foo}"},
            raw_redirects={"foo": ["foo.html#foo"], "bar": ["foo.html#bar"]},
            tmp_path=self.tmp_path
        )
        self.assert_redirect_error({"orphan_identifiers": ["bar"]}, intermediate, self.tmp_path)

        after = self.setup_test(
            sources={"foo.md": "# Foo {#foo}"},
            raw_redirects={"foo": ["foo.html#foo"]},
            tmp_path=self.tmp_path
        )
        self.run_test(after, self.tmp_path)

    def test_identifier_renamed(self):
        """Test renaming an identifier in the source."""
        before = self.setup_test(
            sources={"foo.md": "# Foo {#foo}\n## Bar {#bar}"},
            raw_redirects={"foo": ["foo.html#foo"], "bar": ["foo.html#bar"]},
            tmp_path=self.tmp_path
        )
        self.run_test(before, self.tmp_path)

        intermediate = self.setup_test(
            sources={"foo.md": "# Foo Prime {#foo-prime}\n## Bar {#bar}"},
            raw_redirects={"foo": ["foo.html#foo"], "bar": ["foo.html#bar"]},
            tmp_path = self.tmp_path
        )
        self.assert_redirect_error(
            {
                "identifiers_without_redirects": ["foo-prime"],
                "orphan_identifiers": ["foo"]
            },
            intermediate,
            self.tmp_path
        )

        after = self.setup_test(
            sources={"foo.md": "# Foo Prime {#foo-prime}\n## Bar {#bar}"},
            raw_redirects={"foo-prime": ["foo.html#foo-prime", "foo.html#foo"], "bar": ["foo.html#bar"]},
            tmp_path=self.tmp_path
        )
        self.run_test(after, self.tmp_path)

    def test_conflicting_anchors(self):
        """Test for conflicting anchors."""
        md = self.setup_test(
            sources={"foo.md": "# Foo {#foo}\n## Bar {#bar}"},
            raw_redirects={
                "foo": ["foo.html#foo", "foo.html#bar"],
                "bar": ["foo.html#bar"],
            },
            tmp_path = self.tmp_path
        )
        self.assert_redirect_error({"conflicting_anchors": ["bar"]}, md, self.tmp_path)

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
            },
            tmp_path = self.tmp_path
        )
        self.assert_redirect_error({"divergent_redirects": ["old-foo.html"]}, md, self.tmp_path)

    def test_no_client_redirects(self):
        """Test fetching client side redirects and ignore server-side ones."""
        md = self.setup_test(
            sources={"foo.md": "# Foo {#foo}\n## Bar {#bar}"},
            raw_redirects={"foo": ["foo.html#foo"], "bar": ["foo.html#bar", "bar.html"]},
            tmp_path = self.tmp_path
        )
        self.run_test(md, self.tmp_path)
        self.assertEqual(md._redirects.get_client_redirects("foo.html"), {}, self.tmp_path)

    def test_basic_redirect_matching(self):
        """Test client-side redirects getter with a simple redirect mapping"""
        md = self.setup_test(
            sources={"foo.md": "# Foo {#foo}\n## Bar {#bar}"},
            raw_redirects={
                'foo': ['foo.html#foo', 'foo.html#some-section', 'foo.html#another-section'],
                'bar': ['foo.html#bar'],
            },
            tmp_path=self.tmp_path
        )
        self.run_test(md, self.tmp_path)

        client_redirects = md._redirects.get_client_redirects("foo.html")
        expected_redirects = {
            'some-section': 'foo.html',
            'another-section': 'foo.html'
        }
        self.assertEqual(client_redirects, expected_redirects, self.tmp_path)

    def test_advanced_redirect_matching(self):
        """Test client-side redirects getter with a complex redirect mapping"""
        md = self.setup_test(
            sources={"foo.md": "# Foo {#foo}", "bar.md": "# Bar {#bar}"},
            raw_redirects={
                'foo': ['foo.html#foo', 'foo.html#some-section', 'bar.html#foo'],
                'bar': ['bar.html#bar', 'bar.html#another-section'],
            },
            tmp_path=self.tmp_path
        )

        expected_redirects = {
            'some-section': 'foo.html',
            'foo': 'foo.html',
            'another-section': 'bar.html'
        }
        self.run_test(md, self.tmp_path)
        self.assertEqual(md._redirects.get_client_redirects("index.html"), expected_redirects)

        expected_nested_redirects = {
            'some-section': '../foo.html',
            'foo': '../foo.html',
            'another-section': '../bar.html'
        }
        client_redirects = md._redirects.get_client_redirects("baz-chapter/baz.html")
        self.assertEqual(client_redirects, expected_nested_redirects)

    def test_server_redirects(self):
        """Test server-side redirects getter"""
        md = self.setup_test(
            sources={"foo.md": "# Foo {#foo}", "bar.md": "# Bar {#bar}"},
            raw_redirects={
                'foo': ['foo.html#foo', 'foo-prime.html'],
                'bar': ['bar.html#bar', 'bar-prime.html'],
            },
            tmp_path=self.tmp_path
        )
        self.run_test(md, self.tmp_path)

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
            tmp_path=self.tmp_path
        )
        self.run_test(md, self.tmp_path)

        client_redirects = md._redirects.get_client_redirects("foo.html")
        expected_redirects = {'old': 'bar.html'}
        self.assertEqual(client_redirects, expected_redirects)
