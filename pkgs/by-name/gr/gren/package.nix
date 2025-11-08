{
  lib,
  stdenv,
  fetchFromGitHub,
  makeBinaryWrapper,
  nodejs,
  git,
  haskellPackages,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gren";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "gren-lang";
    repo = "compiler";
    tag = finalAttrs.version;
    hash = "sha256-P8Y6JOgxGAVWT9DfbNLHVJnsPBcrUkHEumkU56riI10=";
  };

  buildInputs = [ nodejs ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall

    # install the precompiled frontend into the proper location
    install -Dm755 bin/compiler $out/bin/gren

    wrapProgram $out/bin/gren \
      --set-default GREN_BIN ${lib.getExe finalAttrs.passthru.backend} \
      --suffix PATH : ${lib.makeBinPath [ git ]}

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/gren";
  versionCheckProgramArg = "--version";

  passthru = {
    backend = haskellPackages.callPackage ./generated-backend-package.nix { };
    updateScript = ./update.sh;
  };

  meta = {
    description = "Programming language for simple and correct applications";
    homepage = "https://gren-lang.org";
    license = lib.licenses.bsd3;
    platforms = lib.intersectLists haskellPackages.ghc.meta.platforms nodejs.meta.platforms;
    mainProgram = "gren";
    maintainers = with lib.maintainers; [
      robinheghan
      tomasajt
    ];
  };
})
