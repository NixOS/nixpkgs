{ stdenv, fetchFromGitLab, buildGoPackage, ruby }:

buildGoPackage rec {
  pname = "gitlab-shell-go";
  version = "10.3.0";
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-shell";
    rev = "v${version}";
    sha256 = "0kxbw2n5kabh0876xqn1dcjbxyrp82ms566rw065nqrb32g8c2hk";
  };

  buildInputs = [ ruby ];

  patches = [ ./remove-hardcoded-locations.patch ];

  goPackagePath = "gitlab.com/gitlab-org/gitlab-shell";
  goDeps = ./deps.nix;

  postInstall = ''
    cp -r "$NIX_BUILD_TOP/go/src/$goPackagePath"/bin/* $bin/bin
    cp -r "$NIX_BUILD_TOP/go/src/$goPackagePath"/{support,VERSION} $bin/
  '';

  meta = with stdenv.lib; {
    description = "SSH access and repository management app for GitLab";
    homepage = http://www.gitlab.com/;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz globin talyz ];
    license = licenses.mit;
  };
}
