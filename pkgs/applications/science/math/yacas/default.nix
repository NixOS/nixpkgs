{ lib, stdenv, fetchFromGitHub, cmake, perl
, enableGui ? false, qt5
, enableJupyter ? false, boost, jsoncpp, openssl, zmqpp
}:

stdenv.mkDerivation rec {
  pname = "yacas";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "grzegorzmazur";
    repo = "yacas";
    rev = "v${version}";
    sha256 = "0dqgqvsb6ggr8jb3ngf0jwfkn6xwj2knhmvqyzx3amc74yd3ckqx";
  };

  hardeningDisable = [ "format" ];

  cmakeFlags = [
    "-DENABLE_CYACAS_GUI=${if enableGui then "ON" else "OFF"}"
    "-DENABLE_CYACAS_KERNEL=${if enableJupyter then "ON" else "OFF"}"
  ];

  # Perl is only for the documentation
  nativeBuildInputs = [ cmake perl ];
  buildInputs = [
  ] ++ lib.optionals enableGui (with qt5; [ qtbase qtwebkit ])
    ++ lib.optionals enableJupyter [ boost jsoncpp openssl zmqpp ]
    ;

  meta = {
    description = "Easy to use, general purpose Computer Algebra System";
    homepage = "http://www.yacas.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [viric];
    platforms = with lib.platforms; linux;
    broken = enableGui || enableJupyter;
  };
}
