{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "git-credential-1password";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "develerik";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8qdUOJ0MOk/xVvp3kDuxNRo3lMEJhLeI3Fle0tuZez0=";
  };

  vendorHash = "sha256-B6BlVnUX4XLT+9EpL63Ht4S8Wo84RsmY99CL+srQfpw=";

  meta = with lib; {
    description = "A git credential helper for 1Password";
    homepage = "https://github.com/develerik/git-credential-1password";
    changelog = "https://github.com/develerik/git-credential-1password/releases/tag/v${version}";
    license = licenses.isc;
    maintainers = [ maintainers.ivankovnatsky ];
    mainProgram = "git-credential-1password";
  };
}
