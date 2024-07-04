{ lib
, fetchFromGitHub
, callPackage
, rustPlatform
, rust-cbindgen
}:

let

  testing-plugins = callPackage ../testing-plugins.nix { };

in

rustPlatform.buildRustPackage rec {
  pname = "esplugin";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "Ortham";
    repo = pname;
    rev = version;
    hash = "sha256-VlzQUNQ9rfv3ivDoV6+2XnoTR0nDwNJo2gxfibq3juw=";
  };

  cargoHash = "sha256-6G8N/0CdASfqTiHeoTD5pgUOzUJEmIivirqJewC0KuE=";

  nativeBuildInputs = [
    rust-cbindgen
  ];

  preConfigure = ''
    cd ffi
  '';

  postBuild = ''
    # manually since 5.0.0
    cbindgen . -o include/esplugin.h
    cd ..
  '';

  preCheck = ''
    ln -s ${testing-plugins} testing-plugins
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
