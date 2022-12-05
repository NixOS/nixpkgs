{ buildPackages
, buildPlatform
, fetchzip
, javaOpts ? "-XX:+UseZGC"
, jdk
, jre_headless
, lib
, makeWrapper
, stdenvNoCC
,
}:
stdenvNoCC.mkDerivation rec {
  pname = "HentaiAtHome";
  version = "1.6.1";

  src = fetchzip {
    url = "https://repo.e-hentai.org/hath/HentaiAtHome_${version}_src.zip";
    hash =
      "sha512-j+B0kx6fjUibI3MjVJ5PVTq9xxtSOTTY/XizAJKjeNkpExJF9DIV4VCwf+sfLlg+7W4UBosnyb8hZNNoidRBKA==";
    stripRoot = false;
  };

  nativeBuildInputs = [ jdk makeWrapper ];

  LANG = "en_US.UTF-8";
  LOCALE_ARCHIVE = lib.optionalString (buildPlatform.libc == "glibc")
    "${buildPackages.glibcLocales}/lib/locale/locale-archive";

  buildPhase = ''
    make all
  '';

  installPhase = ''
    mkdir -p $out/share/java
    cp build/HentaiAtHome.jar $out/share/java

    mkdir -p $out/bin
    makeWrapper ${jre_headless}/bin/java $out/bin/HentaiAtHome \
      --add-flags "${javaOpts} -jar $out/share/java/HentaiAtHome.jar"
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    pushd $(mktemp -d)
    $out/bin/HentaiAtHome
    popd
  '';

  strictDeps = true;

  meta = with lib; {
    homepage = "https://ehwiki.org/wiki/Hentai@Home";
    description =
      "Hentai@Home is an open-source P2P gallery distribution system which reduces the load on the E-Hentai Galleries";
    license = licenses.gpl3;
    maintainers = with maintainers; [ terrorjack ];
  };
}
