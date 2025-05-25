{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libxcrypt,
  nixosTests,
}:

buildGoModule rec {
  pname = "portunus";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "majewsky";
    repo = "portunus";
    rev = "v${version}";
    sha256 = "sha256-nLFwfH1K6vsgNATwAxyq/q6HTtfLK8gsQhei7eJ86Kc=";
  };

  buildInputs = [ libxcrypt ];

  vendorHash = null;

  passthru.tests = { inherit (nixosTests) portunus; };

  meta = with lib; {
    description = "Self-contained user/group management and authentication service";
    homepage = "https://github.com/majewsky/portunus";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ majewsky ];
    teams = [ teams.c3d2 ];
  };
}
