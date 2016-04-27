fc.maintenance
==============

Manages and runs maintenance requests in the Flying Circus. Communicates with
fc.directory to schedule requests.


Local development
-----------------

Create a virtualenv::

    virtualenv -p python3.4 .
    bin/pip install -e ../fcutil
    bin/pip install -e .\[test]

Run unit tests::

    bin/py.test

Test coverage report::

    bin/pip install -e .\[dev]
    bin/py.test --cov=fc.maintenance --cov-report=html


NixOS hacking
-------------

Use either nix-build to get a result::

    nix-build -I nixpkgs=path/to/nixpkgs

or nix-shell for interactive python stuff::

    nix-shell -I nixpkgs=path/to/nixpkgs
    [nix-shell]$ python3.4
