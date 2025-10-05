{
  lib,
  fetchFromGitHub,
  rustPlatform,
  makeWrapper,
  iperf3,
}:

rustPlatform.buildRustPackage rec {
  pname = "iperf3d";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "wobcom";
    repo = "iperf3d";
    rev = "v${version}";
    hash = "sha256-pMwGoBgFRVY+H51k+YCamzHgBoaJVwEVqY0CvMPvE0w=";
  };

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/iperf3d --prefix PATH : ${iperf3}/bin
  '';

  cargoHash = "sha256-eijsPyoe3/+yR5kRmzk0dH62gTAFFURTVT8wN6Iy0HI=";

  meta = with lib; {
    description = "Iperf3 client and server wrapper for dynamic server ports";
    mainProgram = "iperf3d";
    homepage = "https://github.com/wobcom/iperf3d";
    license = licenses.mit;
    maintainers = with maintainers; [ netali ];
    teams = [ teams.wdz ];
  };
}
