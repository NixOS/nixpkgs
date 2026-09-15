{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  nix-update-script,
  sldl,
  testers,
}:

buildDotnetModule rec {
  pname = "sldl";
  version = "2.4.6";

  src = fetchFromGitHub {
    owner = "fiso64";
    repo = "slsk-batchdl";
    tag = "v${version}";
    hash = "sha256-js40wpNSCx77URFSpzJYEGgoioWitWjgr4gR4s7rX0E=";
  };

  postPatch = ''
    substituteInPlace \
      slsk-batchdl/slsk-batchdl.csproj \
      slsk-batchdl.Tests/slsk-batchdl.Tests.csproj \
      --replace-fail 'net6.0' 'net8.0'
  '';

  projectFile = "slsk-batchdl.sln";
  nugetDeps = ./deps.nix;

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  executables = [ "sldl" ];

  doCheck = true;
  disabledTests = [
    # Uses backslashes for paths, only works on Windows
    "Tests.ClientTests.MockSoulseekClientTests.BrowseAsync_ExistingUser_ReturnsCorrectFiles"
    "Tests.NameFormat.NameFormatTests.LongExample_Passes"
  ];

  passthru = {
    tests.version = testers.testVersion {
      package = sldl;
      version = "${version}.0";
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Automatic downloader for Soulseek built with Soulseek.NET";
    homepage = "https://github.com/fiso64/slsk-batchdl";
    changelog = "https://github.com/fiso64/slsk-batchdl/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "sldl";
  };
}
