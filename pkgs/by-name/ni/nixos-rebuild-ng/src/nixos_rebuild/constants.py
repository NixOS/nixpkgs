# mypy: disable-error-code=comparison-overlap
from typing import Final

# Build-time flags
# Use strings to avoid breaking standalone (e.g.: `python -m nixos_rebuild`)
# usage
EXECUTABLE: Final[str] = "@executable@"
# Use either `== "true"` if the default (e.g.: `python -m nixos_rebuild`) is
# `False` or `!= "false"` if the default is `True`
<<<<<<< HEAD
=======
WITH_REEXEC: Final[bool] = "@withReexec@" == "true"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
WITH_SHELL_FILES: Final[bool] = "@withShellFiles@" == "true"
