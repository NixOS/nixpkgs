{ lib, stdenv, buildGoModule, fetchFromGitHub, iproute2mac }:

buildGoModule rec {
  pname = "hyprspace";
  version = "0.1.5";

  propagatedBuildInputs = lib.optional stdenv.isDarwin iproute2mac;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-aLODIaDbSLVEog/F0FVx6ykadCggE0Vebzwjw0sqYJ0=";
  };

  vendorSha256 = "sha256-rw75xNBBV58F+HBVtD/EslPWxZxLbI3/mJVdJF4usKI=";

  meta = with lib; {
    description = "A Lightweight VPN Built on top of Libp2p for Truly Distributed Networks.";
    homepage = "https://github.com/hyprspace/hyprspace";
    license = licenses.asl20;
    maintainers = with maintainers; [ yusdacra ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
