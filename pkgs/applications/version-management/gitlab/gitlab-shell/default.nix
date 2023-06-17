{ lib, fetchFromGitLab, buildGoModule, ruby, libkrb5 }:

buildGoModule rec {
  pname = "gitlab-shell";
  version = "14.20.0";
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-shell";
    rev = "v${version}";
    sha256 = "sha256-5rjrBt0AihSHMYOD6JbXGvvFaUbtYnMHX2Z4K+Svno0=";
  };

  buildInputs = [ ruby libkrb5 ];

  patches = [ ./remove-hardcoded-locations.patch ];

  vendorSha256 = "sha256-kKbTbOCuAGIbnFXTOZyoVRM5PIackbmND6PrryVvLTM=";

  postInstall = ''
    cp -r "$NIX_BUILD_TOP/source"/bin/* $out/bin
    cp -r "$NIX_BUILD_TOP/source"/{support,VERSION} $out/
  '';
  doCheck = false;

  meta = with lib; {
    description = "SSH access and repository management app for GitLab";
    homepage = "http://www.gitlab.com/";
    platforms = platforms.linux;
    maintainers = with maintainers; [ globin talyz yayayayaka ];
    license = licenses.mit;
  };
}
