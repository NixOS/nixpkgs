{ lib, fetchFromGitLab, buildGoModule, ruby, libkrb5 }:

buildGoModule rec {
  pname = "gitlab-shell";
  version = "14.33.0";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-shell";
    rev = "v${version}";
    sha256 = "sha256-0C3ODs2NElJQ+A6x9lZxSParTZc3q4YqWsw7DxwhODo=";
  };

  buildInputs = [ ruby libkrb5 ];

  patches = [ ./remove-hardcoded-locations.patch ];

  vendorHash = "sha256-sTAd/AbPx5WzBCzTDLvo/bDZcmz/xVhIhz9nFGBEYx4=";

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
