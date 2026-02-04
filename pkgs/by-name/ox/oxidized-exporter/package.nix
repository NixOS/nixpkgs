{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "oxidized-exporter";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "akquinet";
    repo = "oxidized-exporter";
    rev = "v${version}";
    hash = "sha256-xqNhstsNglYhIQvFbKPU7KTgRNHySwqWOgsazTmWzns=";
  };

  vendorHash = "sha256-+PwVigu/9rDkFlGtgr+OOL+N+EOgcLab2Rla33HYBGI=";

  meta = {
    description = "Prometheus exporter for Oxidized";
    homepage = "https://github.com/akquinet/oxidized-exporter";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ rwxd ];
    mainProgram = "oxidized-exporter";
  };
}
