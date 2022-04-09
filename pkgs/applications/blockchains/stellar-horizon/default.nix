#with import <nixpkgs> {};

{ lib, stdenv, buildGoModule, fetchFromGitHub }:

let
  # A list of binaries to put into separate outputs
  bins = [
    "horizon"
  ];

in buildGoModule rec {
  pname = "stellar-horizon";
  version = "2.16.0";

  src = fetchFromGitHub {
    owner = "stellar";
    repo = "go";
    rev = "horizon-v${version}";
    sha256 = "sha256-5Q2H+z+1JoDeoMTyczJfLul4k/wyB1mv/Q3tICdMaE8=";
  };

  vendorSha256 = "sha256-Vrfc4nrUjoP2xOXZW1QBBktAQdD1ksCN6Ye86l+Y9Uo=";
  proxyVendor = true;

  outputs = [ "out" ] ++ bins;

  # Move binaries to separate outputs and symlink them back to $out
  postInstall = lib.concatStringsSep "\n" (
    builtins.map (bin: "mkdir -p \$${bin}/bin && mv $out/bin/${bin} \$${bin}/bin/ && ln -s \$${bin}/bin/${bin} $out/bin/") bins
  );

  ldflags = [ "-X github.com/stellar/go/support/app.version=${version}" ];

  subPackages = [
    "services/horizon"
  ];

  meta = with lib; {
    homepage = "https://stellar.org/";
    description = "Client facing API server for the Stellar ecosystem.";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
