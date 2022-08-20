{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, makeWrapper
, roboto
}:

buildGoModule rec {
  pname = "deckmaster";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "muesli";
    repo = "deckmaster";
    rev = "v${version}";
    sha256 = "sha256-q2rUHfAvTGXBAGrZUtHMuZr6fYWmpha+al2FG8sCC0Y=";
  };

  vendorSha256 = "sha256-kj4lRHuQ9e0TOC4p4Ak3AB3Lx0JN1jqXaVKlee9EtCg=";

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
    homepage = "https://github.com/muesli/deckmaster";
    license = licenses.mit;
    maintainers = with maintainers; [ ianmjones ];
    platforms = platforms.linux;
  };
}
