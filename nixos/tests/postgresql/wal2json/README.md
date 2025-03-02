Data in this folder taken from the wal2json README's examples [here](https://github.com/eulerto/wal2json/tree/75629c2e1e81a12350cc9d63782fc53252185d8d#sql-functions)

They are used under the terms of the BSD-3 License, a copy of which is included
in this directory.

These files have been lightly modified in order to make their output more reproducible.

Changes:
- `\o /dev/null` has been added before commands that print LSNs since LSNs aren't reproducible
- `now()` has been replaced with a hardcoded timestamp string for reproducibility
- The test is run with `--quiet`, and the expected output has been trimmed accordingly
