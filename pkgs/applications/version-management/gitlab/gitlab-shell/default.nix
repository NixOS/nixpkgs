{ lib, fetchFromGitLab, buildGoModule, ruby, libkrb5 }:

buildGoModule rec {
  pname = "gitlab-shell";
  version = "14.32.0";

  # nixpkgs-update: no auto update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-shell";
    rev = "v${version}";
    sha256 = "sha256-fZttdcIdPeiy2ncDyseR1BnR6GBoSRsFkn7Mxc+mTA8=";
  };

  buildInputs = [ ruby libkrb5 ];

  patches = [ ./remove-hardcoded-locations.patch ];

  vendorHash = "sha256-tdYBEV/dKnIJ+OWTF3/5bIbWVdE/ulMrMD/LMzj1QZE=";

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
