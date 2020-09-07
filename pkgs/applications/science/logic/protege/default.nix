{ lib
, stdenv
, fetchzip
, jre8
, makeWrapper
, makeDesktopItem
, desktop-file-utils
, iconConvTools
}:

stdenv.mkDerivation rec {
  pname = "protege";
  version = "5.5.0";

  src = fetchzip {
    url = "https://github.com/protegeproject/protege-distribution/releases/download/v${version}/Protege-${version}-platform-independent.zip";
    sha256 = "1v82ph1pqvnc1qynhiapzw0jwm9rphsb580lc96zwsvhrr0wd690";
  };

  nativeBuildInputs = [ makeWrapper desktop-file-utils iconConvTools ];

  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    desktopName = "Protege";
    genericName = meta.description;
    comment = meta.description;
    categories = "Development;";
    icon = pname;
    extraEntries = ''
      StartupWMClass=${pname}
    '';
  };

  # we need to patch the run.sh located in the extracted sources, note the deliberate whitespace!
  installPhase = ''
    runHook preInstall

    mkdir -p $out/src
    mv * $out/src

    substituteInPlace $out/src/run.sh \
      --replace 'java ' "${jre8}/bin/java "
    mkdir -p $out/bin
    makeWrapper $out/src/run.sh $out/bin/${pname}

    mkdir -p $out/share
    ${desktopItem.buildCommand}
    icoFileToHiColorTheme $out/src/app/Protege.ico $pname $out

    runHook postInstall
  '';

  meta = {
    description = "Ontology editor and framework for building intelligent systems";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    homepage = "https://protege.stanford.edu";
    downloadPage = "https://github.com/protegeproject/protege-distribution/releases";
    changelog = "https://github.com/protegeproject/protege-distribution/releases/tag/v${version}";
  };
}
