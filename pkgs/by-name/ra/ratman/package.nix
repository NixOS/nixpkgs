{
  lib,
  fetchFromCodeberg,
  fetchNpmDeps,
  installShellFiles,
  pkg-config,
  rustPlatform,
  npmHooks,
  stdenv,
  nodejs,
  udev,
}:

rustPlatform.buildRustPackage rec {
  pname = "ratman";
  version = "0.7.0";

  src = fetchFromCodeberg {
    owner = "irdest";
    repo = "irdest";
    tag = version;
    hash = "sha256-rdKfKbikyqs0Y/y9A8XRVSKenjHD5rS3blxwy98Tvmg=";
  };

  cargoHash = "sha256-H1XE+khN6sU9WTM87foEQRTK0u5fgDZvoG3//hvd464=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [ udev ];

  cargoBuildFlags = [
    "-p"
    "ratmand"
    "-p"
    "ratman-tools"
  ];
  cargoTestFlags = cargoBuildFlags;

  dashboard = stdenv.mkDerivation rec {
    pname = "ratman-dashboard";
    inherit version src;
    sourceRoot = "${src.name}/ratman/dashboard";

    npmDeps = fetchNpmDeps {
      pname = "npm-deps-${pname}";
      inherit version;
      src = "${src}/ratman/dashboard";
      hash = "sha256-47L4V/Vf8DK3q63MYw3x22+rzIN3UPD0N/REmXh5h3w=";
    };

    nativeBuildInputs = [
      nodejs
      npmHooks.npmConfigHook
      npmHooks.npmBuildHook
    ];

    npmBuildScript = "build";

    installPhase = ''
      mkdir $out
      cp -r dist/* $out/
    '';
  };

  prePatch = ''
    cp -r ${dashboard} ratman/dashboard/dist
  '';

  meta = {
    description = "Modular decentralised peer-to-peer packet router and associated tools";
    homepage = "https://git.irde.st/we/irdest";
    platforms = lib.platforms.unix;
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ spacekookie ];
  };
}
