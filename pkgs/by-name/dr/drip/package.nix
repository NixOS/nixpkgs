{
  lib,
  stdenv,
  fetchFromGitHub,
  jdk8,
  which,
  makeWrapper,
  gnumake,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "drip";
  version = "0.2.4";

  src = fetchFromGitHub {
    repo = "drip";
    owner = "ninjudd";
    rev = finalAttrs.version;
    sha256 = "1zl62wdwfak6z725asq5lcqb506la1aavj7ag78lvp155wyh8aq1";
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
          which
          gnumake
          jdk8
        ]
      }
    $out/bin/drip version
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheck = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  meta = {
    description = "Launcher for the Java Virtual Machine intended to be a drop-in replacement for the java command, only faster";
    license = lib.licenses.epl10;
    homepage = "https://github.com/ninjudd/drip";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.rybern ];
  };
})
