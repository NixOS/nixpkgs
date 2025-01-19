{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "pod2mdoc";
  version = "0.0.10";

  src = fetchurl {
    url = "http://mdocml.bsd.lv/pod2mdoc/snapshots/pod2mdoc-${version}.tgz";
    sha256 = "0nwa9zv9gmfi5ysz1wfm60kahc7nv0133n3dfc2vh2y3gj8mxr4f";
  };

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
    install -m 0755 pod2mdoc $out/bin
    install -m 0444 pod2mdoc.1 $out/share/man/man1
  '';

  meta = {
    homepage = "http://mdocml.bsd.lv/";
    description = "converter from POD into mdoc";
    license = lib.licenses.isc;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ramkromberg ];
    mainProgram = "pod2mdoc";
  };
}
