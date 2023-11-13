{ lib
, fetchFromGitHub
, buildDotnetModule
, dotnetCorePackages
, libX11
, libICE
, libSM
, fontconfig
, libsecret
, git
, git-credential-manager
, gnupg
, pass
, testers
, withGuiSupport ? true
, withLibsecretSupport ? true
, withGpgSupport ? true
}:

assert withLibsecretSupport -> withGuiSupport;
buildDotnetModule rec {
  pname = "git-credential-manager";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "git-ecosystem";
    repo = "git-credential-manager";
    rev = "v${version}";
    hash = "sha256-vfv6dCmTuDsh6MaD2HAKlxZtQGVE0B5HJZPnoAUwUnM=";
  };

  projectFile = "src/shared/Git-Credential-Manager/Git-Credential-Manager.csproj";
  nugetDeps = ./deps.nix;
  dotnet-sdk = dotnetCorePackages.sdk_7_0;
  dotnet-runtime = dotnetCorePackages.runtime_7_0;
  dotnetInstallFlags = [ "--framework" "net7.0" ];
  executables = [ "git-credential-manager" ];

  runtimeDeps = [ fontconfig ]
    ++ lib.optionals withGuiSupport [ libX11 libICE libSM ]
    ++ lib.optional withLibsecretSupport libsecret;
  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath ([ git ] ++ lib.optionals withGpgSupport [ gnupg pass ])}"
  ];

  passthru = {
    updateScript = ./update.sh;
    tests.version = testers.testVersion {
      package = git-credential-manager;
    };
  };

  meta = with lib; {
    description = "A secure, cross-platform Git credential storage with authentication to GitHub, Azure Repos, and other popular Git hosting services";
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
  };
}
