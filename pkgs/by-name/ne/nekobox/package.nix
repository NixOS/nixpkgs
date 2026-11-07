{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
  ninja,
  pkg-config,
  qt6,
  thrift,
  boost,
  curl,
  openssl,
  leveldb,
  libpsl,
  acl,
  yaml-cpp,
  lmdb,
  snappy,
  nekobox-core,
}:

let
  srslist = fetchurl {
    url = "https://github.com/qr243vbi/ruleset/raw/refs/heads/rule-set/srslist.json";
    hash = "sha256-25RmGHFSKwdFGFJQZmD4mxYkp7IP8Ko7a8CzIGZf5oM=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nekobox";
  version = "5.11.28.3";

  src = fetchFromGitHub {
    owner = "qr243vbi";
    repo = "nekobox";
    rev = finalAttrs.version;
    hash = "sha256-M8gFf7s9/8IFZRDbuQNAZSoQwgEgvzdOeEkjn/7gXGY=";
    fetchSubmodules = true;
  };

  strictDeps = true;
  __structuredAttrs = true;

  postPatch = ''
    # Prevent upstream CMake from stripping Nix store RPATHs
    substituteInPlace cmake/nkr.cmake \
      --replace-fail 'COMMAND "''${PATCHELF_EXECUTABLE}" --remove-rpath' 'COMMAND true' \
      --replace-fail 'COMMAND "''${CHRPATH_EXECUTABLE}" -d' 'COMMAND true'

    # Set proper default program name instead of internal codename "Iblis"
    substituteInPlace src/gharqad/ui/mainwindow.cpp \
      --replace-fail '"Iblis"' '"NekoBox"'

    # Blank out compile-time timestamp to avoid displaying 1980-01-01 in window title
    substituteInPlace cmake/nkr.cmake \
      --replace-fail 'nkr_add_compile_definitions(NKR_TIMESTAMP=\"''${CURRENT_DATE_TIME}\")' \
                     'nkr_add_compile_definitions(NKR_TIMESTAMP=\"\")'
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
    qt6.qttools
    thrift
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtsvg
    qt6.qtdeclarative
    qt6.qttools
    thrift
    boost
    curl
    openssl
    leveldb
    libpsl
    acl
    yaml-cpp
    lmdb
    snappy
  ];

  cmakeFlags = [
    "-DNKR_DEFAULT_VERSION=${finalAttrs.version}"
    # Upstream typo in CMakeLists.txt (EMBEEDING with double 'E')
    "-DENABLE_EMOJI_EMBEEDING=ON"
  ];

  preConfigure = ''
    # Provide the default routing ruleset so CMake doesn't attempt internet access
    cp ${srslist} srslist.json
  '';

  postInstall = ''
    # Symlink core into $out/bin
    ln -s ${nekobox-core}/bin/nekobox_core $out/bin/nekobox_core
    ln -s ${nekobox-core}/bin/nekobox_core $out/bin/nekobox-core

    # Symlink core into libexec/Iblis where internal assets reside
    mkdir -p $out/libexec/Iblis
    ln -s ${nekobox-core}/bin/nekobox_core $out/libexec/Iblis/nekobox_core
    ln -s ${nekobox-core}/bin/nekobox_core $out/libexec/Iblis/nekobox-core
  '';

  passthru = {
    core = nekobox-core;
  };

  meta = {
    description = "NyameBox, The Original NekoBox Rebranded, the cross-platform Qt proxy utility powered by sing-box and Thrift";
    homepage = "https://github.com/qr243vbi/nekobox";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ aliheidary1381 ];
    mainProgram = "nekobox";
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
  };
})
