{
  fetchFromGitHub,
  fetchpatch2,
  lib,
  stdenv,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dtach";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "crigler";
    repo = "dtach";
    tag = "v${finalAttrs.version}";
    hash = "sha256-os6jC3Wh0fiafQEUFlIHvC+F7xtlH3hQFDLcdTYYYyU=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/crigler/dtach/commit/6d80909a8c0fd19717010a3c76fec560f988ca48.patch?full_index=1";
      hash = "sha256-v3vToJdSwihiPCSjXjEJghiaynHPTEql3F7URXRjCbM=";
    })
  ];

  installPhase = ''
    runHook preInstall

    install -D dtach $out/bin/${finalAttrs.meta.mainProgram}

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://dtach.sourceforge.net";
    description = "Program that emulates the detach feature of screen";
    longDescription = ''
      dtach is a tiny program that emulates the detach feature of
      screen, allowing you to run a program in an environment that is
      protected from the controlling terminal and attach to it later.
      dtach does not keep track of the contents of the screen, and
      thus works best with programs that know how to redraw
      themselves.
    '';
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "dtach";
  };
})
