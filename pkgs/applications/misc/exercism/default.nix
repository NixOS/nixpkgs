{ lib, buildGoModule, fetchFromGitHub, nix-update-script }:

buildGoModule rec {
  pname = "exercism";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "exercism";
    repo  = "cli";
    rev   = "refs/tags/v${version}";
    hash  = "sha256-+DXmbbs9oo667o5P0OVcfBMMIvyBzEAdbrq9i+U7p0k=";
  };

  vendorHash = "sha256-wQGnGshsRJLe3niHDoyr3BTxbwrV3L66EjJ8x633uHY=";

  doCheck = false;

  subPackages = [ "./exercism" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
   inherit (src.meta) homepage;
   description = "A Go based command line tool for exercism.io";
   license     = licenses.mit;
   maintainers = [ maintainers.rbasso maintainers.nobbz ];
  };
}
