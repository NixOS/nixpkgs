{ lib, fetchFromGitLab, buildGoModule, ruby, libkrb5 }:

buildGoModule rec {
  pname = "gitlab-shell";
  version = "14.38.0";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-shell";
    rev = "v${version}";
    hash = "sha256-oYvsSjdzfJn4ujy1qbMmqZyEQFbYTSke8t3KBqjr/Vc=";
  };

  buildInputs = [ ruby libkrb5 ];

  patches = [
    ./remove-hardcoded-locations.patch
  ];

  vendorHash = "sha256-YOShgZv0zdfXgKi//IENt6wE2m0S1Kqa+2ndvCwKDLQ=";

  postInstall = ''
    cp -r "$NIX_BUILD_TOP/source"/bin/* $out/bin
    mv $out/bin/install $out/bin/gitlab-shell-install
    mv $out/bin/check $out/bin/gitlab-shell-check
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
