{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "autospotting";
  version = "unstable-2022-02-17";

  src = fetchFromGitHub {
    owner = "cloudutil";
    repo = "AutoSpotting";
    rev = "f295a1f86c4a21144fc7fe28a69da5668fb7ad0c";
    sha256 = "sha256-n5R5RM2fv3JWqtbSsyb7GWS4032dkgcihAKbpjB/5PM=";
  };

  vendorSha256 = "sha256-w7OHGZ7zntu8ZlI5gA19Iq7TKR23BQk9KpkUO+njL9Q=";

  excludedPackages = [ "scripts" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Automatically convert your existing AutoScaling groups to up to 90% cheaper spot instances with minimal configuration changes";
    homepage = "https://github.com/cloudutil/AutoSpotting";
    license = licenses.osl3;
    maintainers = with maintainers; [ costrouc ];
    mainProgram = "AutoSpotting";
    platforms = platforms.unix;
  };
}
