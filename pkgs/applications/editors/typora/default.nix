{ stdenv, fetchurl, makeWrapper, electron_3, dpkg, gtk3, glib, gnome3, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "typora";
  version = "0.9.65";

  src = fetchurl {
    url = "https://www.typora.io/linux/typora_${version}_amd64.deb";
    sha256 = "1y2ydz1vcphcp8rzw9q1iray446xig3m48c8r50qs3bx6bfyf0g9";
  };

  nativeBuildInputs = [ dpkg makeWrapper wrapGAppsHook ];

  buildInputs = [ gtk3 glib gnome3.gsettings-desktop-schemas ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    mkdir -p $out/bin $out/share
    {
      cd usr
      mv share/typora/resources/app $out/share/typora
      mv share/{applications,icons,doc} $out/share/
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
