import unittest
from unittest.mock import patch
from io import StringIO
import json
from nixos_render_docs_redirects import (
    add_content,
    move_content,
    mass_move_content,
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

    @patch('sys.stdin', new_callable=StringIO)
    def test_mass_move_content(self, mock_stdin):
        initial_redirects = {
            "foo": ["path/to/foo.html#foo"],
            "bar": ["path/to/bar.html#bar"],
            "baz": ["path/to/baz.html#baz"],
        }
        final_redirects = {
            "foo": ["new/path.html#foo", "path/to/foo.html#foo"],
            "bar": ["new/path.html#bar", "path/to/bar.html#bar"],
            "baz": ["new/path.html#baz", "path/to/baz.html#baz"],
        }

        mock_stdin.write(f"""
        A line
        Another line
        NRD_E_OUTPATH:{json.dumps(["foo", "bar", "baz"])}
        More lines
        """)
        mock_stdin.seek(0)

        result, count = mass_move_content(initial_redirects, "new/path.html")
        self.assertEqual(count, 3)
        self.assertEqual(list(result.items()), list(final_redirects.items()))

    @patch('sys.stdin', new_callable=StringIO)
    def test_mass_move_content_wrong_format(self, mock_stdin):
        mock_stdin.write(f"""
        A line
        Another line
        NRD_E_OUTPATH:"foo", "bar", "baz"
        More lines
        """)
        mock_stdin.seek(0)

        with self.assertRaises(json.decoder.JSONDecodeError):
            result, count = mass_move_content({}, "")


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
