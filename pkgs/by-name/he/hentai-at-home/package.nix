{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  jdk_headless,
  makeWrapper,
  buildPackages,
  javaOpts ? "-XX:+UseZGC",
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hentai-at-home";
  version = "1.6.6";

  src = fetchurl {
    url = "https://upld.e-hentai.org/hath/HentaiAtHome_${finalAttrs.version}_src.zip";
    # sha256 from upstream: https://e-hentai.org/hentaiathome.php
    hash = "sha256-WyfjAC4d6OHTaKKU0koLac89wcvJchxlySt1DmUoGoc=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    unzip
    jdk_headless
    makeWrapper
  ];

  env = {
    LANG = "en_US.UTF-8";
  }
  // lib.optionalAttrs (stdenvNoCC.buildPlatform.libc == "glibc") {
    LOCALE_ARCHIVE = "${buildPackages.glibcLocales}/lib/locale/locale-archive";
  };

  makeFlags = [ "all" ];
  enableParallelBuilding = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java
    cp build/HentaiAtHome.jar $out/share/java

    mkdir -p $out/bin
    makeWrapper ${jdk_headless}/bin/java $out/bin/HentaiAtHome \
      --add-flags "${javaOpts} -jar $out/share/java/HentaiAtHome.jar"

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    pushd $(mktemp -d)
    $out/bin/HentaiAtHome
    popd

    runHook postInstallCheck
  '';

  strictDeps = true;

  meta = {
    homepage = "https://ehwiki.org/wiki/Hentai@Home";
    description = "Open-source P2P gallery distribution system which reduces the load on the E-Hentai Galleries";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ terrorjack ];
    mainProgram = "HentaiAtHome";
    platforms = jdk_headless.meta.platforms;
  };
})
