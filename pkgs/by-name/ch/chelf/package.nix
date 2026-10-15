{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chelf";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "Gottox";
    repo = "chelf";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Jst77ygmFeU5c3TYKsdUGdZtTnBuNcumiBp76xVBjXc=";
  };

  installPhase = ''
    mkdir -p $out/bin
    mv chelf $out/bin/chelf
  '';

  meta = {
    description = "Change or display the stack size of an ELF binary";
    homepage = "https://github.com/Gottox/chelf";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "chelf";
  };
})
