{ lib
, stdenv
, fetchFromGitHub
, callPackage
, rustPlatform
, rust-cbindgen
}:

let

  testing-plugins = callPackage ../testing-plugins.nix { };

in

rustPlatform.buildRustPackage rec {
  pname = "libloadorder";
  version = "17.0.1";

  src = fetchFromGitHub {
    owner = "Ortham";
    repo = pname;
    rev = version;
    hash = "sha256-m8tDQJJFKxdnXrXZ85qUE6AT0UD94kUCRTbBj4QokWA=";
  };

  cargoHash = "sha256-/oLrjvQj/KTIJc52hUaZ0wRF+BUZQDiMuw5AxutSXIs=";

  nativeBuildInputs = [
    rust-cbindgen
  ];

  preConfigure = ''
    cd ffi
  '';

  postBuild = ''
    # manually since 16.0.0
    cbindgen . -o include/libloadorder.h
    cd ..
  '';

  preCheck = ''
    # testing-plugins needs to be writable
    cp -r ${testing-plugins} testing-plugins
    chmod -R u+w testing-plugins
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
