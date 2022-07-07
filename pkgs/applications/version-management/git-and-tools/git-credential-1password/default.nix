{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "git-credential-1password";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "develerik";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-WMEUa0mSxmeFXQBejwxtlhWuuLKguugavRaBUVpYA3g=";
  };

  vendorSha256 = "sha256-eUjaSpmQpSOvSBW+7ajXiEDepkyvHsIiEY0RGpfnao0=";

  meta = with lib; {
    description = "A git credential helper for 1Password";
    homepage = "https://github.com/develerik/git-credential-1password";
    changelog = "https://github.com/develerik/git-credential-1password/releases/tag/v${version}";
    license = licenses.isc;
    maintainers = [ maintainers.ivankovnatsky ];
  };
}
