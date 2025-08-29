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
  version = "1.8.0";

  src = fetchzip {
    url = "https://git.qyliss.net/pr-tracker/snapshot/pr-tracker-${version}.tar.xz";
    hash = "sha256-Trn+ogRNR23j2S+82ZqeWIZriUZ/Lv7khGBo0aiYutU=";
  };

  cargoHash = "sha256-63Y/BXmFRbrTUBtUNP1iEk+cvSxDJG/bp8mBWQbQsh0=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    systemd
  ];

  meta = {
    changelog = "https://git.qyliss.net/pr-tracker/plain/NEWS?h=${version}";
    description = "Nixpkgs pull request channel tracker";
    longDescription = ''
      A web server that displays the path a Nixpkgs pull request will take
      through the various release channels.
    '';
    platforms = lib.platforms.linux;
    homepage = "https://git.qyliss.net/pr-tracker";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      qyliss
      sumnerevans
    ];
    mainProgram = "pr-tracker";
  };
}
