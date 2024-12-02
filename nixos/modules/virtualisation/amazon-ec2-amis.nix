throw ''
We do not provide AMIs as nix expressions anymore. Instead AMIs must be queried
from the AWS API dynamically.  Amazon has a requirement that public AMIs will be
garbage collected after a year so we can't provide stable references anymore. Also we
now upload new AMIs for each channel bump.

Please see
https://nixos.org/download/#nixos-amazon or https://nixos.github.io/amis/ for
instructions.
''