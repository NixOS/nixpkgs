{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kbdlight";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "WhyNotHugo";
    repo = "kbdlight";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3i5xNuJJFxg/2uAqwoKKc1uabpzvEFKWJnTlHlpUCLg=";
  };

  preConfigure = ''
    substituteInPlace Makefile \
      --replace /usr/local $out \
      --replace 4755 0755
  '';

  meta = {
    homepage = "https://github.com/WhyNotHugo/kbdlight";
    description = "Very simple application that changes MacBooks' keyboard backlight level";
    mainProgram = "kbdlight";
    license = lib.licenses.isc;
    maintainers = [ lib.maintainers.womfoo ];
    platforms = lib.platforms.linux;
  };
})
