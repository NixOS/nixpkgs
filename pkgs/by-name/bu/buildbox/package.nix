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
  abseil-cpp,
  nlohmann_json,
  zlib,
  openssl,
  libuuid,
  tomlplusplus,
  fuse3,
  curl,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "buildbox";
  version = "1.4.0";

  src = fetchFromGitLab {
    owner = "BuildGrid";
    repo = "buildbox/buildbox";
    tag = finalAttrs.version;
    hash = "sha256-yZux8uXjv9kQPGGL+y0p+1pURauFHhLpCAfjvOVMGmg=";
  };

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
    ninja
    pkg-config
  ];

  buildInputs = [
    abseil-cpp
    bubblewrap
    curl
    fuse3
    gbenchmark
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Set of tools for remote worker build execution";
    homepage = "https://gitlab.com/BuildGrid/buildbox/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ shymega ];
  };
})
