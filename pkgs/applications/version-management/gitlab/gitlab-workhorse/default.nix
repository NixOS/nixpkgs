{ lib, fetchFromGitLab, git, buildGoModule }:

buildGoModule rec {
  pname = "gitlab-workhorse";

  version = "8.59.2";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-workhorse";
    rev = "v${version}";
    sha256 = "sha256-hMcE7dlUw34DyUO0v5JxwvvEh/HC2emrIKc1K1U4bPE=";
  };

  vendorSha256 = "0vkw12w7vr0g4hf4f0im79y7l36d3ah01n1vl7siy94si47g8ir5";
  buildInputs = [ git ];
  buildFlagsArray = "-ldflags=-X main.Version=${version}";
  doCheck = false;

  meta = with lib; {
    homepage = "http://www.gitlab.com/";
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz globin talyz ];
    license = licenses.mit;
  };
}
