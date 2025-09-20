{
  lib,
  stdenv,
  fetchFromGitHub,
  appstream,
  cmake,
  gettext,
  git,
  makeWrapper,
  lsb-release,
  pkg-config,
  wrapGAppsHook3,
  curl,
  sqlite,
  wxGTK32,
  gtk3,
  lua,
  wxsqlite3,
}:

stdenv.mkDerivation rec {
  pname = "money-manager-ex";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "moneymanagerex";
    repo = "moneymanagerex";
    tag = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-U8DvJPJwShbuKlKsWylH9kUEEw8/SY8KnYWNyInhE9k=";
  };

  postPatch = ''
    substituteInPlace src/dbwrapper.cpp src/model/Model_Report.cpp \
      --replace-fail "sqlite3mc_amalgamation.h" "sqlite3.h"
  '';

  nativeBuildInputs = [
    appstream # for appstreamcli
    cmake
    gettext
    git
    makeWrapper
    pkg-config
    wrapGAppsHook3
    wxGTK32
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    lsb-release
  ];

  buildInputs = [
    curl
    sqlite
    wxGTK32
    gtk3
    lua
    wxsqlite3
  ];

  strictDeps = true;

  cmakeFlags = [
    "-DWXSQLITE3_HAVE_CODEC=1"
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.cc.isClang [
      "-Wno-deprecated-copy"
      "-Wno-old-style-cast"
      "-Wno-unused-parameter"
    ]
  );

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    mv $out/mmex.app $out/Applications
    makeWrapper $out/{Applications/mmex.app/Contents/MacOS,bin}/mmex
  '';

  meta = {
    description = "Easy-to-use personal finance software";
    homepage = "https://www.moneymanagerex.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = with lib.platforms; unix;
    mainProgram = "mmex";
  };
}
