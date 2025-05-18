{
  lib,
  stdenv,
  fetchFromGitLab,
  bubblewrap,
  makeBinaryWrapper,
  cmake,
  pkg-config,
  ninja,
  grpc,
  gbenchmark,
  gtest,
  protobuf,
  glog,
  nlohmann_json,
  zlib,
  openssl,
  libuuid,
  tomlplusplus,
  fuse3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "buildbox";
  version = "1.3.11";

  src = fetchFromGitLab {
    owner = "BuildGrid";
    repo = "buildbox/buildbox";
    tag = finalAttrs.version;
    hash = "sha256-lIRYwZLjYCpA4TMO3GF/yykVKn7LDyNHW9zItZmS9vM=";
  };

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
    ninja
    pkg-config
  ];

  buildInputs = [
    bubblewrap
    fuse3
    gbenchmark
    glog
    grpc
    gtest
    libuuid
    nlohmann_json
    openssl
    protobuf
    tomlplusplus
    zlib
  ];

  postFixup = ''
    wrapProgram $out/bin/buildbox-run --prefix PATH : ${lib.makeBinPath [ bubblewrap ]}
  '';

  meta = {
    description = "Set of tools for remote worker build execution";
    homepage = "https://gitlab.com/BuildGrid/buildbox/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ shymega ];
  };
})
