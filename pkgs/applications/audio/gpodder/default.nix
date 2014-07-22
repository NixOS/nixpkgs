{ pkgs, stdenv, fetchurl, python, buildPythonPackage, pythonPackages, mygpoclient, intltool,
  ipodSupport ? true, libgpod, gpodderHome ? "", gpodderDownloadDir ? "" }:

with pkgs.lib;

let
  inherit (pythonPackages) coverage feedparser minimock sqlite3 dbus pygtk eyeD3;

in buildPythonPackage rec {
  name = "gpodder-3.7.0";

  src = fetchurl {
    url = "http://gpodder.org/src/${name}.tar.gz";
    sha256 = "fa90ef4bdd3fd9eef95404f7f43f70912ae3ab4f8d24078484a2f3e11b14dc47";
  };

  buildInputs = [ coverage feedparser minimock sqlite3 mygpoclient intltool ];

  propagatedBuildInputs = [ feedparser dbus mygpoclient sqlite3 pygtk eyeD3 ]
    ++ stdenv.lib.optional ipodSupport libgpod;

  postPatch = "sed -ie 's/PYTHONPATH=src/PYTHONPATH=\$(PYTHONPATH):src/' makefile";

  checkPhase = "make unittest";

  preFixup = ''
    wrapProgram $out/bin/gpodder \
      ${optionalString (gpodderHome != "") "--set GPODDER_HOME ${gpodderHome}"} \
      ${optionalString (gpodderDownloadDir != "") "--set GPODDER_DOWNLOAD_DIR ${gpodderDownloadDir}"}
  '';

  installPhase = "DESTDIR=/ PREFIX=$out make install";

  meta = {
    description = "A podcatcher written in python";
    longDescription = ''
      gPodder downloads and manages free audio and video content (podcasts)
      for you. Listen directly on your computer or on your mobile devices.
    '';
    homepage = "http://gpodder.org/";
    license = "GPLv3";
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
    maintainers = [ stdenv.lib.maintainers.skeidel ];
  };
}
