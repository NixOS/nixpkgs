{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "fscan";
  version = "2.0.0-build4";

  src = fetchFromGitHub {
    owner = "shadow1ng";
    repo = "fscan";
    rev = version;
    hash = "sha256-paW48xpxl/d3abDsBCPwbmSZ8yoFhlTU+VPg/Egq0eY=";
  };

  vendorHash = "sha256-OyYPN9pq3Hx8utKXj3Hx9kqE90M2XqHkgTT5P9D6BVc=";

  meta = with lib; {
    description = "Intranet comprehensive scanning tool";
    homepage = "https://github.com/shadow1ng/fscan";
    license = licenses.mit;
    maintainers = with maintainers; [ Misaka13514 ];
    mainProgram = "fscan";
  };
}
