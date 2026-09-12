{
  lib,
  stdenv,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  nix-update-script,
  autoPatchelfHook,
  clang,
  patchelf,
  systemd,
  zlib,
}:

buildDotnetModule rec {
  pname = "crossmacro-daemon";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "alper-han";
    repo = "CrossMacro";
    tag = "v${version}";
    hash = "sha256-n+V5kQ7MtslLu6rHQS8q48CT247akiPLfMQP8+3/TW4=";
  };

  projectFile = "src/CrossMacro.Daemon/CrossMacro.Daemon.csproj";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = null;

  selfContainedBuild = true;
  executables = [ "CrossMacro.Daemon" ];
  buildType = "Release";

  nativeBuildInputs = [
    autoPatchelfHook
    clang
    patchelf
  ];

  buildInputs = [
    systemd
    zlib
  ];

  dotnetFlags = [
    "-p:PublishAot=true"
    "-p:PublishReadyToRun=false"
    "-p:OptimizationPreference=Speed"
    "-p:StripSymbols=true"
    "-p:IlcTrimMetadata=true"
    "-p:DebugType=None"
    "-p:DebugSymbols=false"
    "-p:Version=${version}"
  ];

  postInstall = ''
    install -Dm644 scripts/assets/io.github.alper_han.crossmacro.policy \
      $out/share/polkit-1/actions/io.github.alper_han.crossmacro.policy

    install -Dm644 scripts/assets/50-crossmacro.rules \
      $out/share/polkit-1/rules.d/50-crossmacro.rules
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-needed libsystemd.so.0 $out/lib/crossmacro-daemon/CrossMacro.Daemon
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Privileged input daemon for CrossMacro";
    homepage = "https://github.com/alper-han/CrossMacro";
    changelog = "https://github.com/alper-han/CrossMacro/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "CrossMacro.Daemon";
    maintainers = with lib.maintainers; [ alper-han ];
  };
}
