{ stdenv, fetchFromGitLab, buildGoPackage, ruby }:

buildGoPackage rec {
  pname = "gitlab-shell";
  version = "13.13.0";
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-shell";
    rev = "v${version}";
    sha256 = "1zx7x3g18xzw7fs7cayd20llxabv5r93m2mp6ixgr99ksvi6zix7";
  };

  buildInputs = [ ruby ];

  patches = [ ./remove-hardcoded-locations.patch ];

  goPackagePath = "gitlab.com/gitlab-org/gitlab-shell";
  goDeps = ./deps.nix;

  preBuild = ''
    rm -rf "$NIX_BUILD_TOP/go/src/gitlab.com/gitlab-org/labkit/vendor"
  '';

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
