{
  rustPlatform,
  lib,
  fetchzip,
  openssl,
  pkg-config,
  systemd,
}:

rustPlatform.buildRustPackage rec {
  pname = "pr-tracker";
  version = "1.6.0";

  src = fetchzip {
    url = "https://git.qyliss.net/pr-tracker/snapshot/pr-tracker-${version}.tar.xz";
    hash = "sha256-O+dtGxVhn3hW+vFQzEt7kQRTnZgc1R938BJ6pAkIW4E=";
  };

  cargoHash = "sha256-t+jiOr5pjJNMpaOLYKlk194b2njT1XWKKlPQtKsUu3E=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    systemd
  ];

  meta = with lib; {
    changelog = "https://git.qyliss.net/pr-tracker/plain/NEWS?h=${version}";
    description = "Nixpkgs pull request channel tracker";
    longDescription = ''
      A web server that displays the path a Nixpkgs pull request will take
      through the various release channels.
    '';
    platforms = platforms.linux;
    homepage = "https://git.qyliss.net/pr-tracker";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [
      qyliss
      sumnerevans
    ];
    mainProgram = "pr-tracker";
  };
}
