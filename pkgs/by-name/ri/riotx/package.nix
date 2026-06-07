{
  coreutils,
  fetchzip,
  findutils,
  gnused,
  installShellFiles,
  jre_headless,
  lib,
  makeWrapper,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "riotx";
  version = "1.14.1";

  src = fetchzip {
    url = "https://github.com/redis/riotx-dist/releases/download/v${finalAttrs.version}/riotx-${finalAttrs.version}.zip";
    hash = "sha256-Lj1zmtUtFt4khfiYnIrcJngVHa23OxBKzfOoxzJ9weo=";
  };

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  buildInputs = [ jre_headless ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp bin/riotx $out/bin
    cp -r lib $out

    wrapProgram $out/bin/riotx \
      --set JAVA_HOME "${jre_headless}" \
      --set PATH ${
        lib.makeBinPath [
          coreutils
          findutils
          gnused
        ]
      }

    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd riotx \
        --bash <($out/bin/riotx generate-completion bash) \
        --zsh <($out/bin/riotx generate-completion zsh)
  '';

  __structuredAttrs = true;
  strictDeps = true;

  meta = {
    changelog = "https://github.com/redis/riotx-dist/releases/tag/v${finalAttrs.version}";
    description = "Data integration tool for Redis Cloud and Redis Software";
    homepage = "https://redis.github.io/riotx";
    license = lib.licenses.unfree;
    mainProgram = "riotx";
    platforms = lib.platforms.unix;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    teams = [ lib.teams.redis ];
  };
})
