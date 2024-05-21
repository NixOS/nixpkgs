{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, makeWrapper
, roboto
}:

buildGoModule rec {
  pname = "deckmaster";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "muesli";
    repo = "deckmaster";
    rev = "refs/tags/v${version}";
    hash = "sha256-1hZ7yAKTvkk20ho+QOqFEtspBvFztAtfmITs2uxhdmQ=";
  };

  vendorHash = "sha256-DFssAic2YtXNH1Jm6zCDv1yPNz3YUXaFLs7j7rNHhlE=";

  proxyVendor = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  # Let the app find Roboto-*.ttf files (hard-coded file names).
  postFixup = ''
    wrapProgram $out/bin/deckmaster \
      --prefix XDG_DATA_DIRS : "${roboto.out}/share/" \
  '';

  meta = with lib; {
    description = "An application to control your Elgato Stream Deck on Linux";
    mainProgram = "deckmaster";
    homepage = "https://github.com/muesli/deckmaster";
    changelog = "https://github.com/muesli/deckmaster/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ianmjones ];
    platforms = platforms.linux;
  };
}
