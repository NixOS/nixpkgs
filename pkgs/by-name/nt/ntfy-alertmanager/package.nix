{
  buildGoModule,
  fetchurl,
  lib,
}:

buildGoModule rec {
  pname = "ntfy-alertmanager";
  version = "0.4.0";

  src = fetchurl {
    url = "https://git.xenrox.net/~xenrox/ntfy-alertmanager/refs/download/v${version}/ntfy-alertmanager-${version}.tar.gz";
    hash = "sha256-5rQzJZ0BaLtfj2MfyZZJ3PEiWnaTjWOMlsJYeYENW7U=";
  };

  vendorHash = "sha256-8a6dvBERegpFYFHQGJppz5tlQioQAudCe3/Q7vro+ZI=";

  meta = with lib; {
    description = "A bridge between ntfy and Alertmanager";
    homepage = "https://git.xenrox.net/~xenrox/ntfy-alertmanager";
    license = licenses.agpl3Only;
    mainProgram = "ntfy-alertmanager";
    maintainers = with maintainers; [
      bleetube
      fpletz
    ];
    platforms = platforms.linux;
  };
}
