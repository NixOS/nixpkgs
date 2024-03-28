{ lib, stdenv, fetchFromGitHub, libX11, patches ? [ ] }:

stdenv.mkDerivation {
  pname = "dwmblocks-async";
  version = "unstable-2023-04-05";

  src = fetchFromGitHub {
    owner = "UtkarshVerma";
    repo = "dwmblocks-async";
    rev = "27731295335d31966491f55f54912c3b9dd1a7a7";
    sha256 = "sha256-9VHalp9NM26yQ3A9NgbPFiukxfaKnv/VcKJpQh1lhu4=";
  };

  inherit patches;

  buildInputs = [ libX11 ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description =
      "A dwm status bar that utilizes a modular and async design to keep it responsive";
    homepage = "https://github.com/UtkarshVerma/dwmblocks-async";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ poptart ];
    platforms = platforms.linux;
  };
}
