{ lib, fetchFromGitLab, buildGoModule, ruby }:

buildGoModule rec {
  pname = "gitlab-shell";
  version = "13.21.1";
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-shell";
    rev = "v${version}";
    sha256 = "sha256-FBkxJLl58ZbqM1P4LohsozGiKg38gQwVGOV9AAjVE0M=";
  };

  buildInputs = [ ruby ];

  patches = [ ./remove-hardcoded-locations.patch ];

  vendorSha256 = "sha256-cE6phpVYcZNCEk6bElEksIf4GOr/5vJPRdlGCubRafE=";

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
