{ lib,
  rustPlatform,
  fetchFromSourcehut,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "jetporch";
  version = "unstable-2023-10-16";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  src = fetchFromSourcehut {
    owner = "~mpdehaan";
    repo = "jetporch";
    rev = "6ca8a26c0514a31c359bad081ef55980dd509912";
    hash = "sha256-ih3ZUBWPVrpg8NVDvj+bp4R8horUwB05SzoUMYPFN/E=";
  };

  preBuild = ''
    echo "pub const GIT_VERSION: &str  = \"${version}\";" >> src/cli/version.rs
    echo "pub const GIT_BRANCH: &str  = \"nixpkgs\";" >> src/cli/version.rs
    echo "pub const BUILD_TIME: &str  = \"Thu Jan  1 00:00:00 UTC 1970\";" >> src/cli/version.rs
  '';

  cargoHash = "sha256-agByCEpqD8z6jQGsKAZgB0X+I4umgNd3dyhIFlUS/vQ=";

  meta = with lib; {
    homepage = "https://www.jetporch.com";
    description = "Jet is a general-purpose, community-driven IT automation platform for configuration, deployment, orchestration, patching, and arbitrary task execution workflows";
    sourceProvenance = with sourceTypes; [ fromSource ];
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [
      heywoodlh
    ];
  };
}
