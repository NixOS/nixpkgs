{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
  testers,
  dbus,
  openssl,
  pkg-config,
  aw-watcher-media-player,
}:

rustPlatform.buildRustPackage rec {
  pname = "aw-watcher-media-player";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "2e3s";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-6lVW2hd1nrPEV3uRJbG4ySWDVuFUi/JSZ1HYJFz0KdQ=";
  };

  buildInputs = [
    dbus
    openssl
  ];

  nativeBuildInputs = [ pkg-config ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "aw-client-rust-0.1.0" = "sha256-fCjVfmjrwMSa8MFgnC8n5jPzdaqSmNNdMRaYHNbs8Bo=";
    };
  };

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--generate-lockfile" ]; };
    tests.version = testers.testVersion {
      package = aw-watcher-media-player;
      command = "aw-watcher-media-player --version";
    };
  };

  postInstall = ''
    mkdir -p $out/share/$pname
    cp -R visualization $out/share/$pname/visualization
  '';

  meta = {
    description = "Watcher of system's currently playing media for ActivityWatch";
    homepage = "https://github.com/2e3s/aw-watcher-media-player";
    license = lib.licenses.unlicense;
    maintainers = [ lib.maintainers.giggio ];
    mainProgram = "aw-watcher-media-player";
    platforms = lib.platforms.linux;
  };
}
