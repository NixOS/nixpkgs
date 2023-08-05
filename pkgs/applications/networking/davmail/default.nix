{ stdenv
, fetchurl
, lib
, makeWrapper
, unzip
, glib
, gtk2
, gtk3
, jre
, libXtst
, zulu
, preferGtk3 ? true
, preferZulu ? true
}:

let
  rev = 3423;
  jre' = if preferZulu then zulu else jre;
  gtk' = if preferGtk3 then gtk3 else gtk2;

  inherit (lib) makeLibraryPath versions;

in
stdenv.mkDerivation rec {
  pname = "davmail";
  version = "6.1.0";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${version}/${pname}-${version}-${toString rev}.zip";
    sha256 = "sha256-/JsJFtGalNuOz21eeCPR/LvLueMtQAR7VSKN8SpnPvA=";
  };

  postPatch = ''
    sed -i -e '/^JAVA_OPTS/d' davmail
  '';

  sourceRoot = ".";

  nativeBuildInputs = [ makeWrapper unzip ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/davmail
    cp -vR ./* $out/share/davmail
    makeWrapper $out/share/davmail/davmail $out/bin/davmail \
      --set-default JAVA_OPTS "-Xmx512M -Dsun.net.inetaddr.ttl=60 -Djdk.gtk.version=${lib.versions.major gtk'.version}" \
      --prefix PATH : ${jre'}/bin \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ glib gtk' libXtst ]}

    runHook postInstall
  '';

  meta = with lib; {
    description = "A Java application which presents a Microsoft Exchange server as local CALDAV, IMAP and SMTP servers";
    homepage = "https://davmail.sourceforge.net/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.all;
    mainProgram = "davmail";
  };
}
