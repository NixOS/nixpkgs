{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeBinaryWrapper,
  pkg-config,
  alsa-lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "piano-rs";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ritiek";
    repo = "piano-rs";
    rev = "v${version}";
    hash = "sha256-qZeH9xXQPIOJ87mvLahnJB3DuEgLX0EAXPvECgxNlq0=";
  };

  cargoHash = "sha256-ygRyYFLNBCLnRhmO6DoK8fwvy/Y9jrOjWChzxc3CRPo=";

  nativeBuildInputs = [
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [
    alsa-lib
  ];

  postInstall = ''
    mkdir -p "$out"/share/piano-rs
    cp -r assets "$out"/share/piano-rs
    wrapProgram "$out"/bin/piano-rs \
      --set ASSETS "$out"/share/piano-rs/assets
  '';

  meta = with lib; {
    description = "Multiplayer piano using UDP sockets that can be played using computer keyboard, in the terminal";
    homepage = "https://github.com/ritiek/piano-rs";
    license = licenses.mit;
    mainProgram = "piano-rs";
    maintainers = with maintainers; [ ritiek ];
    platforms = platforms.unix;
  };
}
