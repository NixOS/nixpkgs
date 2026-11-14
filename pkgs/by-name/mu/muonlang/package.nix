{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
}:

stdenv.mkDerivation {
  pname = "muon";
  version = "2019-11-27";

  src = fetchFromGitHub {
    owner = "nickmqb";
    repo = "muon";
    rev = "6d3a5054ae75b0e5a0ae633cf8cbc3e2a054f8b3";
    hash = "sha256-/5NgivngpRLYn09BMI5UXqchKIEWvZBOp10GQRCIYek=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildPhase = ''
    mkdir -p $out/bin $out/share/mu
    cp -r lib $out/share/mu
    ${stdenv.cc.targetPrefix}cc -o $out/bin/mu-unwrapped bootstrap/mu64.c
  '';

  installPhase = ''
    makeWrapper $out/bin/mu-unwrapped $out/bin/mu \
      --add-flags $out/share/mu/lib/core.mu
  '';

  meta = {
    description = "Modern low-level programming language";
    homepage = "https://github.com/nickmqb/muon";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
