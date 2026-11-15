{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  SDL2_mixer,
  SDL2_net,
  bzip2,
  cmake,
  gtk3,
  libjpeg,
  makeWrapper,
  nix-update-script,
  pkg-config,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ecwolf";
  version = "1.4.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "ECWolfEngine";
    repo = "ECWolf";
    tag = finalAttrs.version;
    hash = "sha256-T5K6B2fWMKMLB/662p/YLEv0Od9n0vUakznyoOnr0kI=";
  };

  postPatch = ''
    substituteInPlace tools/updaterevision/UpdateRevision.cmake \
      --replace-fail "<unknown version>" "${finalAttrs.src.tag}"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ makeWrapper ];

  buildInputs = [
    bzip2
    libjpeg
    SDL2
    SDL2_mixer
    SDL2_net
    zlib
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ gtk3 ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    NIX_LDFLAGS = toString [
      "-framework"
      "AppKit"
    ];
  };

  doCheck = false;

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    cp -R ecwolf.app $out/Applications
    makeWrapper $out/{Applications/ecwolf.app/Contents/MacOS,bin}/ecwolf
  '';

  doInstallCheck = !stdenv.hostPlatform.isDarwin;

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgramArg = "--help";

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "Advanced source port of the Wolfenstein 3D engine";
    homepage = "https://maniacsvault.net/ecwolf/";
    changelog = "https://github.com/ECWolfEngine/ECWolf/blob/${finalAttrs.src.tag}/docs/changelog";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      jayman2000
      keenanweaver
    ];
    platforms = lib.platforms.all;
    mainProgram = "ecwolf";
  };
})
