{ buildDotnetModule
, copyDesktopItems
, desktop-file-utils
, dotnetCorePackages
, fetchFromGitHub
, fontconfig
, lib
, libICE
, libSM
, libX11
, nexus-mods-app
, runCommand
}:
buildDotnetModule rec {
  pname = "nexus-mods-app";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "Nexus-Mods";
    repo = "NexusMods.App";
    rev = "v${version}";
    hash = "sha256-BuZl4uW/J1pEf9K1GlPbynf6A3ij8S9ffdgZu4YfvSA=";
  };

  projectFile = "src/NexusMods.App/NexusMods.App.csproj";

  nativeBuildInputs = [
    copyDesktopItems
  ];

  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  makeWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ desktop-file-utils ]}" ];

  runtimeDeps = [
    fontconfig
    libICE
    libSM
    libX11
  ];

  doCheck = true;

  passthru = {
    tests = {
      serve = runCommand "${pname}-test-serve" { } ''
        ${nexus-mods-app}/bin/${meta.mainProgram}
        touch $out
      '';
      help = runCommand "${pname}-test-help" { } ''
        ${nexus-mods-app}/bin/${meta.mainProgram} --help
        touch $out
      '';
      associate-nxm = runCommand "${pname}-test-associate-nxm" { } ''
        ${nexus-mods-app}/bin/${meta.mainProgram} associate-nxm
        touch $out
      '';
      list-tools = runCommand "${pname}-test-list-tools" { } ''
        ${nexus-mods-app}/bin/${meta.mainProgram} list-tools
        touch $out
      '';
    };
    updateScript = ./update.sh;
  };

  meta = with lib; {
    description = "Game mod installer, creator and manager";
    mainProgram = "NexusMods.App";
    homepage = "https://github.com/Nexus-Mods/NexusMods.App";
    changelog = "https://github.com/Nexus-Mods/NexusMods.App/releases/tag/${src.rev}";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ l0b0 ];
    platforms = platforms.linux;
  };
}
