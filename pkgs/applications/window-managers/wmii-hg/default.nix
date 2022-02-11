{ lib, stdenv, fetchurl, unzip, pkg-config, libixp_hg, txt2tags, dash, python2, which
, libX11 , libXrender, libXext, libXinerama, libXrandr, libXft }:

stdenv.mkDerivation rec {
  rev = "2823";
  version = "hg-2012-12-09";
  pname = "wmii";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-source/v2/code.google.com/wmii/source-archive.zip";
    sha256 = "1wmkq14zvmfrmydl8752xz852cy7agrx3qp4fy2cc5asb2r9abaz";
  };

  # for dlopen-ing
  patchPhase = ''
    substituteInPlace lib/libstuff/x11/xft.c --replace "libXft.so" "$(pkg-config --variable=libdir xft)/libXft.so.2"
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

  nativeBuildInputs = [ pkg-config unzip ];
  buildInputs = [ libixp_hg txt2tags dash python2 which
                  libX11 libXrender libXext libXinerama libXrandr libXft ];

  # For some reason including mercurial in buildInputs did not help
  makeFlags = [ "WMII_HGVERSION=hg${rev}" ];

  meta = {
    homepage = "https://suckless.org/"; # https://wmii.suckless.org/ does not exist anymore
    description = "A small window manager controlled by a 9P filesystem";
    maintainers = with lib.maintainers; [ kovirobi ];
    license = lib.licenses.mit;
    platforms = with lib.platforms; linux;
  };
}
