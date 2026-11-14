{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  SDL2_net,
  fetchzip,
  nix-update-script,
  pkg-config,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opentyrian2000";
  version = "2000.20250408";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "KScl";
    repo = "opentyrian2000";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UFD2Lvx74lUJXwn0ht+0jpPn6kKhjjLY2mP8SGPj0ok=";
  };

  data = fetchzip {
    url = "https://www.camanis.net/tyrian/tyrian2000.zip";
    hash = "sha256-KiYFsbiHtqQCJpXzKL5jyFS+Ho25unqaLGES8+Yj1Nw=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    SDL2
    SDL2_net
  ];

  makeFlags = [
    "prefix=${placeholder "out"}"
    "OPENTYRIAN_VERSION=${finalAttrs.src.tag}"
  ];

  postInstall = ''
    mkdir -p $out/share/games/opentyrian2000
    cp -r ${finalAttrs.data}/* $out/share/games/opentyrian2000/
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  enableParallelBuilding = true;
  versionCheckKeepEnvironment = [ "HOME" ];
  passthru.updateScript = nix-update-script { };

  meta = {
    description = ''Open source port of the game "Tyrian 2000"'';
    homepage = "https://github.com/KScl/opentyrian2000";
    changelog = "https://github.com/KScl/opentyrian2000/releases/tag/${finalAttrs.src.tag}";
    license =
      with lib.licenses;
      AND [
        gpl2Plus # opentyrian2000
        unfree # First-party assets we bundle
      ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [
      iedame
      keenanweaver
    ];
    platforms = lib.platforms.unix;
    mainProgram = "opentyrian2000";
  };
})
