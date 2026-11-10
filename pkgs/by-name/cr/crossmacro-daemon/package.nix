{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  nix-update-script,
  autoPatchelfHook,
  clang,
  systemdLibs,
  zlib,
}:

buildDotnetModule rec {
  pname = "crossmacro-daemon";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "alper-han";
    repo = "CrossMacro";
    tag = "v${version}";
    hash = "sha256-JV3Fa7LVhts6TXOWL+0vnKxH1FbMSm/AELUgYUgVLco=";
  };

  projectFile = "src/CrossMacro.Daemon/CrossMacro.Daemon.csproj";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = null;

  # The upstream profile publishes a self-contained Native AOT binary without
  # a .NET apphost; keep the builder settings aligned with that contract.
  selfContainedBuild = true;
  useAppHost = false;
  executables = [ "CrossMacro.Daemon" ];
  buildType = "Release";

  nativeBuildInputs = [
    autoPatchelfHook
    clang
  ];

  buildInputs = [
    systemdLibs
    zlib
  ];
  runtimeDependencies = [ systemdLibs ];

  dotnetFlags = [
    "-p:CrossMacroPublishProfile=native-aot"
    "-p:Version=${version}"
  ];

  postInstall = ''
    install -Dm644 scripts/assets/io.github.alper_han.crossmacro.policy \
      $out/share/polkit-1/actions/io.github.alper_han.crossmacro.policy

    install -Dm644 scripts/assets/50-crossmacro.rules \
      $out/share/polkit-1/rules.d/50-crossmacro.rules
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Privileged input daemon for CrossMacro";
    homepage = "https://github.com/alper-han/CrossMacro";
    changelog = "https://github.com/alper-han/CrossMacro/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "CrossMacro.Daemon";
    maintainers = with lib.maintainers; [ alper-han ];
  };
}
