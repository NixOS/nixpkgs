{ lib, stdenv, buildGoModule, fetchFromGitHub, iproute2mac }:

buildGoModule rec {
  pname = "hyprspace";
  version = "0.1.7";

  propagatedBuildInputs = lib.optional stdenv.isDarwin iproute2mac;

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Ecdxs6see4uexY6DatZ/VSGgWR81zRjo3AeAsXSjJ4A=";
  };

  vendorSha256 = "sha256-nFiBHhtvTu9Ya6n1KUF+pOXrksHMOph7ABVtGSWVWlo=";

  meta = with lib; {
    description = "A Lightweight VPN Built on top of Libp2p for Truly Distributed Networks.";
    homepage = "https://github.com/hyprspace/hyprspace";
    license = licenses.asl20;
    maintainers = with maintainers; [ yusdacra ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
