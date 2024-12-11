{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  rustPlatform,
  pkg-config,
  openssl,
  scdoc,
  Security,
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
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-J+ka7/B37WzVPPE2Krkd/TIiVwuKfI2QYWmT0JHgBGQ=";
  };

  cargoHash = "sha256-y3Y5PnZ51Zc3LmVTijUGnb0KaGm28sWOSYxjuM3A1Zk=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    scdoc
    which
  ];
  buildInputs = [ openssl ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  postInstall = ''
    make manual
    installManPage doc/phetch.1
  '';

  doCheck = true;

  meta = with lib; {
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
    license = licenses.mit;
    maintainers = with maintainers; [ felixalbrigtsen ];
  };
}
