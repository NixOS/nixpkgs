{
  lib,
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
  nodejs-slim,
  git,
  haskell,
  haskellPackages,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gren";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "gren-lang";
    repo = "compiler";
    tag = finalAttrs.version;
    hash = "sha256-eWs2Qsg3jCrBWAP7GAtBkG8RSoljjES6EpdN4IfpxaA=";
  };

  buildInputs = [
    nodejs-slim
    git
  ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall

    # install the precompiled frontend into the proper location
    install -Dm755 bin/compiler $out/bin/gren

    wrapProgram $out/bin/gren \
      --set-default GREN_BIN ${lib.getExe finalAttrs.passthru.backend} \

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/gren";

  passthru = {
    backend = haskell.lib.justStaticExecutables (
      haskellPackages.callPackage ./generated-backend-package.nix { }
    );
    updateScript = ./update.sh;
  };

  meta = {
    description = "Programming language for simple and correct applications";
    homepage = "https://gren-lang.org";
    license = lib.licenses.bsd3;
    platforms = lib.intersectLists haskellPackages.ghc.meta.platforms nodejs-slim.meta.platforms;
    mainProgram = "gren";
    maintainers = with lib.maintainers; [
      robinheghan
      tomasajt
    ];
  };
})
