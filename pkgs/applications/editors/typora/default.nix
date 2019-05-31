{ stdenv, fetchurl, makeWrapper, electron_3, dpkg, gtk3, glib, gsettings-desktop-schemas, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "typora";
  version = "0.9.70";

  src = fetchurl {
    url = "https://www.typora.io/linux/typora_${version}_amd64.deb";
    sha256 = "08bgllbvgrpdkk9bryj4s16n274ps4igwrzdvsdbyw8wpp44vcy2";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gsettings-desktop-schemas
    gtk3
  ];

  unpackPhase = "dpkg-deb -x $src .";

  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    {
      cd usr
      mv share/typora/resources/app $out/share/typora
      mv share/{applications,icons,doc} $out/share/
    }

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper ${electron_3}/bin/electron $out/bin/typora \
      --add-flags $out/share/typora \
      "''${gappsWrapperArgs[@]}" \
      --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ stdenv.cc.cc ]}"
  '';

  meta = with stdenv.lib; {
    description = "A minimal Markdown reading & writing app";
    homepage = https://typora.io;
    license = licenses.unfree;
    maintainers = with maintainers; [ jensbin worldofpeace ];
    inherit (electron_3.meta) platforms;
  };
}
