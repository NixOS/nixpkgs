{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  pkg-config,
  python310,
  alsa-lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "piano-rs";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ritiek";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qZeH9xXQPIOJ87mvLahnJB3DuEgLX0EAXPvECgxNlq0=";
  };

  cargoHash = "sha256-vDqfWXeQVEnMWMjhAG/A0afff7dWMoQejDZjcVlYBMQ=";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];

  buildInputs = [
    python310
    alsa-lib
  ];

  postInstall = ''
    mkdir -p "$out"/lib
    install -Dm644 ${alsa-lib.out}/lib/libasound* "$out"/lib/

    cp -r assets "$out"/
    wrapProgram "$out"/bin/piano-rs --set ASSETS "$out"/assets
  '';

  meta = with lib; {
    description = "A multiplayer piano using UDP sockets that can be played using computer keyboard, in the terminal";
    homepage = "https://github.com/ritiek/piano-rs";
    license = licenses.mit;
    mainProgram = "piano-rs";
    maintainers = with maintainers; [ ritiek ];
    platforms = platforms.unix;
  };
}
