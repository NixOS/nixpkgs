{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, gfortran
, guile
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "libctl";
  version = "4.5.1";

  src = fetchFromGitHub {
    owner = "NanoComp";
    repo = pname;
    rev = "v${version}";
    sha256 = "uOydBWYPXSBUi+4MM6FNx6B5l2to7Ny9Uc1MMTV9bGA=";
  };

  nativeBuildInputs = [ autoreconfHook gfortran guile pkg-config ];

  configureFlags = [ "--enable-shared" ];

  meta = with lib; {
    description = "Guile-based library for supporting flexible control files in scientific simulations";
    mainProgram = "gen-ctl-io";
    homepage = "https://github.com/NanoComp/libctl";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ carpinchomug ];
  };
}
