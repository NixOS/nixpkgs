{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  darwin,
  cargo-tauri,
  buildNpmPackage,
}:
let
  pname = "rqbit";

  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "ikatson";
    repo = "rqbit";
    rev = "v${version}";
    hash = "sha256-VQw4WOzD8vkX7UrA5gITIWCeqRxqhbXSQA8TJe7WVaQ=";
  };

  node-frontend = buildNpmPackage {
    pname = "rqbit-frontend";

    inherit version;

    src = "${src}/crates/librqbit/webui";

    npmDepsHash = "sha256-XOwjJGat2YEXhVuZ657Jn6L1eWgdhmgwQFU+cTRCWW0=";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/dist
      cp -r dist/** $out/dist

      runHook postInstall
    '';

    env.VITE_IS_TAURI_APP = true;
  };

  rqbit-desktop = rustPlatform.buildRustPackage rec {
    pname = "rqbit-desktop";

    version = "7.1.0";

    inherit src;

    cargoLock = {
      lockFile = ./Cargo.lock;
    };

    sourceRoot = "${src.name}/desktop/src-tauri";

    preConfigure = ''
      mkdir -p dist
      cp -R ${node-frontend}/dist/** dist
    '';

    postPatch = ''
      ln -s ${./Cargo.lock} Cargo.lock

      rm tauri.conf.json
      cp ${./tauri.conf.json} tauri.conf.json
    '';

    nativeBuildInputs = [
      cargo-tauri.hook
    ];

    buildInputs =
      lib.optionals stdenv.isLinux [ openssl ]
      ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.SystemConfiguration ];
  };
in
rustPlatform.buildRustPackage {
  inherit pname version src;

  cargoHash = "sha256-moIaI/Z3U+CcGxQvu4qLbD9fw9dHDnIPT8q/KmnSAP8=";

  nativeBuildInputs = lib.optionals stdenv.isLinux [
    pkg-config
  ];

  buildInputs =
    lib.optionals stdenv.isLinux [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.SystemConfiguration ];

  postInstall = ''
    cp ${rqbit-desktop}/bin/* $out/bin/
  '';

  doCheck = false;

  meta = with lib; {
    description = "Bittorrent client in Rust";
    homepage = "https://github.com/ikatson/rqbit";
    changelog = "https://github.com/ikatson/rqbit/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      cafkafk
      toasteruwu
    ];
    mainProgram = "rqbit";
  };
}
