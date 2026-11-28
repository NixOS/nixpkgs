{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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
  wxwidgets_3_2,
  gtk3,
  lua5_2_compat,
  wxsqlite3,
}:
let
  lua = lua5_2_compat;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "money-manager-ex";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "moneymanagerex";
    repo = "moneymanagerex";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-DE235wSfq20X3qh2L0KfFLk/54CW6l4Qn1K5r9nePQg=";
  };

  patches = [
    # https://github.com/moneymanagerex/moneymanagerex/pull/8534
    (fetchpatch {
      name = "appstream-1.2-compat.patch";
      url = "https://github.com/moneymanagerex/moneymanagerex/commit/7835f3d532b53c1e8d87d0a71fceada9975ede65.patch";
      hash = "sha256-S3bMo247euH+7pZlpNpNIzniQXHbBviNVOrjuyalJ/Y=";
    })
  ];

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
    wxwidgets_3_2
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    lsb-release
  ];

  buildInputs = [
    curl
    sqlite
    wxwidgets_3_2
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
})
