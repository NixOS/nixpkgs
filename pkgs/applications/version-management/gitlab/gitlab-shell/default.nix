{ stdenv, fetchFromGitLab, buildGoPackage, ruby }:

buildGoPackage rec {
  pname = "gitlab-shell";
  version = "13.2.0";
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-shell";
    rev = "v${version}";
    sha256 = "0drdpg4nmhzrmy8sl1f3hcd1278bpapgf0wmhi94xlyayh47j53a";
  };

  buildInputs = [ ruby ];

  patches = [ ./remove-hardcoded-locations.patch ];

  goPackagePath = "gitlab.com/gitlab-org/gitlab-shell";
  goDeps = ./deps.nix;

  postInstall = ''
    cp -r "$NIX_BUILD_TOP/go/src/$goPackagePath"/bin/* $out/bin
    cp -r "$NIX_BUILD_TOP/go/src/$goPackagePath"/{support,VERSION} $out/
  '';

  meta = with stdenv.lib; {
    description = "SSH access and repository management app for GitLab";
    homepage = "http://www.gitlab.com/";
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz globin talyz ];
    license = licenses.mit;
  };
}
