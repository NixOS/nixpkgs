{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  cmake,
  curl,
  html-tidy,
  jsoncpp,
  ninja,
  nix-update-script,
  pkg-config,
  rhash,
  tinyxml-2,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lgogdownloader";
  version = "3.20";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Sude-";
    repo = "lgogdownloader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4sok6SXGOLYe/2c/POb84fJ/D7X//TCnXj+1tOidIq0=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    boost
    curl
    html-tidy
    jsoncpp
    rhash
    tinyxml-2
    zlib
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  versionCheckKeepEnvironment = [ "HOME" ];
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Unofficial GOG.com downloader";
    homepage = "https://sites.google.com/site/gogdownloader/";
    changelog = "https://github.com/Sude-/lgogdownloader/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.wtfpl;
    maintainers = with lib.maintainers; [
      _0x4A6F
      keenanweaver
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "lgogdownloader";
  };
})
