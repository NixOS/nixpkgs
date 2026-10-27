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
  pname = "opentyrian";
  version = "2.1.20260913";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "opentyrian";
    repo = "opentyrian";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zAYn8/JKGtjj3REuQ3WeeKlQ+ifuhwEF7m3ixg/5154=";
  };

  data = fetchzip {
    url = "https://camanis.net/tyrian/tyrian21.zip";
    hash = "sha256-q11Ygg56zoWKMPbS6Q8v4Tx/OLrmAT+R5RkfbRw0P64=";
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
    mkdir -p $out/share/games/tyrian
    cp -r ${finalAttrs.data}/* $out/share/games/tyrian/
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
    description = ''Open source port of the game "Tyrian"'';
    homepage = "https://github.com/opentyrian/opentyrian";
    changelog = "https://github.com/opentyrian/opentyrian/releases/tag/${finalAttrs.src.tag}";
    license =
      with lib.licenses;
      AND [
        gpl2Plus # opentyrian
        unfree # First-party assets we bundle
      ];
    maintainers = with lib.maintainers; [
      iedame
      keenanweaver
    ];
    platforms = lib.platforms.unix;
    mainProgram = "opentyrian";
  };
})
