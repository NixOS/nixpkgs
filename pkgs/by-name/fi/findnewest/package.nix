{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "findnewest";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "0-wiz-0";
    repo = "findnewest";
    rev = "findnewest-${version}";
    sha256 = "1x1cbn2b27h5r0ah5xc06fkalfdci2ngrgd4wibxjw0h88h0nvgq";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    homepage = "https://github.com/0-wiz-0/findnewest";
    description = "Recursively find newest file in a hierarchy and print its timestamp";
    mainProgram = "fn";
    license = licenses.bsd2;
    maintainers = with maintainers; [ bhipple ];
  };
}
