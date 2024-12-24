{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
  versionCheckHook,
}:

buildDotnetModule rec {
  pname = "kryptor";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "samuel-lucas6";
    repo = "Kryptor";
    tag = "v${version}";
    hash = "sha256-BxUmDzmfvRelQDHb5uLcQ2YPL7ClxZNFGm/gQoDK8t8=";
  };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  projectFile = "src/Kryptor.sln";
  nugetDeps = ./deps.json;

  executables = [ "kryptor" ];

  dotnetFlags = [ "-p:TargetFramework=net8.0" ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    updateScript = ./update.sh;
  };

  meta = {
    changelog = "https://github.com/samuel-lucas6/Kryptor/releases/tag/v${version}";
    description = "Simple, modern, and secure encryption and signing tool that aims to be a better version of age and Minisign";
    homepage = "https://github.com/samuel-lucas6/Kryptor";
    license = lib.licenses.gpl3Only;
    mainProgram = "kryptor";
    maintainers = with lib.maintainers; [
      arthsmn
      gepbird
    ];
    platforms = lib.platforms.all;
  };
}
