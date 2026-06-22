{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
}:

buildDotnetModule rec {
  pname = "ciderpress2";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "fadden";
    repo = "CiderPress2";
    tag = "v${version}";
    hash = "sha256-nzCuKCntqYVhjSHljPkY5ziAjYH/qGUqukRPrHzhOzo=";
  };

  projectFile = [ "cp2/cp2.csproj" ];

  executables = [ "cp2" ];

  patches = [ ./retarget-net8.patch ];

  preBuild = ''
    # Disable MS telemetry
    export DOTNET_CLI_TELEMETRY_OPTOUT=1
    export DOTNET_NOLOGO=1
  '';

  meta = {
    description = "File archive utility for Apple II disk images and file archives";
    longDescription = ''
      CiderPress 2 is a file archive utility for Apple II disk images and file
      archives. It can extract files from disk images and file archives, and
      create new archives.
    '';
    homepage = "https://github.com/fadden/CiderPress2";
    changelog = "https://github.com/fadden/CiderPress2/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nulleric ];
    platforms = lib.platforms.unix;
    mainProgram = "cp2";
  };
}
