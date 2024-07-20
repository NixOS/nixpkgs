{ lib, fetchFromGitLab, buildGoModule, ruby, libkrb5 }:

buildGoModule rec {
  pname = "gitlab-shell";
  version = "14.36.0";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-shell";
    rev = "v${version}";
    hash = "sha256-SclRIIUZm1D5fYDrTH1L8opQpxxIoi+SrG2GO7wtScU=";
  };

  buildInputs = [ ruby libkrb5 ];

  patches = [
    ./remove-hardcoded-locations.patch
  ];

  vendorHash = "sha256-Ebs9HnHhK4y6+vwLRvVwQnG8I7Gk6leBBezjkc+bhJo=";

  postInstall = ''
    cp -r "$NIX_BUILD_TOP/source"/bin/* $out/bin
    cp -r "$NIX_BUILD_TOP/source"/{support,VERSION} $out/
  '';
  doCheck = false;

  meta = with lib; {
    description = "SSH access and repository management app for GitLab";
    homepage = "http://www.gitlab.com/";
    platforms = platforms.linux;
    maintainers = teams.gitlab.members;
    license = licenses.mit;
  };
}
