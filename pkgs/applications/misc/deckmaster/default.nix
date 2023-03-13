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
    rev = "v${version}";
    sha256 = "sha256-1hZ7yAKTvkk20ho+QOqFEtspBvFztAtfmITs2uxhdmQ=";
  };

  vendorHash = "sha256-d38s5sSvENIou+rlphXIrrOcGOdsvkNaMJlhiXVWN6c=";

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
