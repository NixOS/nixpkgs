{
  lib,
  fetchFromGitLab,
  installShellFiles,
  libsodium,
  pkg-config,
  protobuf,
  rustPlatform,
  fetchYarnDeps,
  yarnConfigHook,
  yarnBuildHook,
  stdenv,
  nodejs_20,
}:

rustPlatform.buildRustPackage rec {
  pname = "ratman";
  version = "0.4.0";

  src = fetchFromGitLab {
    domain = "git.irde.st";
    owner = "we";
    repo = "irdest";
    rev = "${pname}-${version}";
    sha256 = "sha256-ZZ7idZ67xvQFmQJqIFU/l77YU+yDQOqNthX5NR/l4k8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-YfELSorpW5qWKrkW+oHwMarTo5oZcBRp13wzmFnacg4=";

  nativeBuildInputs = [
    protobuf
    pkg-config
    installShellFiles
  ];

  cargoBuildFlags = [
    "--all-features"
    "-p"
    "ratman"
  ];
  cargoTestFlags = cargoBuildFlags;

  buildInputs = [ libsodium ];

  postInstall = ''
    installManPage docs/man/ratmand.1
  '';

  SODIUM_USE_PKG_CONFIG = 1;

  dashboard = stdenv.mkDerivation rec {
    pname = "ratman-dashboard";
    inherit version src;
    sourceRoot = "${src.name}/ratman/dashboard";

    yarnOfflineCache = fetchYarnDeps {
      yarnLock = src + "/ratman/dashboard/yarn.lock";
      sha256 = "sha256-pWjKL41r/bTvWv+5qCgCFVL9+o64BiV2/ISdLeKEOqE=";
    };

    nativeBuildInputs = [
      nodejs_20
      yarnConfigHook
      yarnBuildHook
    ];

    outputs = [
      "out"
      "dist"
    ];

    installPhase = ''
      cp -R . $out

      mv $out/dist $dist
      ln -s $dist $out/dist
    '';
  };

  prePatch = ''
    cp -r ${dashboard.dist} ratman/dashboard/dist
  '';

  meta = with lib; {
    description = "Modular decentralised peer-to-peer packet router and associated tools";
    homepage = "https://git.irde.st/we/irdest";
    platforms = platforms.unix;
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ spacekookie ];
  };
}
