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
  libnotify,
  libappindicator-gtk3,
  nix-update-script,
  libsysprof-capture,
  pcre2,
  libdeflate,
  lerc,
  xz,
  libwebp,
  util-linux,
  libselinux,
  libsepol,
  libthai,
  libdatrie,
  libxdmcp,
  libxkbcommon,
  libepoxy,
  systemd,
  libxtst,
}:
let
  version = "10.2.0";

  src = fetchFromGitHub {
    owner = "lemonade-sdk";
    repo = "lemonade";
    rev = "v${version}";
    hash = "sha256-r6b98zW+guE27HZe26MiQhlHIltfZyNPRN7HIdpKrYI=";
  };

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

  lws-src = fetchFromGitHub {
    owner = "warmcat";
    repo = "libwebsockets";
    rev = "v4.5.8";
    hash = "sha256-0pLBxOSKaxboHd9L27RKKqSJ9lVH4wPgKSyXEoJMal4=";
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

  __structuredAttrs = true;
  strictDeps = true;

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
    libnotify
    libappindicator-gtk3
    libsysprof-capture
    pcre2
    libdeflate
    lerc
    xz # lzma
    libwebp
    util-linux
    libselinux
    libsepol
    libthai
    libdatrie
    libxdmcp
    libxkbcommon
    libepoxy
    systemd
    libxtst
  ];

  patches = [
    ./cmake.patch
  ];

  cmakeFlags = [
    "-DUSE_SYSTEM_JSON=ON"
    "-DUSE_SYSTEM_CLI11=ON"
    "-DUSE_SYSTEM_CURL=ON"
    "-DUSE_SYSTEM_ZSTD=ON"
    "-DUSE_SYSTEM_HTTPLIB=OFF"
    "-DFETCHCONTENT_SOURCE_DIR_HTTPLIB=${httplib-src}"
    "-DFETCHCONTENT_SOURCE_DIR_LIBWEBSOCKETS=${lws-src}"
    "-DFETCHCONTENT_FULLY_DISCONNECTED=ON"
  ];

  env = {
    NIX_LDFLAGS = "-lssl -lcrypto";
  };

  postPatch = ''
    # Prevent CMake from trying to create symlinks in /usr/bin and /usr/lib
    substituteInPlace src/cpp/tray/CMakeLists.txt \
      --replace-warn 'if(NOT CMAKE_INSTALL_PREFIX STREQUAL "/usr")' 'if(FALSE)' \
      --replace-warn 'if(UNIX AND NOT APPLE AND NOT CMAKE_INSTALL_PREFIX STREQUAL "/usr")' 'if(FALSE)'

    substituteInPlace src/cpp/cli/CMakeLists.txt \
      --replace-warn 'if(UNIX AND NOT APPLE AND NOT CMAKE_INSTALL_PREFIX STREQUAL "/usr")' 'if(FALSE)'

    substituteInPlace CMakeLists.txt \
      --replace-warn 'if(NOT CMAKE_INSTALL_PREFIX STREQUAL "/usr")' 'if(FALSE)'

    # Prevent CMake from touching /etc
    substituteInPlace CMakeLists.txt \
      --replace-warn 'DESTINATION /etc/lemonade' 'DESTINATION ''${CMAKE_INSTALL_PREFIX}/etc/lemonade'
  '';

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
