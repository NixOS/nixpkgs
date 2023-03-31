{ lib
, stdenv
, buildDotnetModule
, fetchFromGitHub
,
}:
buildDotnetModule rec {
  pname = "git-credential-manager";
  version = "2.0.935";

  src = fetchFromGitHub {
    owner = "git-ecosystem";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lnki00WzcAm5GuX79J143bOOeJsrB7gMB/IdCh9G11o=";
  };

  dotnetInstallFlags = [ "--framework net6.0" ];

  executables = [ "git-credential-manager" ];

  nugetDeps = ./deps.nix;

  meta = with lib; {
    description = "Secure, cross-platform Git credential storage";
    longDescription = ''
      Git Credential Manager (GCM) is a secure Git credential helper built on .NET that runs on Windows, macOS, and Linux.
      It aims to provide a consistent and secure authentication experience, including multi-factor auth, to every major source control hosting service and platform.

      GCM supports (in alphabetical order) Azure DevOps, Azure DevOps Server (formerly Team Foundation Server), Bitbucket, GitHub, and GitLab. Compare to Git's built-in credential helpers (Windows: wincred, macOS: osxkeychain, Linux: gnome-keyring/libsecret), which provide single-factor authentication support for username/password only.

      GCM replaces both the .NET Framework-based Git Credential Manager for Windows and the Java-based Git Credential Manager for Mac and Linux.
    '';
    homepage = "https://github.com/git-ecosystem/git-credential-manager";
    changelog = "https://github.com/git-ecosystem/git-credential-manager/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ examosa ];
    platforms = with platforms; linux ++ darwin ++ windows;
  };
}
