{ stdenv, lib, fetchzip, autoPatchelfHook, makeWrapper, unzip,
boost172, curl, libX11, libpng12, libxml2, libxslt, openssl, postgresql, qt5
, zlib }:

let
  desktopFileTemplate = ./skipper.desktop;
in
stdenv.mkDerivation rec {
  pname = "skipper";
  version = "3.2.31.1730";
  src = fetchzip {
    url = "https://downloads.skipper18.com/${version}/Skipper-${version}-Linux-all-64bit.zip";
    sha256 = "1cddxxsqdsbhrxxz411565bbbn3gddxwk6kc6nq8bdbrcdza51rl";
    stripRoot = false;
  };

  nativeBuildInputs = [ unzip autoPatchelfHook qt5.wrapQtAppsHook makeWrapper ];

  buildInputs = [
    boost172
    curl
    libX11
    libxml2
    libxslt
    openssl
    postgresql
    qt5.qtbase
    qt5.qtscript
  ];

  runtimeDependencies = [ libpng12 ];

  installPhase = ''
    mkdir -p $out/lib
    mv ./libs/libQtitan*.so* $out/lib
    rm -r ./libs ./bearer ./platforms

    mkdir -p $out/opt
    chmod +x ./Skipper
    mv ./* $out/opt

    makeWrapper $out/opt/Skipper $out/bin/skipper \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeDependencies} \
      ''${qtWrapperArgs[@]}

    mkdir -p $out/share/applications
    substitute ${desktopFileTemplate} \
      $out/share/applications/skipper.desktop \
      --replace "Exec=" "Exec=$out/bin/skipper" \
      --replace "Icon=" "Icon=$out/opt/Skipper.ico"
  '';

  meta = with lib; {
    description = "An ORM framework editor for Doctrine, Symfony, Laravel, etc.";
    homepage = "https://www.skipper18.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [ nover ];
    platforms = [ "x86_64-linux" ];
  };
}
