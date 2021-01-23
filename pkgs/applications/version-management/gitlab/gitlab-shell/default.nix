{ lib, stdenv, fetchFromGitLab, buildGoModule, ruby }:

buildGoModule rec {
  pname = "gitlab-shell";
  version = "13.14.0";
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-shell";
    rev = "v${version}";
    sha256 = "171c4rfffb73198fhlwk8rq7xy4b4zrnssi8c1wd0x82kqv6csb0";
  };

  buildInputs = [ ruby ];

  patches = [ ./remove-hardcoded-locations.patch ];

  vendorSha256 = "16fa3bka0008x2yazahc6xxcv4fa6yqg74kk64v8lrp7snbvjf4d";

  postInstall = ''
    cp -r "$NIX_BUILD_TOP/source"/bin/* $out/bin
    cp -r "$NIX_BUILD_TOP/source"/{support,VERSION} $out/
  '';
  doCheck = false;

  meta = with lib; {
    description = "SSH access and repository management app for GitLab";
    homepage = "http://www.gitlab.com/";
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz globin talyz ];
    license = licenses.mit;
  };
}
