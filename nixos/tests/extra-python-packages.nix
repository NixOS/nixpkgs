import ./make-test-python.nix ({ ... }:
  {
    name = "extra-python-packages";

    extraPythonPackages = p: [ p.numpy ];

    nodes = { };

    testScript = ''
      import numpy as np
      assert str(np.zeros(4) == "array([0., 0., 0., 0.])")
    '';
  })
