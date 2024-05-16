{
  lib,
  buildGoModule,
  fetchFromGitHub,
  ...
}:
let
  version = "0.0.5";
in
buildGoModule {
  pname = "izrss";
  inherit version;

  src = fetchFromGitHub {
    owner = "isabelroses";
    repo = "izrss";
    rev = "refs/tags/v${version}";
    hash = "sha256-6ayTxAjVqMjgDbk4oJjxzSUkWA6kU3Rnvvma+ryy4bw=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  vendorHash = "sha256-gH5AFroreBD0tQmT99Bmo2pAdPkiPWUNGsmKX4p3/JA=";

  meta = with lib; {
    description = "An RSS feed reader for the terminal written in Go";
    homepage = "https://github.com/isabelroses/izrss";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      isabelroses
      luftmensch-luftmensch
    ];
    mainProgram = "izrss";
  };
}
