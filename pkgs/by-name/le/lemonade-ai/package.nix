{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  libdrm,
  pkg-config,
  curl,
  nlohmann_json,
  openssl,
  zstd,
  cli11,
  buildNpmPackage,
  nix-update-script,
}:
let
  version = "10.0.0";

  src = fetchFromGitHub {
    owner = "lemonade-sdk";
    repo = "lemonade";
    rev = "v${version}";
    hash = "sha256-PT3HzdQy+Zc2Y7uutgU62uvhA1w6V37UyrcFqCezM80=";
  };

  # lemonade requires httplib >= 0.26.0, but nixpkgs has 0.19.0
  httplib-src = fetchFromGitHub {
    owner = "yhirose";
    repo = "cpp-httplib";
    rev = "v0.26.0";
    hash = "sha256-+VPebnFMGNyChM20q4Z+kVOyI/qDLQjRsaGS0vo8kDM=";
  };

  httplib-local = stdenv.mkDerivation {
    pname = "cpp-httplib";
    version = "0.26.0";
    src = httplib-src;
    nativeBuildInputs = [ cmake ];
  };

  ixwebsocket-src = fetchFromGitHub {
    owner = "machinezone";
    repo = "IXWebSocket";
    rev = "v11.4.4";
    hash = "sha256-BLvZBZA9wTvzDuUFXT0YQAEuQxeGyRPxCLuFS4xrknI=";
  };

  web-app = buildNpmPackage {
    pname = "web-app";
    inherit version src;
    sourceRoot = "${src.name}/src/web-app";

    npmDepsHash = "sha256-d9ZzcpolixarWYZjruvpGlDCTnRXFnh/LljTLXngDmY=";
    postPatch = ''
      cp ${./web-app.package-lock.json} package-lock.json
    '';
    postInstall = ''
      mkdir $out/resources
      cp -r dist/renderer/ $out/resources/web-app/
    '';
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lemonade-ai";
  inherit version src;

  patches = [
    ./cmake.patch
    ./fetchcontent.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    curl
    nlohmann_json
    openssl
    zstd
    cli11
    libdrm
  ];

  cmakeFlags = [
    "-DUSE_SYSTEM_JSON=ON"
    "-DUSE_SYSTEM_CLI11=ON"
    "-DUSE_SYSTEM_CURL=ON"
    "-DUSE_SYSTEM_ZSTD=ON"
    "-DUSE_SYSTEM_HTTPLIB=OFF"
    "-DFETCHCONTENT_SOURCE_DIR_HTTPLIB=${httplib-src}"
    "-DFETCHCONTENT_SOURCE_DIR_IXWEBSOCKET=${ixwebsocket-src}"
    "-DFETCHCONTENT_FULLY_DISCONNECTED=ON"
  ];

  env = {
    NIX_LDFLAGS = "-lssl -lcrypto";
  };

  postInstall = ''
    mkdir -p $out/bin/resources/web-app
    cp -r $src/src/cpp/resources/* $out/bin/resources
    chmod -R +w $out/bin/resources/
    cp -r ${web-app}/resources/web-app/* $out/bin/resources/web-app/
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lemonade helps users discover and run local AI apps by serving optimized LLMs right from their own GPUs and NPUs";
    homepage = "https://github.com/lemonade-sdk/lemonade/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ videl ];
    mainProgram = "lemonade-server";
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
