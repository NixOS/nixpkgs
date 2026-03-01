{
  fetchFromGitHub,
  stdenv,
  lib,
  nix,
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
in
stdenv.mkDerivation rec {
  pname = "nix-scheduler-hook";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "lisanna-dettwyler";
    repo = "nix-scheduler-hook";
    tag = "v${version}";
    hash = "sha256-pB42rjqkASgdYQJD9nPqFSM0JAUIko1FN4d0J52BUsc=";
  };

  sourceRoot = "source/src";

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
    mv nsh $out/bin
    mkdir -p $out/lib
    mv subprojects/restclient-cpp/librestclient_cpp.so $out/lib
  '';

  meta = {
    description = "Nix build hook that forwards builds to job schedulers";
    homepage = "https://github.com/lisanna-dettwyler/nix-scheduler-hook";
    license = lib.licenses.lgpl21;
    mainProgram = "nsh";
    maintainers = with lib.maintainers; [ lisanna-dettwyler ];
    inherit (nix.meta) platforms;
  };
}
