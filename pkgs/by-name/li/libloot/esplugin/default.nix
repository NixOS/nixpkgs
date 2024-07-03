{ lib
, fetchFromGitHub
, callPackage
, rustPlatform
}:

let

  testing-plugins = callPackage ../testing-plugins.nix { };

in

rustPlatform.buildRustPackage rec {
  pname = "esplugin";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "Ortham";
    repo = pname;
    rev = version;
    hash = "sha256-jIqXwEIYBJgKXEwolLIbdzy9arJPte8xklzAWVjBjfo=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${cargoLock.lockFile} Cargo.lock
  '';

  # needed to build ffi/include
  cargoBuildFlags = [ "--all" "--all-features" ];

  preCheck = ''
    tmp=$(mktemp -dp .)
    tar -C "$tmp" -xzf ${testing-plugins}
    ln -s "$tmp"/* testing-plugins
  '';

  # libloot expects esplugin.hpp not esplugin.h
  postInstall = ''
    install -Dm 644 ffi/include/esplugin.h $out/include/esplugin.hpp
  '';

  meta = with lib; {
    description = "A free software library for reading Elder Scrolls plugin (.esp/.esm/.esl) files";
    homepage = "https://github.com/Ortham/esplugin";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.schnusch ];
  };
}
