{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libxcrypt,
  nixosTests,
}:

buildGoModule rec {
  pname = "portunus";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "majewsky";
    repo = "portunus";
    rev = "v${version}";
    sha256 = "sha256-xZb2+IIZkZd/yGr0+FK7Bi3sZpPMfGz/QmUKn/clrwE=";
  };

  buildInputs = [ libxcrypt ];

  vendorHash = null;

  passthru.tests = { inherit (nixosTests) portunus; };

  meta = {
    description = "Self-contained user/group management and authentication service";
    homepage = "https://github.com/majewsky/portunus";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ majewsky ];
    teams = [ lib.teams.c3d2 ];
  };
}
