{ stdenv, fetchFromGitHub, cmake, perl
, enableGui ? false, qt5
, enableJupyter ? false, boost, jsoncpp, openssl, zmqpp
}:

stdenv.mkDerivation rec {
  pname = "yacas";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "grzegorzmazur";
    repo = "yacas";
    rev = "v${version}";
    sha256 = "0awvlvf607r4hwl1vkhs6jq2s6ig46c66pmr4vspj2cdnypx99cc";
  };

  hardeningDisable = [ "format" ];

  cmakeFlags = [
    "-DENABLE_CYACAS_GUI=${if enableGui then "ON" else "OFF"}"
    "-DENABLE_CYACAS_KERNEL=${if enableJupyter then "ON" else "OFF"}"
  ];

  # Perl is only for the documentation
  nativeBuildInputs = [ cmake perl ];
  buildInputs = [
  ] ++ stdenv.lib.optionals enableGui (with qt5; [ qtbase qtwebkit ])
    ++ stdenv.lib.optionals enableJupyter [ boost jsoncpp openssl zmqpp ]
    ;

  meta = {
    description = "Easy to use, general purpose Computer Algebra System";
    homepage = http://www.yacas.org/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
    broken = enableGui || enableJupyter;
  };
}
