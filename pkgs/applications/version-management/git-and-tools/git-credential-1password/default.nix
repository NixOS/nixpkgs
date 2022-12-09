{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "git-credential-1password";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "develerik";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Bz/EW+K4XtDap3cu3/+9nJePcdxMXakj8HDPsbCx1FU=";
  };

  vendorSha256 = "sha256-cPHA6rVUQg41sS79UBFf85OfLn53C8/OZVGT5xVdBdw=";

  meta = with lib; {
    description = "A git credential helper for 1Password";
    homepage = "https://github.com/develerik/git-credential-1password";
    changelog = "https://github.com/develerik/git-credential-1password/releases/tag/v${version}";
    license = licenses.isc;
    maintainers = [ maintainers.ivankovnatsky ];
  };
}
