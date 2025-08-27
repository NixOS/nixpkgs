{
  # On Python 3.13, `tests/test_libmat2.py::TestCleaning::test_html` fails with
  #
  #     ValueError: The closing tag title doesn't have a corresponding opening one in ./tests/data/clean.html.
  python312Packages,
}:

with python312Packages;
toPythonApplication mat2
