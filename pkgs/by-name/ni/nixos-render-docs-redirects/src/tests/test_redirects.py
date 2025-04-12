import unittest
from nixos_render_docs_redirects import (
    add_content,
    move_content,
    rename_identifier,
    remove_and_redirect,
    IdentifierExists,
    IdentifierNotFound,
)


class RedirectsTestCase(unittest.TestCase):
    def test_add_content(self):
        initial_redirects = {
            "bar": ["path/to/bar.html#bar"],
            "foo": ["path/to/foo.html#foo"],
        }
        final_redirects = {
            "bar": ["path/to/bar.html#bar"],
            "baz": ["path/to/baz.html#baz"],
            "foo": ["path/to/foo.html#foo"],
        }

        result = add_content(initial_redirects, "baz", "path/to/baz.html")
        self.assertEqual(list(result.items()), list(final_redirects.items()))

        with self.assertRaises(IdentifierExists):
            add_content(result, "foo", "another/path.html")


    def test_move_content(self):
        initial_redirects = {
            "foo": ["path/to/foo.html#foo"],
            "bar": ["path/to/bar.html#bar"],
        }
        final_redirects = {
            "foo": ["new/path.html#foo", "path/to/foo.html#foo"],
            "bar": ["path/to/bar.html#bar"],
        }

        result = move_content(initial_redirects, "foo", "new/path.html")
        self.assertEqual(list(result.items()), list(final_redirects.items()))

        with self.assertRaises(IdentifierNotFound):
            move_content(result, "baz", "path.html")


    def test_rename_identifier(self):
        initial_redirects = {
            "foo": ["path/to/foo.html#foo"],
            "bar": ["path/to/bar.html#bar"],
            "baz": ["path/to/baz.html#baz"],
        }
        final_redirects = {
            "foo": ["path/to/foo.html#foo"],
            "boo": ["path/to/bar.html#boo", "path/to/bar.html#bar"],
            "baz": ["path/to/baz.html#baz"],
        }

        result = rename_identifier(initial_redirects, "bar", "boo")
        self.assertEqual(list(result.items()), list(final_redirects.items()))

        with self.assertRaises(IdentifierNotFound):
            rename_identifier(result, "bar", "boo")
        with self.assertRaises(IdentifierExists):
            rename_identifier(result, "boo", "boo")


    def test_remove_and_redirect(self):
        initial_redirects = {
            "foo": ["new/path.html#foo", "path/to/foo.html#foo"],
            "bar": ["path/to/bar.html#bar"],
            "baz": ["path/to/baz.html#baz"],
        }
        final_redirects = {
            "bar": ["path/to/bar.html#bar", "new/path.html#foo", "path/to/foo.html#foo"],
            "baz": ["path/to/baz.html#baz"],
        }

        result = remove_and_redirect(initial_redirects, "foo", "bar")
        self.assertEqual(list(result.items()), list(final_redirects.items()))

        with self.assertRaises(IdentifierNotFound):
            remove_and_redirect(result, "foo", "bar")
        with self.assertRaises(IdentifierNotFound):
            remove_and_redirect(initial_redirects, "foo", "baz")
