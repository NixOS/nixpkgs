{
  lib,
  stdenv,
  fetchurl,
  copyDesktopItems,
  makeDesktopItem,
  autoPatchelfHook,
  flatpak,
  ostree,
  patchelf,
  ccid,
  cjson,
  curl,
  doxygen,
  libGL,
  libgcc,
  libsForQt5,
  libzip,
  openjpeg,
  openssl,
  pcsclite,
  proot,
  qt5,
  xml-security-c,
  openpace,
  pkg-config,
  makeWrapper,
}:

let
  xercesc_3_2 = stdenv.mkDerivation rec {
    pname = "xerces-c";
    version = "3.2.3";

    src = fetchurl {
      url = "mirror://apache/xerces/c/3/sources/xerces-c-${version}.tar.gz";
      hash = "sha256-+5b8SbH7iS0eZOU6atqKzPbw5tMM4JN5Vuxo05vXLH4=";
    };

    nativeBuildInputs = [ pkg-config ];
    configureFlags = [ "--disable-static" ];

    meta = {
      description = "Validating XML parser written in a portable subset of C++";
      homepage = "https://xerces.apache.org/xerces-c/";
      license = lib.licenses.asl20;
      platforms = lib.platforms.unix;
    };
  };

in
stdenv.mkDerivation rec {
  pname = "autenticacao-gov-pt-bin";
  version = "3.13.3";

  src = fetchurl {
    url = "https://github.com/amagovpt/autenticacao.gov/releases/download/v${version}/pteid-mw-${version}.flatpak";
    hash = "sha256-kUSUcX3/rPENdyd6ABeqADqK4CcSltwsdnmcgWzw8Fc=";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    copyDesktopItems
    autoPatchelfHook
    flatpak
    ostree
    patchelf
    qt5.wrapQtAppsHook
    makeWrapper
  ];

  buildInputs = [
    ccid
    cjson
    curl
    doxygen
    libGL
    libgcc
    libsForQt5.poppler
    libzip
    openjpeg
    openpace
    openssl
    pcsclite
    proot
    qt5.qtbase
    qt5.qtgraphicaleffects
    qt5.qtquickcontrols
    qt5.qtquickcontrols2
    qt5.qttools
    xercesc_3_2
    xml-security-c
  ];

  unpackPhase = ''
    ostree init --repo=pteid --mode=archive-z2
    ostree static-delta apply-offline --repo=pteid ${src}
    ostree checkout --repo=pteid -U $(echo pteid/objects/*/*.commit | sed -E "s/.*\/([^\/]+)\/([^\/]+)\.commit$/\1\2/") pteid_out
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = pname;
      desktopName = "Autenticação.gov";
      genericName = "Portuguese eID Data";
      comment = "Middleware for Electronic Identification in Portugal";
      icon = "pt.gov.autenticacao";
      terminal = false;
      startupNotify = true;
      categories = [ "Office" ];
    })
  ];

  preInstall = ''
    mkdir -p $out/share $out/app/{lib,share}
    cp -r pteid_out/files/bin $out/app
    cp -r pteid_out/files/lib/lib{pteid,CMD}* $out/app/lib/
    cp -r pteid_out/files/share/certs $out/app/share
    cp -r pteid_out/files/share/icons $out/share
  '';

  postInstall = ''
    makeWrapper "${proot}/bin/proot" "$out/bin/${pname}" \
      --add-flags "-b" \
      --add-flags "$out/app:/app" \
      --add-flags "$out/app/bin/eidguiV2" \
      --argv0 "$out/bin/eidguiV2"
  '';

  preFixup = ''
    find $out/app/lib -type f -name '*.so*' | while read lib; do
      patchelf --replace-needed libxml-security-c.so.20 libxml-security-c.so.30 "$lib"
    done
    wrapQtApp $out/app/bin/eidguiV2
    autoPatchelf $out/app
  '';

  meta = {
    description = "Middleware for Electronic Identification in Portugal (with precompiled binaries by AMA)";
    homepage = "https://www.autenticacao.gov.pt/";
    license = lib.licenses.eupl12;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ vaavaav ];
  };
}
