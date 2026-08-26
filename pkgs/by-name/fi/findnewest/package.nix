{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "findnewest";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "0-wiz-0";
    repo = "findnewest";
    rev = "findnewest-${finalAttrs.version}";
    sha256 = "1x1cbn2b27h5r0ah5xc06fkalfdci2ngrgd4wibxjw0h88h0nvgq";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    homepage = "https://github.com/0-wiz-0/findnewest";
    description = "Recursively find newest file in a hierarchy and print its timestamp";
    mainProgram = "fn";
    license = lib.licenses.bsd2;
  };
})
