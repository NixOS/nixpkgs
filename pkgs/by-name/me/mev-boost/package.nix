{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mev-boost";
  version = "1.7";
  src = fetchFromGitHub {
      owner = "flashbots";
      repo = "mev-boost";
      rev = "v${version}";
      hash = "sha256-Z5B+PRYb6eWssgyaXpXoHOVRoMZoSAwun7s6Fh1DrfM=";
  };

  vendorHash = "sha256-yfWDGVfgCfsmzI5oxEmhHXKCUAHe6wWTkaMkBN5kQMw=";

  meta = with lib; {
    description = "Ethereum block-building middleware";
    homepage = "https://github.com/flashbots/mev-boost";
    license = licenses.mit;
    mainProgram = "mev-boost";
    maintainers = with maintainers; [ ekimber ];
    platforms = platforms.unix;
  };
}
