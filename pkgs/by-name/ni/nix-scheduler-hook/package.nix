{
  fetchFromGitHub,
  fetchFromCodeberg,
  clangStdenv,
  lib,
  nixVersions,
  meson,
  cmake,
  ninja,
  boost,
  pkg-config,
  nlohmann_json,
  curl,
  openpbs,
  symlinkJoin,
  slurm,
  gitUpdater,
}:
let
  restclient-cpp = fetchFromGitHub {
    owner = "mrtazz";
    repo = "restclient-cpp";
    rev = "3356f816b161279cfbe318c45cb07c07fb8de6df";
    hash = "sha256-9//KssNRD7OJFNFdXgzsu7rKP/Nlb4wtmBjfhOt2Vgw=";
  };
  slurmJoined = symlinkJoin {
    name = "slurm";
    paths = [
      slurm
      slurm.dev
    ];
  };
  nix = nixVersions.nix_2_34;
in
clangStdenv.mkDerivation rec {
  pname = "nix-scheduler-hook";
  version = "0.11.0";

  src = fetchFromCodeberg {
    owner = "lisanna";
    repo = "nix-scheduler-hook";
    tag = "v${version}";
    hash = "sha256-IyObnqwCUqD6QqfoBRrjmxmmqikKCoEHK/VtOv8bJ5w=";
  };

  nativeBuildInputs = [
    meson
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    boost
    curl
    nix.libs.nix-util
    nix.libs.nix-store
    nix.libs.nix-main
    nlohmann_json
    openpbs
    slurmJoined
  ];

  postUnpack = ''
    mkdir $sourceRoot/subprojects
    cp -r ${restclient-cpp} $sourceRoot/subprojects/restclient-cpp
  '';

  installPhase = ''
    mkdir -p $out/bin
    mv src/nsh $out/bin
    mkdir -p $out/lib
    shopt -s extglob
    mv subprojects/restclient-cpp/librestclient_cpp.so!(*p) $out/lib
  '';

  passthru = {
    updateScript = gitUpdater {
      rev-prefix = "v";
    };
  };

  meta = {
    description = "Nix build hook that forwards builds to job schedulers";
    homepage = "https://codeberg.org/lisanna/nix-scheduler-hook";
    license = lib.licenses.lgpl21;
    mainProgram = "nsh";
    maintainers = with lib.maintainers; [ lisanna-dettwyler ];
    inherit (nix.meta) platforms;
  };
}
