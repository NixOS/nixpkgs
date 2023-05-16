{ lib, fetchFromGitLab, buildGoModule, ruby, libkrb5 }:

buildGoModule rec {
  pname = "gitlab-shell";
<<<<<<< HEAD
  version = "14.26.0";
=======
  version = "14.18.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-shell";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-nDnPldBQy4Zg0uZshxSmcEl0ggmqg6CyNWc/I3szonI=";
=======
    sha256 = "sha256-dMxWnv+YfoDy9rhuCx+JIxFyjHejttkkqkQ4owdI/4g=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ ruby libkrb5 ];

  patches = [ ./remove-hardcoded-locations.patch ];

<<<<<<< HEAD
  vendorHash = "sha256-Lqo0fdrYEHOKjF/XT3c1VjVQc1YxeBy6yW69IxXZAow=";
=======
  vendorSha256 = "sha256-zqZMZvYteOWTgDnlX8H1i8e/QTbAoTPD6ZNsHsCcLdM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postInstall = ''
    cp -r "$NIX_BUILD_TOP/source"/bin/* $out/bin
    cp -r "$NIX_BUILD_TOP/source"/{support,VERSION} $out/
  '';
  doCheck = false;

  meta = with lib; {
    description = "SSH access and repository management app for GitLab";
    homepage = "http://www.gitlab.com/";
    platforms = platforms.linux;
<<<<<<< HEAD
    maintainers = teams.gitlab.members;
=======
    maintainers = with maintainers; [ globin talyz yayayayaka ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
  };
}
