{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "git-credential-oauth";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "hickford";
    repo = pname;
    rev = "v${version}";
    sha256 = "017bd47edc0dd3057323d8b9ccca008b7ebca7aedf6862b1ebca5e54f5a62496";
  };

  vendorHash = "sha256-B6BlVnUX4XLT+9EpL63Ht4S8Wo84RsmY99CL+srQfpw=";

  meta = with lib; {
    description = "Git credential helper that securely authenticates to GitHub, GitLab and BitBucket using OAuth";
    homepage = "https://github.com/hickford/git-credential-oauth";
    changelog = "https://github.com/hickford/git-credential-oauth/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.hickford ];
  };
}
