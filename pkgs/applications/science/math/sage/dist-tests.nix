# Lists past failures and files associated with it. The intention is to build
# up a subset of a testsuite that catches 95% of failures that are relevant for
# distributions while only taking ~5m to run. This in turn makes it more
# reasonable to re-test sage on dependency changes and makes it easier for
# users to override the sage derivation.
# This is an experiment for now. If it turns out that there really is a small
# subset of files responsible for the vast majority of packaging tests, we can
# think about moving this upstream.
[
	"src/sage/env.py" # [1]
	"src/sage/misc/persist.pyx" # [1]
	"src/sage/misc/inline_fortran.py" # [1]
	"src/sage/repl/ipython_extension.py" # [1]
]

# Numbered list of past failures to annotate files with
# [1] PYTHONPATH related issue https://github.com/NixOS/nixpkgs/commit/ec7f569211091282410050e89e68832d4fe60528
