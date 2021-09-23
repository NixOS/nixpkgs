{ lib
, stdenv
, fetchFromGitHub
, scons
, python
, ragel
, gengetopt
, libuv
, libpulseaudio
, libunwind
, openfec
, sox
}:

stdenv.mkDerivation {
  pname = "roc-toolkit";
  version = "unstable-2021-06-15";

  src = fetchFromGitHub {
    owner = "roc-streaming";
    repo = "roc-toolkit";
    rev = "c89687330bfce6f4dce79826f7a235b581f2b49d";
    sha256 = "1j2gqfpsh0hrwrwvanv6b893b9pds93rv7bl7am2050j3jqmfjrw";
  };

  nativeBuildInputs = [ scons python ragel gengetopt ];
  buildInputs = [ libuv libpulseaudio libunwind openfec sox ];

  prefixKey = "--prefix=";

  sconsFlags = [
    "--jobs=1"
    "--disable-tests"
    "--disable-doc"
    "--with-openfec-includes=${openfec}/include/openfec"
  ];

  meta = with lib; {
    description = "Toolkit for real-time audio streaming over the network";
    homepage = "https://roc-streaming.org/";
    license = licenses.mpl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ iclanzan ];
  };
}
