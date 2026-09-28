{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  cmake,
  pkg-config,
  curl,
  html-tidy,
  jsoncpp,
  ninja,
  nix-update-script,
  rhash,
  tinyxml-2,
  versionCheckHook,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lgogdownloader";
  version = "3.19";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Sude-";
    repo = "lgogdownloader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4JHV2m5zSekWYpO0j3weH5hiG/kmciDF4Jby46ykxCI=";
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
  nativeInstallCheckInputs = [ versionCheckHook ];
  preVersionCheck = ''
    export HOME=$TMPDIR
  '';
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Unofficial GOG.com downloader";
    homepage = "https://sites.google.com/site/gogdownloader/";
    changelog = "https://github.com/Sude-/lgogdownloader/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.wtfpl;
    maintainers = with lib.maintainers; [
      _0x4A6F
      keenanweaver
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "lgogdownloader";
  };
})
