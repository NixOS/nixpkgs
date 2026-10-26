{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  jre,
  unzip,
  coreutils,
  gnused,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "spotbugs";
  version = "4.10.5";

  src = fetchurl {
    url = "https://github.com/spotbugs/spotbugs/releases/download/${finalAttrs.version}/spotbugs-${finalAttrs.version}.zip";
    hash = "sha256-+Ouc9KyOGymz4pVnVB7vPzCzv0n/OIBnCnljCSzYqFk=";
  };

  strictDeps = true;
  __structuredAttrs = true;
  nativeBuildInputs = [
    makeWrapper
    unzip
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec/spotbugs/bin $out/bin
    cp -r lib plugin $out/libexec/spotbugs/
    cp bin/spotbugs $out/libexec/spotbugs/bin/
    install -Dm644 LICENSE*.txt -t $out/share/licenses/spotbugs
    makeWrapper $out/libexec/spotbugs/bin/spotbugs $out/bin/spotbugs \
      --set-default JAVA_HOME ${jre} \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gnused
          jre
        ]
      }

    runHook postInstall
  '';

  meta = {
    description = "Static analysis tool for finding bugs in Java programs";
    homepage = "https://spotbugs.github.io/";
    changelog = "https://github.com/spotbugs/spotbugs/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.lgpl21Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [ nyxar77 ];
    platforms = lib.platforms.unix;
    mainProgram = "spotbugs";
  };
})
