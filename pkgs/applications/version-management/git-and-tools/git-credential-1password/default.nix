{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "git-credential-1password";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "develerik";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-F3XhBVTV8TgVNrOePm3F+uWspkllBlZ/yRyUxrCG0xw=";
  };

  vendorSha256 = "sha256-2CNGAuvO8IeNUhFnMEj8NjZ2Qm0y+i/0ktNCd3A8Ans=";

  meta = with lib; {
    description = "A git credential helper for 1Password";
    homepage = "https://github.com/develerik/git-credential-1password";
    changelog = "https://github.com/develerik/git-credential-1password/releases/tag/v${version}";
    license = licenses.isc;
    maintainers = [ maintainers.ivankovnatsky ];
  };
}
