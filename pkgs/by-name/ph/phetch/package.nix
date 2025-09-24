{
  lib,
  fetchFromGitHub,
  installShellFiles,
  rustPlatform,
  pkg-config,
  openssl,
  scdoc,
  which,
}:

rustPlatform.buildRustPackage rec {
  pname = "phetch";
  version = "1.2.0";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "xvxx";
    repo = "phetch";
    tag = "v${version}";
    hash = "sha256-J+ka7/B37WzVPPE2Krkd/TIiVwuKfI2QYWmT0JHgBGQ=";
  };

  cargoHash = "sha256-2lbQAM3gdytXsoMFzKwLWA1hvQIJf1vBdMRpYx/VLVg=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    scdoc
    which
  ];
  buildInputs = [ openssl ];

  postInstall = ''
    make manual
    installManPage doc/phetch.1
  '';

  doCheck = true;

  meta = {
    description = "Quick lil gopher client for your terminal, written in rust";
    mainProgram = "phetch";
    longDescription = ''
      phetch is a terminal client designed to help you quickly navigate the gophersphere.
      - <1MB executable for Linux, Mac, and NetBSD
      - Technicolor design (based on GILD)
      - No-nonsense keyboard navigation
      - Supports Gopher searches, text and menu pages, and downloads
      - Save your favorite Gopher sites with bookmarks
      - Opt-in history tracking
      - Secure Gopher support (TLS)
      - Tor support
    '';
    changelog = "https://github.com/xvxx/phetch/releases/tag/v${version}";
    homepage = "https://github.com/xvxx/phetch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felixalbrigtsen ];
  };
}
