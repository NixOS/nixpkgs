{ stdenv, fetchpatch, fetchFromGitHub, pkgconfig, glib, mpv }:

stdenv.mkDerivation rec {
  pname = "mpv-mpris";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "hoyon";
    repo = "mpv-mpris";
    rev = version;
    sha256 = "07p6li5z38pkfd40029ag2jqx917vyl3ng5p2i4v5a0af14slcnk";
  };
  patches = [
    # Enables to "make SCRIPTS_DIR=... install" https://github.com/hoyon/mpv-mpris/pull/38
    (fetchpatch {
      url = "https://github.com/hoyon/mpv-mpris/commit/f1482350868bf20e4575f923943ec998469b255e.patch";
      sha256 = "1lqy867wpmj6hv3zgi6g679a7x3dv5skpw24hwd05b28galnyd4l";
    })
  ];

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ glib mpv ];

  installFlags = [ "SCRIPTS_DIR=$(out)/share/mpv/scripts" ];

  # Otherwise, the shared object isn't `strip`ped. See:
  # https://discourse.nixos.org/t/debug-why-a-derivation-has-a-reference-to-gcc/7009
  stripDebugList = [ "share/mpv/scripts" ];
  passthru.scriptName = "mpris.so";

  meta = with stdenv.lib; {
    description = "MPRIS plugin for mpv";
    homepage = "https://github.com/hoyon/mpv-mpris";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
