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
  version = "1.3.21";

  src = fetchFromGitLab {
    owner = "BuildGrid";
    repo = "buildbox/buildbox";
    tag = finalAttrs.version;
    hash = "sha256-gZ4PnaIiMPh18Yy2120yIEaQaFpzGNnWXzS7Uw+n/+k=";
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
