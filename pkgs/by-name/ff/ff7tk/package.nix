{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  zlib,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ff7tk";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "sithlord48";
    repo = "ff7tk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SeWDWzSShS6nKTSIDBc+pBLVz3JGQ4PvHb6kbllMFxk=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail ':/lib:/usr/lib:/usr/local/lib:\$HOME/.local/lib:\$HOME/.local/usr/lib' ""
    substituteInPlace src/ff7tk/ff7tkInfo.h.in \
      --replace-fail '"/usr/share/ff7tk"' "\"$out/share/ff7tk\""
  '';

  nativeBuildInputs = [
    cmake
    qt6.qttools
  ];

  buildInputs = [
    qt6.qt5compat
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_ALL_CPU" false)
    (lib.cmakeBool "DOCS" false)
    (lib.cmakeBool "PACKAGE" false)
    (lib.cmakeBool "TESTS" finalAttrs.finalPackage.doCheck)
  ];

  postInstall = ''
    rm -r $out/lib/debug
  '';

  dontWrapQtApps = true;

  doCheck = true;
  # GZIP tests share a fixed temp file
  enableParallelChecking = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Toolkit for making tools to edit Final Fantasy VII";
    homepage = "https://github.com/sithlord48/ff7tk";
    changelog = "https://github.com/sithlord48/ff7tk/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.linux;
  };
})
