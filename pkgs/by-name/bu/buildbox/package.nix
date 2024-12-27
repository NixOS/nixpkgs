{
  lib,
  stdenv,
  fetchFromGitLab,
  bubblewrap,
  makeWrapper,
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
let
  pname = "buildbox";
  version = "1.3.0";
in
stdenv.mkDerivation {
  inherit pname version;

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
  nativeBuildInputs = [
    cmake
    makeWrapper
    ninja
    pkg-config
  ];

  src = fetchFromGitLab {
    owner = "BuildGrid";
    repo = "buildbox/buildbox";
    tag = version;
    hash = "sha256-a/weV3VDAiXlyrvDU/IeoG4A4UU9oROOO7QNY+8g8Ho=";
  };

  postFixup = ''
    wrapProgram $out/bin/buildbox-run-bubblewrap --prefix PATH : ${lib.makeBinPath [ bubblewrap ]}
    ln -sf buildbox-run-bubblewrap $out/bin/buildbox-run
  '';

  meta = {
    description = "Set of tools for remote worker build execution";
    homepage = "https://gitlab.com/BuildGrid/buildbox/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ shymega ];
  };
}
