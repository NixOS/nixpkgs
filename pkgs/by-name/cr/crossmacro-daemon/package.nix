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
  version = "0.9.7";

  src = fetchFromGitHub {
    owner = "alper-han";
    repo = "CrossMacro";
    tag = "v${version}";
    hash = "sha256-qVKlch9GxEfB9thqXdiwWgF25ljX+b5on+bZmcAjAzw=";
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

  dotnetFlags = [ "-p:Version=${version}" ];

  postInstall = ''
    install -Dm644 scripts/assets/org.crossmacro.policy \
      $out/share/polkit-1/actions/org.crossmacro.policy

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
