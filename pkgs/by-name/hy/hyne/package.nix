{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  makeWrapper,
  nix-update-script,
  qt6,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hyne";
  version = "1.11.4-unstable-2025-10-10";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "myst6re";
    repo = "hyne";
    rev = "54cc50dc133897b9db45f9deab5167e9d14de0fc";
    hash = "sha256-uSO04W95sOlNqBJl6zruPHI20Iouw5xzrMjdjFZK6HU=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'translations/''${RELEASE_NAME}_' 'translations/hyne_'
  '';

  nativeBuildInputs = [
    cmake
    qt6.qttools
    qt6.wrapQtAppsHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ makeWrapper ];

  buildInputs = [
    qt6.qt5compat
    qt6.qtbase
    zlib
  ];

  cmakeFlags = [ (lib.cmakeBool "ENABLE_JP_ENCODING" true) ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications $out/bin
    mv $out/Hyne.app $out/Applications/
    makeWrapper $out/Applications/Hyne.app/Contents/MacOS/Hyne $out/bin/Hyne
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
      "--version-regex"
      "(\\d.*)"
    ];
  };

  meta = {
    description = "Final Fantasy VIII save editor";
    homepage = "https://github.com/myst6re/hyne";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "Hyne";
  };
})
