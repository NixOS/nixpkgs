{
  buildGoModule,
  fetchurl,
  lib,
}:

buildGoModule rec {
  pname = "ntfy-alertmanager";
  version = "0.3.0";

  src = fetchurl {
    url = "https://git.xenrox.net/~xenrox/ntfy-alertmanager/refs/download/v${version}/ntfy-alertmanager-${version}.tar.gz";
    hash = "sha256-8VDHeK77dcbATSFfqknlhMSP93OlDNmkzRJxLN4rCVE=";
  };

  vendorHash = "sha256-WKImEc7FvZm/6noC2+Lz4g+ASFEuRBE8nzTEDbXaWic=";

  meta = with lib; {
    description = "A bridge between ntfy and Alertmanager.";
    homepage = "https://git.xenrox.net/~xenrox/ntfy-alertmanager";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      bleetube
      fpletz
    ];
  };
}
