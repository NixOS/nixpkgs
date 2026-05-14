{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "emojify";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "mrowa44";
    repo = "emojify";
    rev = finalAttrs.version;
    hash = "sha256-6cV+S8wTqJxPGsxiJ3hP6/CYPMWdF3qnz4ddL+F/oJU=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm755 emojify $out/bin/emojify
    runHook postInstall
  '';

  meta = {
    description = "Emoji on the command line";
    homepage = "https://github.com/mrowa44/emojify";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = "emojify";
  };
})
