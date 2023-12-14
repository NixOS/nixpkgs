{ lib
, stdenv
, fetchFromGitHub
, cmake
, autoconf
, automake
, libtool
, mp4v2
}:

let
  faad2.src = fetchFromGitHub {
    owner = "knik0";
    repo = "faad2";
    rev = "2.10.1";
    hash = "sha256-k7y12OwCn3YkNZY9Ov5Y9EQtlrZh6oFUzM27JDR960w=";
  };
in
stdenv.mkDerivation rec {
  pname = "aacgain";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "dgilman";
    repo = pname;
    rev = version;
    sha256 = "sha256-9Y23Zh7q3oB4ha17Fpm1Hu2+wtQOA1llj6WDUAO2ARU=";
  };

  postPatch = ''
    cp -R ${faad2.src}/* 3rdparty/faad2
    cp -R ${mp4v2.src}/* 3rdparty/mp4v2
    chmod -R +w 3rdparty
  '';

  nativeBuildInputs = [
    cmake
    autoconf
    automake
    libtool
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=narrowing";

  meta = with lib; {
    description = "ReplayGain for AAC files";
    homepage = "https://github.com/dgilman/aacgain";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.robbinch ];
  };
}
