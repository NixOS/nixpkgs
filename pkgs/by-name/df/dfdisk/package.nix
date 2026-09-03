{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  libewf,
  smartmontools,
  ddrescue,
  util-linux,
  systemd,
}:

rustPlatform.buildRustPackage rec {
  pname = "dfdisk";
  version = "0.1.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "tylerstyle";
    repo = "dfdisk";
    rev = "v${version}";
    hash = "sha256-dvcRwTGB0UsHlv7pUc3GXeYoUXrE49HtRUWs4tJyKX0=";
  };

  cargoHash = "sha256-sfJxgqm9MHZOC/xpE/8GcMBGKKFQRiWgYWZkN466OyI=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    libewf
    smartmontools
    ddrescue
    util-linux
    systemd
  ];

  postInstall = ''
    wrapProgram $out/bin/dfdisk \
      --prefix PATH : ${
        lib.makeBinPath [
          libewf
          smartmontools
          ddrescue
          util-linux
          systemd
        ]
      }
  '';

  meta = with lib; {
    description = "Modern forensic disk imaging, damaged media rescue and conversion CLI/TUI tool";
    homepage = "https://github.com/tylerstyle/dfdisk";
    changelog = "https://github.com/tylerstyle/dfdisk/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ tylerstyle ];
    mainProgram = "dfdisk";
    platforms = platforms.linux;
  };
}
