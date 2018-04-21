{ stdenv, fetchFromBitbucket, opusfile, libopus, libogg, openssl, deadbeef }:

stdenv.mkDerivation rec {
  name = "deadbeef-opus-plugin-${version}";
  version = "0.8";

  src = fetchFromBitbucket {
    owner = "Lithopsian";
    repo = "deadbeef-opus";
    rev = "v${version}";
    sha256 = "057rgsw4563gs63k05s7zsdc0n4djxwlbyqabf7c88f23z35ryyi";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  NIX_CFLAGS_COMPILE = [
    "-I${opusfile}/include/opus"
  ];

  buildInputs = [ deadbeef opusfile libopus libogg openssl ];

  meta = with stdenv.lib; {
    description = "Ogg Opus decoder plugin for the DeaDBeeF music player";
    homepage = https://bitbucket.org/Lithopsian/deadbeef-opus;
    license = licenses.gpl2; # There are three files, each licensed under different license: zlib, gpl2Plus and lgpl2
    maintainers = [ maintainers.jtojnar ];
    platforms = platforms.linux;
  };
}
