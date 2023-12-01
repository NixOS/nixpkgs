{ lib
, fetchFromGitHub
, rustPlatform
}:

rustPlatform.buildRustPackage rec {
  pname = "swaycons";
  version = "unstable-2023-01-05";

  src = fetchFromGitHub {
    owner = "ActuallyAllie";
    repo = "swaycons";
    rev = "e863599fb56177fc9747d60db661be2d7c2d290b";
    hash = "sha256-zkCpZ3TehFKNePtSyFaEk+MA4mi1+la9yFjRPFy+eq8=";
  };

  cargoSha256 = "sha256-GcoRx52dwL/ehJ1Xg6xQHVzPIKXWqBrG7IjzxRjfgqA=";

  meta = with lib; {
    description = "Window Icons in Sway with Nerd Fonts!";
    homepage = "https://github.com/ActuallyAllie/swaycons";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ aacebedo ];
  };
}
