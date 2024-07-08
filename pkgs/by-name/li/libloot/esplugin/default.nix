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
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "Ortham";
    repo = pname;
    rev = version;
    hash = "sha256-e52QAD9gjkdGMhEERzdX7cOls7I+CD9lX6LCwxASN2I=";
  };

  cargoHash = "sha256-ZKQCN+kl5TYtfgxvbt3dRjgBtfDUqXNc7AKm9CGppO4=";

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
    # testing-plugins needs to be writable
    cp -r ${testing-plugins} testing-plugins
    chmod -R u+w testing-plugins
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
