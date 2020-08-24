{ stdenv, unzip, fetchurl, electron_6, makeWrapper, geogebra }:
stdenv.mkDerivation rec{

  name = "geogebra-${version}";
  version = "6-0-598-0";

  src = fetchurl {
    urls = [
        "https://download.geogebra.org/installers/6.0/GeoGebra-Linux64-Portable-${version}.zip"
        "https://web.archive.org/web/20200815132422/https://download.geogebra.org/installers/6.0/GeoGebra-Linux64-Portable-${version}.zip"
      ];
    sha256 = "1klazsgrpmfd6vjzpdcfl5x8qhhbh6vx2g6id4vg16ac4sjdrb0c";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    unzip
    makeWrapper
  ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    mkdir -p $out/libexec/geogebra/ $out/bin
    cp -r GeoGebra-linux-x64/{resources,locales} "$out/"
    makeWrapper ${stdenv.lib.getBin electron_6}/bin/electron $out/bin/geogebra --add-flags "$out/resources/app"
    install -Dm644 "${desktopItem}/share/applications/"* \
      -t $out/share/applications/

    install -Dm644 "${srcIcon}" \
      "$out/share/icons/hicolor/scalable/apps/geogebra.svg"
  '';

  srcIcon = geogebra.srcIcon;

  desktopItem = geogebra.desktopItem;
  meta = with stdenv.lib; geogebra.meta // {
    license = licenses.geogebra;
    maintainers = with maintainers; [ voidless ];
    platforms = platforms.linux;
  };
}
