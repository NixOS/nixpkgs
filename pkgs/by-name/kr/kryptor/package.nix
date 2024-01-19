{ lib
, buildDotnetModule
, fetchFromGitHub
, libsodium
}:

buildDotnetModule rec {
  pname = "kryptor";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "samuel-lucas6";
    repo = "Kryptor";
    rev = "v${version}";
    hash = "sha256-BxUmDzmfvRelQDHb5uLcQ2YPL7ClxZNFGm/gQoDK8t8=";
  };

  projectFile = "src/Kryptor.sln";
  nugetDeps = ./deps.nix;

  selfContainedBuild = true;

  dotnetFlags = ["-p:PublishSingleFile=true" "-p:PublishTrimmed=true" "-p:PublishReadyToRun=true" "-p:IncludeNativeLibrariesForSelfExtract=true"];

  executables = ["kryptor"];

  runtimeDeps = [libsodium];

  meta = with lib; {
    description = "A simple, modern, and secure encryption and signing tool that aims to be a better version of age and Minisign";
    homepage = "https://github.com/samuel-lucas6/Kryptor";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ arthsmn ];
    mainProgram = "kryptor";
    platforms = platforms.all;
  };
}
