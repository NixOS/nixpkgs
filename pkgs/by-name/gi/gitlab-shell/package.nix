{
  lib,
  fetchFromGitLab,
  buildGoModule,
  ruby,
  libkrb5,
}:

buildGoModule rec {
  pname = "gitlab-shell";
  version = "14.44.0";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-shell";
    rev = "v${version}";
    hash = "sha256-y3CTfYN2QCWm2n534Bb8uS0Bzn4BsBuMtxAyuU3f+oI=";
  };

  buildInputs = [
    ruby
    libkrb5
  ];

  patches = [
    ./remove-hardcoded-locations.patch
  ];

  vendorHash = "sha256-flLt2LdcSDIuoUr4mwfv6LOV9GPewf+o0rb8kyBsgSk=";

  subPackages = [
    "cmd/gitlab-shell"
    "cmd/gitlab-sshd"
    "cmd/gitlab-shell-check"
    "cmd/gitlab-shell-authorized-principals-check"
    "cmd/gitlab-shell-authorized-keys-check"
  ];

  postInstall = ''
    cp -r "$NIX_BUILD_TOP/source"/{support,VERSION} $out/
  '';
  doCheck = false;

  meta = with lib; {
    description = "SSH access and repository management app for GitLab";
    homepage = "http://www.gitlab.com/";
    platforms = platforms.linux;
    teams = [ teams.gitlab ];
    license = licenses.mit;
  };
}
