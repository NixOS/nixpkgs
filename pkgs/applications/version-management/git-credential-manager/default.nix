{ lib
, fetchFromGitHub
, buildDotnetModule
, dotnetCorePackages
, libX11
, libICE
, libSM
, fontconfig
, libsecret
, gnupg
, pass
, withGuiSupport ? true
, withLibsecretSupport ? true
, withGpgSupport ? true
}:

assert withLibsecretSupport -> withGuiSupport;
buildDotnetModule rec {
  pname = "git-credential-manager";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "git-ecosystem";
    repo = "git-credential-manager";
    rev = "v${version}";
    hash = "sha256-PeQ9atSCgSvduAcqY2CnNJH3ucvoInduA5i8dPUJiHo=";
  };

  projectFile = "src/shared/Git-Credential-Manager/Git-Credential-Manager.csproj";
  nugetDeps = ./deps.nix;
  dotnet-sdk = dotnetCorePackages.sdk_6_0;
  dotnet-runtime = dotnetCorePackages.runtime_6_0;
  dotnetInstallFlags = [ "--framework" "net6.0" ];
  executables = [ "git-credential-manager" ];

  runtimeDeps = [ fontconfig ]
    ++ lib.optionals withGuiSupport [ libX11 libICE libSM ]
    ++ lib.optional withLibsecretSupport libsecret;
  makeWrapperArgs = lib.optionals withGpgSupport [ "--prefix" "PATH" ":" (lib.makeBinPath [ gnupg pass ]) ];

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Secure, cross-platform Git credential storage with authentication to GitHub, Azure Repos, and other popular Git hosting services.";
    homepage = "https://github.com/git-ecosystem/git-credential-manager";
    license = with licenses; [ mit ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ _999eagle ];
  };
}
