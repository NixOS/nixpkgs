{
  lib,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  libsecret,
  git,
  git-credential-manager,
  gnupg,
  pass,
  testers,
  withLibsecretSupport ? true,
  withGpgSupport ? true,
}:

buildDotnetModule rec {
  pname = "git-credential-manager";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "git-ecosystem";
    repo = "git-credential-manager";
    rev = "v${version}";
    hash = "sha256-fzcGAcKOAEnBiAEYYyxKJ71xnixb5cz7FzR28/cKIFg=";
  };

  projectFile = "src/shared/Git-Credential-Manager/Git-Credential-Manager.csproj";
  nugetDeps = ./deps.json;
  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  dotnetInstallFlags = [
    "--framework"
    "net8.0"
  ];
  executables = [ "git-credential-manager" ];

  runtimeDeps = lib.optional withLibsecretSupport libsecret;
  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath (
        [ git ]
        ++ lib.optionals withGpgSupport [
          gnupg
          pass
        ]
      )
    }"
    "--inherit-argv0"
  ];

  passthru = {
    updateScript = ./update.sh;
    tests.version = testers.testVersion {
      package = git-credential-manager;
    };
  };

  meta = with lib; {
    description = "Secure, cross-platform Git credential storage with authentication to GitHub, Azure Repos, and other popular Git hosting services";
    homepage = "https://github.com/git-ecosystem/git-credential-manager";
    license = with licenses; [ mit ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ _999eagle ];
    longDescription = ''
      git-credential-manager is a secure, cross-platform Git credential storage with authentication to GitHub, Azure Repos, and other popular Git hosting services.

      > requires sandbox to be disabled on MacOS, so that
      .NET can find `/usr/bin/codesign` to sign the compiled binary.
      This problem is common to all .NET packages on MacOS with Nix.
    '';
    mainProgram = "git-credential-manager";
  };
}
