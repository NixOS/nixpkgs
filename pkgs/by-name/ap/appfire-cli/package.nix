{
  lib,
  stdenv,
  fetchzip,
  makeBinaryWrapper,
  coreutils,
  findutils,
  jre,

  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "appfire-cli";
  version = "12.1.0";

  src = fetchzip {
    url = "https://appfire.atlassian.net/wiki/download/attachments/60562669/acli-${finalAttrs.version}-distribution.zip";
    hash = "sha256-6p8i5ec8IAygACdsdzP8g5u24mQZ7Ci684xuu/kAADo=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{,doc/}appfire-cli
    cp -r acli.sh lib $out/share/appfire-cli
    cp -r README.txt license $out/share/doc/appfire-cli

    ACLI_SHELL=${finalAttrs.passthru.shellNames.${stdenv.hostPlatform.system} or "unsupport"}
    if test -f $ACLI_SHELL; then
      install -Dm755 $ACLI_SHELL $out/share/appfire-cli/$ACLI_SHELL
    fi

    substituteInPlace $out/share/appfire-cli/acli.sh \
      --replace-fail 'java $' '${lib.getExe jre} $' \
      --replace-fail '(find' '(${lib.getExe findutils}' \
      --replace-fail dirname ${lib.getExe' coreutils "dirname"} \
      --replace-fail uname ${lib.getExe' coreutils "uname"}
    makeBinaryWrapper $out/share/appfire-cli/acli.sh $out/bin/acli

    runHook postInstall
  '';

  passthru = {
    shellNames = {
      "x86_64-linux" = "bin/shell-linux-amd64";
      "aarch64-linux" = "bin/shell-linux-arm64";
      "x86_64-darwin" = "bin/shell-macos-amd64";
      "aarch64-darwin" = "bin/shell-macos-arm64";
    };
    # versionCheckHook cannot be used because appfire-cli requires $HOME to be set
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "acli -a getClientInfo";
    };
  };

  meta = {
    description = "Integrated family of CLIs for Atlassian, Atlassian-related, and other applications";
    longDescription = ''
      Appfire CLI (ACLI) is an integrated family of CLIs for Atlassian,
      Atlassian-related, and other applications.

      ACLI provides a consistent and reliable automation platform that allows
      users, administrators, script writers, and DevOps developers to perform
      tasks, implement business processes, or apply general automation with
      Atlassian products.

      The CLIs are built on the Atlassian remote APIs and deliver a higher
      level, client-based API that is easier to use and more powerful than
      the underlying product APIs.

      The upstream documentation describes configuring acli by placing
      {file}`acli.properties` in the same directory as {file}`acli.sh`.
      Since the /nix/store is not writable, you can instead place the file
      at {file}`$HOME/acli.properties` to achieve the same effect.
    '';
    homepage = "https://apps.appf.re/acli";
    license = lib.licenses.unfreeRedistributable;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    maintainers = with lib.maintainers; [ twey ];
    mainProgram = "acli";
    inherit (jre.meta) platforms;
  };
})
