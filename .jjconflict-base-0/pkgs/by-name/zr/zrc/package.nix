{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  flex,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zrc";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "Edd12321";
    repo = "zrc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-prUbuXyhIJczCvjqwm9pp2n75LY10+6SzYaOHd+S748=";
  };

  nativeBuildInputs = [
    bison
    flex
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "UNIX shell and scripting language with syntax similar to Tcl";
    homepage = "https://github.com/Edd12321/zrc";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fgaz ];
    mainProgram = "zrc";
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
