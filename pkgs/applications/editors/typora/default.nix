{ stdenv, fetchurl, makeWrapper, electron_3, dpkg, gtk3, glib, gnome3, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "typora";
  version = "0.9.64";

  src = fetchurl {
    url = "https://www.typora.io/linux/typora_${version}_amd64.deb";
    sha256 = "0dffydc11ys2i38gdy8080ph1xlbbzhcdcc06hyfv0dr0nf58a09";
  };

  nativeBuildInputs = [ dpkg makeWrapper wrapGAppsHook ];

  buildInputs = [ gtk3 glib gnome3.gsettings-desktop-schemas ];

  unpackPhase = "dpkg-deb -x $src .";

  dontWrapGApps = true;

  installPhase = ''
    mkdir -p $out/bin $out/share/typora
    {
      cd usr
      mv share/typora/resources/app/* $out/share/typora
      mv share/applications $out/share
      mv share/icons $out/share
      mv share/doc $out/share
    }

    makeWrapper ${electron_3}/bin/electron $out/bin/typora \
      --add-flags $out/share/typora \
      "''${gappsWrapperArgs[@]}" \
      --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ stdenv.cc.cc ]}"
  '';

  meta = with stdenv.lib; {
    description = "A minimal Markdown reading & writing app";
    homepage = https://typora.io;
    license = licenses.unfree;
    maintainers = with maintainers; [ jensbin ];
    inherit (electron_3.meta) platforms;
  };
}
