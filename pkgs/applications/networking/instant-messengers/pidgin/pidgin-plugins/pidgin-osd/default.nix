{
  lib,
  stdenv,
  fetchFromGitHub,
  pidgin,
  xosd,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "pidgin-osd";
  version = "0.2.0";
  src = fetchFromGitHub {
    owner = "edanaher";
    repo = "pidgin-osd";
    rev = "${pname}-${version}";
    sha256 = "07wa9anz99hnv6kffpcph3fbq8mjbyq17ij977ggwgw37zb9fzb5";
  };

  # autoreconf is run such that it *really* wants all the files, and there's no
  # default ChangeLog.  So make it happy.
  preAutoreconf = "touch ChangeLog";

  postInstall = ''
    mkdir -p $out/lib/pidgin
    mv $out/lib/pidgin-osd.{la,so} $out/lib/pidgin
  '';

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    xosd
    pidgin
  ];

  meta = with lib; {
    homepage = "https://github.com/mbroemme/pidgin-osd";
    description = "Plugin for Pidgin which implements on-screen display via libxosd";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
