{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  jdk8,
  coreutils,
  which,
  gnumake,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "drip";
  version = "0.2.4";

  src = fetchFromGitHub {
    repo = "drip";
    owner = "ninjudd";
    tag = finalAttrs.version;
    hash = "sha256-ASsEPS8l3E3ReerIrVRQ1ICyMKMFa1XE+WYqxxsXhv4=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ jdk8 ];

  patches = [ ./wait.patch ];

  postPatch = ''
    patchShebangs .
  '';

  installPhase = ''
    runHook preInstall
    mkdir $out
    cp ./* $out -r
    wrapProgram $out/bin/drip \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          which
          gnumake
          jdk8
        ]
      }
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  meta = {
    description = "Launcher for the Java Virtual Machine intended to be a drop-in replacement for the java command, only faster";
    license = lib.licenses.epl10;
    homepage = "https://github.com/ninjudd/drip";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      rybern
      da157
    ];
  };
})
