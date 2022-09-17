{ lib, fetchFromGitLab, buildGoModule, ruby }:

buildGoModule rec {
  pname = "gitlab-shell";
  version = "14.10.0";
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "gitlab-shell";
    rev = "v${version}";
    sha256 = "sha256-7uy7F4wK/4xz0PK9ZadaMjy3c+xUK9+YKaaEm5iFqUs=";
  };

  buildInputs = [ ruby ];

  patches = [ ./remove-hardcoded-locations.patch ];

  vendorSha256 = "sha256-urS0FED636APQe5uNvhDvWsnZtHCW60VtRE1B7IzGZQ=";

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
