{ stdenv, lib, fetchFromGitHub, cmake, pkgconfig
, asio, alsaLib, avahi, libogg, libvorbis, flac }:

let

  popl = stdenv.mkDerivation rec {
    name = "popl-${version}";
    version = "1.1.0";

    src = fetchFromGitHub {
      owner = "badaix";
      repo = "popl";
      rev = "v${version}";
      sha256 = "1zgjgcingyi1xw61azxxasaidbgqidncml5c2y2cj90mz23yam1i";
    };
    nativeBuildInputs = [ cmake ];
  };

  aixlog = stdenv.mkDerivation rec {
    name = "aixlog-${version}";
    version = "1.2.1";

    src = fetchFromGitHub {
      owner = "badaix";
      repo = "aixlog";
      rev = "v${version}";
      sha256 = "1rh4jib5g41b85bqrxkl5g74hk5ryf187y9fw0am76g59xlymfpr";
    };
    nativeBuildInputs = [ cmake ];
  };

in

stdenv.mkDerivation rec {
  name = "snapcast-${version}";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "badaix";
    repo = "snapcast";
    rev = "v${version}";
    sha256 = "14f5jrsarjdk2mixmznmighrh22j6flp7y47r9j3qzxycmm1mcf6";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ asio popl aixlog alsaLib avahi libogg libvorbis flac ];

  meta = with lib; {
    description = "Synchronous multi-room audio player";
    homepage = https://github.com/badaix/snapcast;
    maintainers = with maintainers; [ fpletz ];
    license = licenses.gpl3;
  };
}
