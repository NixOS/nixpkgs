{ stdenv, coreutils, gnused, nix }:

stdenv.mkDerivation rec {
  name = "nixup-${version}";
  version = "0.0.1";

  buildCommand = ''
    mkdir -p $out/bin
    shell=${stdenv.shell}
    export coreutils=${coreutils}
    export gnused=${gnused}
    export nix=${nix}
    substituteAll ${./nixup.sh} $out/bin/nixup
    chmod +x $out/bin/nixup
  '';
}

