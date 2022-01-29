{ stdenv, lib, fetchFromGitHub, cmake, pkg-config
, alsa-lib, asio, avahi, boost17x, flac, libogg, libvorbis, soxr
, pulseaudioSupport ? false, libpulseaudio
, nixosTests }:

assert pulseaudioSupport -> libpulseaudio != null;

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
  version = "0.26.0";

  src = fetchFromGitHub {
    owner  = "badaix";
    repo   = "snapcast";
    rev    = "v${version}";
    sha256 = "sha256-CCifn9OEFM//Hk1PJj8T3MXIV8pXCTdBBXPsHuZwLyQ=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  # snapcast also supports building against tremor but as we have libogg, that's
  # not needed
  buildInputs = [
    boost17x
    alsa-lib asio avahi flac libogg libvorbis
    aixlog popl soxr
  ] ++ lib.optional pulseaudioSupport libpulseaudio;

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
