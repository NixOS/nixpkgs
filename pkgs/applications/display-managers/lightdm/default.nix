{ stdenv, fetchurl, pam, pkgconfig, libxcb, glib, libXdmcp, itstool, libxml2
, intltool, x11, libxklavier, libgcrypt
, qt4 ? null, qt5 ? null
}:

let
  ver_branch = "1.13";
  version = "1.13.1";
in
stdenv.mkDerivation rec {
  name = "lightdm-${version}";

  src = fetchurl {
    url = "${meta.homepage}/${ver_branch}/${version}/+download/${name}.tar.xz";
    sha256 = "0xa23maq6phkfil8xx26viig2m99sbzcf1w7s56hns2qw6pycn79";
  };

  buildInputs = [
    pkgconfig pam libxcb glib libXdmcp itstool libxml2 intltool libxklavier libgcrypt
    qt4 qt5
  ];

  configureFlags = [
    "--enable-liblightdm-gobject"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
  ] ++ stdenv.lib.optional (qt4 != null) "--enable-liblightdm-qt"
    ++ stdenv.lib.optional (qt5 != null) "--enable-liblightdm-qt5";

  installFlags = [ "DESTDIR=\${out}" ];

  # Correct for the nested nix folder tree
  postInstall = ''
    mv $out/$out/* $out
    DIR=$out/$out
    while rmdir $DIR 2>/dev/null; do
      DIR="$(dirname "$DIR")"
    done
  '';

  meta = with stdenv.lib; {
    homepage = http://launchpad.net/lightdm;
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [ ocharles wkennington ];
  };
}
