{ lib, stdenv, buildGoModule, fetchFromGitHub, iproute2mac }:

buildGoModule rec {
  pname = "hyprspace";
  version = "0.2.2";

  propagatedBuildInputs = lib.optional stdenv.isDarwin iproute2mac;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-UlIQCy4moW58tQ1dqxrPsU5LN1Bs/Jy5X+2CEmXdYIk=";
  };

  vendorHash = "sha256-EV59sXmjunWs+MC++CwyuBlbWzWZI1YXDLEsOaESgRU=";

  meta = with lib; {
    description = "Lightweight VPN Built on top of Libp2p for Truly Distributed Networks";
    homepage = "https://github.com/hyprspace/hyprspace";
    license = licenses.asl20;
    maintainers = with maintainers; [ yusdacra ];
    platforms = platforms.linux ++ platforms.darwin;
    broken = true; # build fails with go > 1.17
  };
}
