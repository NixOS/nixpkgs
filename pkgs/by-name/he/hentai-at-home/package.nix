{
  lib,
  stdenvNoCC,
  fetchzip,
  jdk_headless,
  makeWrapper,
  buildPackages,
  javaOpts ? "-XX:+UseZGC",
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hentai-at-home";
  version = "1.6.4";

  src = fetchzip {
    url = "https://repo.e-hentai.org/hath/HentaiAtHome_${finalAttrs.version}_src.zip";
    hash = "sha512-dcHWZiU0ySLlEhZeK1n2T/dyO6Wk9eS7CpZRSfzY3KvHrPBthQnaFrarSopPXJan1+zWROu1pEff1WSr5+HO4Q==";
    stripRoot = false;
  };

  nativeBuildInputs = [
    jdk_headless
    makeWrapper
  ];

  LANG = "en_US.UTF-8";
  LOCALE_ARCHIVE = lib.optionalString (
    stdenvNoCC.buildPlatform.libc == "glibc"
  ) "${buildPackages.glibcLocales}/lib/locale/locale-archive";

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

  meta = with lib; {
    homepage = "https://ehwiki.org/wiki/Hentai@Home";
    description = "Open-source P2P gallery distribution system which reduces the load on the E-Hentai Galleries";
    license = licenses.gpl3;
    maintainers = with maintainers; [ terrorjack ];
    mainProgram = "HentaiAtHome";
    platforms = jdk_headless.meta.platforms;
  };
})
