{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  installShellFiles,
  pkg-config,
  cmake,
}:

rustPlatform.buildRustPackage rec {
  pname = "rmpc";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "mierak";
    repo = "rmpc";
    rev = "v${version}";
    hash = "sha256-IcWn15tKlThuLR8s/4KtaHm4np8B8UaKYQsyEWlQoB4=";
  };

  cargoHash = "sha256-DDOJqA5S+JiRCOgAPqw1k1b8SNCLS0aKsJsFqlykZDI=";

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    cmake
  ];

  passthru.updateScript = nix-update-script { };

  env.VERGEN_GIT_DESCRIBE = version;

  postInstall = ''
    installManPage target/man/rmpc.1

    installShellCompletion --cmd rmpc \
      --bash target/completions/rmpc.bash \
      --fish target/completions/rmpc.fish \
      --zsh target/completions/_rmpc

    install -m 444 -D assets/rmpc.desktop $out/share/applications/rmpc.desktop
  '';

  meta = {
    changelog = "https://github.com/mierak/rmpc/releases/tag/${src.rev}";
    description = "TUI music player client for MPD with album art support via kitty image protocol";
    homepage = "https://rmpc.mierak.dev/";
    license = lib.licenses.bsd3;
    longDescription = ''
      Rusty Music Player Client is a beautiful, modern and configurable terminal-based Music Player
      Daemon client. It was inspired by ncmpcpp and aims to provide an alternative with support for
      album art through kitty image protocol without any ugly hacks. It also features ranger/lf
      inspired browsing of songs and other goodies.
    '';
    maintainers = with lib.maintainers; [
      donovanglover
      faukah
    ];
    mainProgram = "rmpc";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
