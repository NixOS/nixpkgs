{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libsForQt5,
  sqlcipher,
}:

let
  # upstream has adopted qt6, but no released version supports it
  qt' = libsForQt5;

in
stdenv.mkDerivation (finalAttrs: {
  pname = "sqlitebrowser";
  version = "3.13.1";

  src = fetchFromGitHub {
    owner = "sqlitebrowser";
    repo = "sqlitebrowser";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bpZnO8i8MDgOm0f93pBmpy1sZLJQ9R4o4ZLnGfT0JRg=";
  };

  patches = lib.optional stdenv.hostPlatform.isDarwin ./macos.patch;

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail '"Unknown"' '"${finalAttrs.src.rev}"'
  '';

  buildInputs = [
    qt'.qtbase
    qt'.qcustomplot
    qt'.qscintilla
    sqlcipher
  ] ++ lib.optional stdenv.hostPlatform.isDarwin qt'.qtmacextras;

  nativeBuildInputs = [
    cmake
    pkg-config
    qt'.qttools
    qt'.wrapQtAppsHook
  ];

  cmakeFlags = [
    "-Wno-dev"
    (lib.cmakeBool "sqlcipher" true)
    (lib.cmakeBool "ENABLE_TESTING" (finalAttrs.finalPackage.doCheck or false))
    (lib.cmakeBool "FORCE_INTERNAL_QSCINTILLA" false)
    (lib.cmakeBool "FORCE_INTERNAL_QCUSTOMPLOT" false)
    (lib.cmakeBool "FORCE_INTERNAL_QHEXEDIT" true) # TODO: package qhexedit
    (lib.cmakeFeature "QSCINTILLA_INCLUDE_DIR" "${lib.getDev qt'.qscintilla}/include")
  ];

  env.LANG = "C.UTF-8";

  doCheck = true;

  meta = with lib; {
    description = "DB Browser for SQLite";
    mainProgram = "sqlitebrowser";
    homepage = "https://sqlitebrowser.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
  };
})
