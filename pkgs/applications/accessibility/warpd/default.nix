{ lib, stdenv, fetchFromGitHub, xorg }:

stdenv.mkDerivation rec {
  pname = "warpd";
  version = "1.0.2-beta";

  src = fetchFromGitHub {
    owner = "rvaiya";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-voZCUaz8RulfYfY/2W4eEHb6Dt+nsk2KxESwtafG728=";
  };

  nativeBuildInputs = [
    xorg.libX11 xorg.libXtst xorg.libXi xorg.libXext.dev xorg.libXft
  ];

  installPhase = ''
    install -Dm755 bin/warpd $out/bin/warpd
  '';

  meta = {
    description = "A modal keyboard-driven virtual pointer for X11.";
    homepage = "https://github.com/rvaiya/warpd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Enzime ];
  };
}
