{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "genann";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "codeplea";
    repo = "genann";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-WZuJbCJZXjJE4X6pAcWvlDqHMw3bEdFIBbTvFJNXM04=";
  };

  dontBuild = true;
  doCheck = true;

  # Nix doesn't seem to recognize this by default.
  checkPhase = ''
    make check
  '';

  installPhase = ''
    mkdir -p $out/include
    cp ./genann.{h,c} $out/include
  '';

  meta = {
    homepage = "https://github.com/codeplea/genann";
    description = "Simple neural network library in ANSI C";
    license = lib.licenses.zlib;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
