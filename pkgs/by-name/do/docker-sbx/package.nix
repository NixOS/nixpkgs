{
  lib,
  fetchurl,
  stdenvNoCC,
  installShellFiles,
  autoPatchelfHook,
  makeWrapper,
  gccForLibs,
  e2fsprogs,
  lz4,
  xxhash,
  zlib,
  zstd,
  versionCheckHook,
}:
let
  hashes = {
    "x86_64-linux" = "sha256-LsRbx5OMIML0Bv6MxyKUrVqVS9wEdgFIS4m/GhCDEdQ=";
    "aarch64-linux" = "sha256-OcRwpfXgmRscI1iVLiqzKnsDCb+lesYra7xktGbQLBc=";
    "aarch64-darwin" = "sha256-0S+gau7OKY2W2uBYEB8lZTd3CgDvRuZYR2Lg8nsGpaM=";
  };
  platformName = {
    "x86_64-linux" = "linux-amd64";
    "aarch64-linux" = "linux-arm64";
    "aarch64-darwin" = "darwin";
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "docker-sbx";
  version = "0.39.0";
  src =
    let
      throwPlat = throw "Unsupported platform ${stdenvNoCC.hostPlatform.system}";
      p = platformName.${stdenvNoCC.hostPlatform.system} or throwPlat;
    in
    fetchurl {
      url = "https://github.com/docker/sbx-releases/releases/download/v${finalAttrs.version}/DockerSandboxes-${p}.tar.gz";
      hash = hashes.${stdenvNoCC.hostPlatform.system} or throwPlat;
    };

  strictDeps = true;
  __structuredAttrs = true;

  sourceRoot = if stdenvNoCC.hostPlatform.isDarwin then "." else null;

  nativeBuildInputs = [
    installShellFiles
    versionCheckHook
  ]
  ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [
    autoPatchelfHook
    makeWrapper
    e2fsprogs
  ];

  buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    lz4
    zlib
    zstd
    xxhash
    gccForLibs
  ];

  dontBuild = true;
  doInstallCheck = true;
  versionCheckProgramArg = "version";
  versionCheckKeepEnvironment = [ "HOME" ];
  preVersionCheck = ''
    export HOME=$TMPDIR
  '';

  installPhase =
    if stdenvNoCC.hostPlatform.isLinux then
      ''
        runHook preInstall

        PREFIX=$out bash ./install.sh

        wrapProgram $out/bin/sbx \
          --prefix PATH : ${lib.makeBinPath [ e2fsprogs ]}

        ${lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
          export HOME=$TMPDIR
          $out/bin/sbx completion bash > sbx.bash
          $out/bin/sbx completion fish > sbx.fish
          $out/bin/sbx completion zsh  > sbx.zsh
          installShellCompletion sbx.{bash,fish,zsh}
        ''}

        runHook postInstall
      ''
    else
      ''
        runHook preInstall

        mkdir -pv $out
        cp -rv bin libexec $out

        installShellCompletion \
          --bash --name sbx.bash completions/bash/sbx \
          --zsh  --name _sbx     completions/zsh/_sbx \
          --fish --name sbx.fish completions/fish/sbx.fish

        runHook postInstall
      '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Safe environments for agents";
    longDescription = ''
      Docker Sandboxes provides sandboxes with controlled access to your
      filesystem, network, and tools. This means your agents can work
      autonomously without putting your machine or data at risk.
    '';
    homepage = "https://docs.docker.com/reference/cli/sbx/";
    changelog = "https://github.com/docker/sbx-releases/releases/tag/v${finalAttrs.version}";
    mainProgram = "sbx";
    platforms = builtins.attrNames hashes;
    license = lib.licenses.unfree;
    maintainers = [
      lib.maintainers.skyesoss
      lib.maintainers.erics118
    ];
  };
})
