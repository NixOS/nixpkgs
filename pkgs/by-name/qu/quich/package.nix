{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "quich";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "Usbac";
    repo = "quich";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-4gsSjLZ7Z4ErNqe86Fy5IrzLMfvDyY18sE0yBnj9bvM=";
  };

  doCheck = true;

  makeFlags = [
    "DESTDIR="
    "PREFIX=$(out)"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  meta = {
    description = "Advanced terminal calculator";
    longDescription = ''
      Quich is a compact, fast, powerful and useful calculator for your terminal
      with numerous features, supporting Windows and Linux Systems,
      written in ANSI C.
    '';
    homepage = "https://github.com/Usbac/quich";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.xdhampus ];
    platforms = lib.platforms.all;
    mainProgram = "quich";
  };
})
