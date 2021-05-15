{ stdenv, lib, fetchFromGitHub, cmake, pkg-config
, alsaLib, asio, avahi, boost170, flac, libogg, libvorbis, soxr
, nixosTests }:

let

  dependency = { name, version, sha256 }:
  stdenv.mkDerivation {
    name = "${name}-${version}";

    src = fetchFromGitHub {
      owner = "badaix";
      repo  = name;
      rev   = "v${version}";
      inherit sha256;
    };

    nativeBuildInputs = [ cmake ];
  };

  aixlog = dependency {
    name    = "aixlog";
    version = "1.5.0";
    sha256  = "09mnkrans9zmwfxsiwgkm0rba66c11kg5zby9x3rjic34gnmw6ay";
  };

  popl = dependency {
    name    = "popl";
    version = "1.2.0";
    sha256  = "1z6z7fwffs3d9h56mc2m24d5gp4fc5bi8836zyfb276s6fjyfcai";
  };

in

stdenv.mkDerivation rec {
  pname = "snapcast";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner  = "badaix";
    repo   = "snapcast";
    rev    = "v${version}";
    sha256 = "13yz8alplnqwkcns3mcli01qbyy6l3h62xx0v71ygcrz371l4g9g";
  };

  nativeBuildInputs = [ cmake pkg-config boost170.dev ];
  # snapcast also supports building against tremor but as we have libogg, that's
  # not needed
  buildInputs = [
    alsaLib asio avahi flac libogg libvorbis
    aixlog popl soxr
  ];

  # Upstream systemd unit files are pretty awful, so we provide our own in a
  # NixOS module. It might make sense to get that upstreamed...
  postInstall = ''
    install -d $out/share/doc/snapcast
    cp -r ../doc/* ../*.md $out/share/doc/snapcast
  '';

  passthru.tests.snapcast = nixosTests.snapcast;

  meta = with lib; {
    description = "Synchronous multi-room audio player";
    homepage = "https://github.com/badaix/snapcast";
    maintainers = with maintainers; [ fpletz ];
    license = licenses.gpl3Plus;
  };
}
