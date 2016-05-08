{ stdenv, fetchhg, pkgconfig, libixp_hg, txt2tags, dash, python, which
, libX11 , libXrender, libXext, libXinerama, libXrandr, libXft }:

stdenv.mkDerivation rec {
  rev = "2823";
  version = "hg-2012-12-09";
  name = "wmii-${version}";

  src = fetchhg {
    url = https://code.google.com/p/wmii/;
    sha256 = "1wqw41jb2fhq902a04ixfzmx0lia1pawahm1ymyrs3is6mm32r51";
    inherit rev;
  };

  # for dlopen-ing
  patchPhase = ''
    substituteInPlace lib/libstuff/x11/xft.c --replace "libXft.so" "${libXft}/lib/libXft.so"
    substituteInPlace cmd/wmii.sh.sh --replace "\$(which which)" "${which}/bin/which"
  '';

  configurePhase = ''
    for file in $(grep -lr '#!.*sh'); do
      sed -i 's|#!.*sh|#!${dash}/bin/dash|' $file
    done

    cat <<EOF >> config.mk
    PREFIX = $out
    LIBIXP = ${libixp_hg}/lib/libixp.a
    BINSH = ${dash}/bin/dash
    EOF
  '';

  buildInputs = [ pkgconfig libixp_hg txt2tags dash python which
                  libX11 libXrender libXext libXinerama libXrandr libXft ];

  # For some reason including mercurial in buildInputs did not help
  makeFlags = "WMII_HGVERSION=hg${rev}";

  meta = {
    homepage = "https://code.google.com/p/wmii/";
    description = "A small window manager controlled by a 9P filesystem";
    maintainers = with stdenv.lib.maintainers; [ kovirobi ];
    license = stdenv.lib.licenses.mit;
    inherit version;
  };
}
