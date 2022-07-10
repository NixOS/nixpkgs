{ lib, fetchFromGitLab, buildGoModule, ruby }:

buildGoModule rec {
  pname = "gitlab-shell";
  version = "14.7.4";
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-shell";
    rev = "v${version}";
    sha256 = "sha256-kLIjlMwoK1AlhvP38OspXnIWbdOcaLl4r05PiUmqnWw=";
  };

  buildInputs = [ ruby ];

  patches = [ ./remove-hardcoded-locations.patch ];

  vendorSha256 = "sha256-f2IkdkTZhve/cYKSH+N2Y5bXFSHuQ8t4hjfReyKTPUU=";

  postInstall = ''
    cp -r "$NIX_BUILD_TOP/source"/bin/* $out/bin
    cp -r "$NIX_BUILD_TOP/source"/{support,VERSION} $out/
  '';
  doCheck = false;

  meta = with lib; {
    description = "SSH access and repository management app for GitLab";
    homepage = "http://www.gitlab.com/";
    platforms = platforms.linux;
    maintainers = with maintainers; [ fpletz globin talyz yayayayaka ];
    license = licenses.mit;
  };
}
