{ lib, stdenv, buildGoModule, fetchFromGitHub, iproute2mac }:

buildGoModule rec {
  pname = "hyprspace";
  version = "0.1.2";

  propagatedBuildInputs = lib.optional stdenv.isDarwin iproute2mac;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YQJaK6i4GWEGSlf/1+hzjVhdN6ZjZC55v8w9KEedNg4=";
  };

  vendorSha256 = "sha256-ErqK2jDTpqUyvll+epdGKRYCJvyvCa90W1GVbbhF0a4=";

  meta = with lib; {
    description = "A Lightweight VPN Built on top of Libp2p for Truly Distributed Networks.";
    homepage = "https://github.com/hyprspace/hyprspace";
    license = licenses.asl20;
    maintainers = with maintainers; [ yusdacra ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
