{ lib
, stdenv
, fetchFromGitHub
, callPackage
, rustPlatform
}:

let

  testing-plugins = callPackage ../testing-plugins.nix { };

in

rustPlatform.buildRustPackage rec {
  pname = "libloadorder";
  version = "15.0.1";

  src = fetchFromGitHub {
    owner = "Ortham";
    repo = pname;
    rev = version;
    hash = "sha256-Cp29h48z0iE3zrcRktDwbIZwx4tVfUzmpkR1pjEmM+w=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${cargoLock.lockFile} Cargo.lock
  '';

  cargoBuildFlags = [ "--all" "--all-features" ];

  preCheck = ''
    tmp=$(mktemp -dp .)
    tar -C "$tmp" -xzf ${testing-plugins}
    ln -s "$tmp"/* testing-plugins
  '';

  # libloot expects libloadorder.hpp not libloadorder.h
  postInstall = ''
    install -Dm 644 ffi/include/libloadorder.h $out/include/libloadorder.hpp
  '';

  meta = with lib; {
    description = "A cross-platform library for manipulating the load order and active status of plugins for the Elder Scrolls and Fallout games";
    homepage = "https://github.com/Ortham/libloadorder";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.schnusch ];
  };
}
