{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "mev-boost";
  version = "1.9";
  src = fetchFromGitHub {
    owner = "flashbots";
    repo = "mev-boost";
    rev = "v${version}";
    hash = "sha256-VBvbiB7M6X+bQ5xEwmJo5dptiR7PIBiFDqkg1fyU8ro=";
  };

  vendorHash = "sha256-OyRyMsINy4I04E2QvToOEY7UKh2s6NUeJJO0gJI5uS0=";

  meta = with lib; {
    description = "Ethereum block-building middleware";
    homepage = "https://github.com/flashbots/mev-boost";
    license = licenses.mit;
    mainProgram = "mev-boost";
    maintainers = with maintainers; [ ekimber ];
    platforms = platforms.unix;
  };
}
