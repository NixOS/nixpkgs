{
  lib,
  stdenvNoCC,
  fetchzip,
  jdk,
  makeWrapper,
  buildPackages,
  jre_headless,
  javaOpts ? "-XX:+UseZGC",
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hentai-at-home";
  version = "1.6.3";

  src = fetchzip {
    url = "https://repo.e-hentai.org/hath/HentaiAtHome_${finalAttrs.version}_src.zip";
    hash = "sha512-kBB5mn9MwpkZ0z+Fl5ABs4YWBkXkMRcADYSAPkeifyhbYQQPOnijXKYZCkzE4UB3uQ1j6Kj6WnpO/4jquYEiOQ==";
    stripRoot = false;
  };

  nativeBuildInputs = [
    jdk
    makeWrapper
  ];

  LANG = "en_US.UTF-8";
  LOCALE_ARCHIVE = lib.optionalString (
    stdenvNoCC.buildPlatform.libc == "glibc"
  ) "${buildPackages.glibcLocales}/lib/locale/locale-archive";

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
    description = "Open-source P2P gallery distribution system which reduces the load on the E-Hentai Galleries";
    license = licenses.gpl3;
    maintainers = with maintainers; [ terrorjack ];
    mainProgram = "HentaiAtHome";
    platforms = jdk.meta.platforms;
  };
})
