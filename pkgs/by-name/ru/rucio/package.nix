{ python312Packages }:

# Pinned to python 3.12 while python313Packages.future does not evaluate and
# until https://github.com/CZ-NIC/pyoidc/issues/649 is resolved
with python312Packages;

toPythonApplication rucio
