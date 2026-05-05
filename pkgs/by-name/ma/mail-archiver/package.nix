{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  _experimental-update-script-combinators,
  nix-update-script,
}:

buildDotnetModule (finalAttrs: {
  pname = "mail-archiver";
  version = "2604.1";

  src = fetchFromGitHub {
    owner = "s1t5";
    repo = "mail-archiver";
    tag = finalAttrs.version;
    hash = "sha256-zMUY1Wka0fyZWkAZQawnRlQ7lJ9ezIzpmcfQOtmKuig=";
  };

  projectFile = "MailArchiver.csproj";
  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_10_0_1xx;
  dotnet-runtime = dotnetCorePackages.aspnetcore_10_0;

  executables = [ "MailArchiver" ];

  # Update source and then update dependencies
  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (nix-update-script { })
    finalAttrs.passthru.fetch-deps
  ];

  meta = {
    changelog = "https://github.com/s1t5/mail-archiver/releases/tag/${finalAttrs.version}";
    description = "Web application for archiving, searching, and exporting emails from multiple accounts";
    homepage = "https://github.com/s1t5/mail-archiver";
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "MailArchiver";
    platforms = lib.platforms.linux;
  };
})
