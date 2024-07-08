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
  version = "16.0.0";

  src = fetchFromGitHub {
    owner = "Ortham";
    repo = pname;
    rev = version;
    hash = "sha256-aqBmcAQodvVpF6lumow5wGqdsaF4ICE0KLU059EjGSQ=";
  };

  cargoHash = "sha256-JBhJLFyKiv6H2+gIGNMw9/ATMkX9bNJ8AdkItuuk2P4=";

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
