{
  lib,
  stdenv,
  fetchFromGitHub,
  coreutils,
  gnugrep,
  groff,
  makeWrapper,
  nix-update-script,
  versionCheckHook,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "graudit";
  version = "4.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "wireghoul";
    repo = "graudit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PHsXrMWTsAbsvIKpxTlGKrmDcLy/qyEtbTy49NF5I7c=";
  };

  postPatch = ''
    substituteInPlace graudit \
      --replace-fail '#!/bin/bash' '#!${stdenv.shell}'
  '';

  nativeBuildInputs = [
    groff
    makeWrapper
  ];

  buildInputs = [
    coreutils
    gnugrep
    which
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  buildPhase = ''
    runHook preBuild
    make signatures manpages
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 graudit $out/libexec/graudit/graudit
    install -dm755 $out/libexec/graudit/signatures
    install -m644 -t $out/libexec/graudit/signatures signatures/*.db
    install -dm755 $out/libexec/graudit/misc
    install -m644 -t $out/libexec/graudit/misc misc/*.db

    makeWrapper $out/libexec/graudit/graudit $out/bin/graudit \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gnugrep
          which
        ]
      }

    runHook postInstall
  '';

  postInstall = ''
    install -Dm644 graudit.1 $out/share/man/man1/graudit.1
    install -Dm644 graudit.7 $out/share/man/man7/graudit.7
  '';

  doInstallCheck = true;

  versionCheckProgramArg = "-v";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Source code auditing tool";
    homepage = "https://github.com/wireghoul/graudit";
    changelog = "https://github.com/wireghoul/graudit/blob/${finalAttrs.src.rev}/Changelog";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "graudit";
    platforms = lib.platforms.all;
  };
})
