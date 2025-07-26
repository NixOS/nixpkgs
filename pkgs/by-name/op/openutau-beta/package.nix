{
  buildDotnetModule,
  dbus,
  dotnetCorePackages,
  fetchFromGitHub,
  fontconfig,
  lib,
  portaudio,
  stdenv,
}:

buildDotnetModule rec {
  pname = "OpenUtau";
  version = "0.1.550";

  src = fetchFromGitHub {
    owner = "stakira";
    repo = "OpenUtau";
    tag = version;
    hash = "sha256-K/gwyufPNj8qZbXD7yHrWfbsrzqvRbmnJoVGyuFA1sw=";
  };

  dotnet_sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  dotnetInstallFlags = [ "-p:PublishReadyToRun=false" ];

  executables = [ "OpenUtau" ];
  nugetDeps = ./deps.json;
  projectFile = "OpenUtau.sln";

  doCheck = !stdenv.hostPlatform.isDarwin;
  runtimeDeps = [
    dbus
    portaudio
  ];

  passthru.updateScript = ./update.sh;
  postPatch = ''
    substituteInPlace OpenUtau/Program.cs --replace-fail \
      'fc-match' \
      '${lib.getExe' fontconfig "fc-match"}'
  '';

  postInstall =
    let
      runtime =
        if (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64) then
          "linux-x64"
        else if (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) then
          "linux-arm64"
        else if (stdenv.hostPlatform.isDarwin) then
          "osx"
        else
          null;
    in
    lib.optionalString (runtime != null) ''
      cp runtimes/${runtime}/native/libworldline${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/OpenUtau/
    '';

  meta = {
    homepage = "https://github.com/stakira/OpenUtau";
    description = "Open singing synthesis platform / Open source UTAU successor.";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
      binaryNativeCode
    ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dmkhitaryan ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "OpenUtau";
  };

}
