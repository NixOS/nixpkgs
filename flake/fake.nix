let
  flake-compat = import (
    builtins.fetchTarball {
      url = "https://git.lix.systems/lix-project/flake-compat/archive/549f2762aebeff29a2e5ece7a7dc0f955281a1d1.tar.gz";
      sha256 = "sha256:0g4izwn5k7qpavlk3w41a92rhnp4plr928vmrhc75041vzm3vb1l";
    }
  );
  flake = flake-compat {
    src = ../.;
    copySourceTreeToStore = false;
  };
in
flake.defaultNix
