{ lib, stdenv, fetchFromGitHub, buildGoModule, pkg-config, libxml2, iptables, iproute2 }:

buildGoModule rec {
  pname = "nordvpn";
  version = "3.16.8";
  versionHash = "sha256-6gi9zEW3cfEWqavX5ZtVuAxhZQSEAGPY3WhByrPQ3Bw=";

  proxyVendor = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libxml2.dev
    iptables
    iproute2
  ];

  ldflags = [
    "-X main.Version=${version}"
    "-X main.Salt=${"abc123"}"
    "-X main.Environment=${"prod"}"
    "-X main.Hash=${versionHash}"
  ];

  CGO_CFLAGS = [ "-g" "-O2" "-D_FORTIFY_SOURCE=2" ];
  CGO_LDFLAGS = [ "-Wl,-z,relro,-z,now" ];

  src = fetchFromGitHub {
    owner = "NordSecurity";
    repo = "nordvpn-linux";
    rev = version;
    sha256 = versionHash;
  };

  vendorHash = "sha256-/5n5iQtEqi6Y6enjd63D5MkZucHeXgzuv4Qpj8FWYIo=";

  meta = with lib; {
    description = "CLI client for NordVPN";
    homepage = "https://nordvpn.com";
    license = lib.licenses.gpl3;
  };
}
