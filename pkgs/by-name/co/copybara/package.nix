{
  lib,
  stdenv,
  fetchurl,
  jdk21,
  makeWrapper,
  git,
  gnused,
  gnugrep,
  gawk,
  which,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "copybara";
  version = "20251117";

  src = fetchurl {
    url = "https://github.com/google/copybara/releases/download/v${finalAttrs.version}/copybara_deploy.jar";
    hash = "sha256-QbmBrkkqLtB/5ZS9o+Z4KKbogFv5lccEGgLZsuVuPrg=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    jdk21
  ];

  runtimeDeps = [
    git
    gnused
    gnugrep
    gawk
    which
  ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/java
    cp $src $out/share/java/copybara.jar

    mkdir -p $out/bin
    makeWrapper ${jdk21}/bin/java $out/bin/copybara \
      --add-flags "-jar $out/share/java/copybara.jar" \
      --prefix PATH : ${lib.makeBinPath finalAttrs.runtimeDeps}

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for transforming and moving code between repositories";
    longDescription = ''
      Copybara is a tool used internally at Google for transforming and moving
      code between repositories. It allows you to maintain code in multiple
      repositories while keeping them in sync through transformations.

      Common use cases include:
      - Importing sections of code from a confidential repository to a public repository
      - Importing code from a public repository to a confidential repository
      - Moving changes between authoritative and non-authoritative repositories
    '';
    homepage = "https://github.com/google/copybara";
    changelog = "https://github.com/google/copybara/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ cameroncuttingedge ];
    platforms = lib.platforms.all;
    mainProgram = "copybara";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
})
