{ stdenv, lib, buildGoModule, fetchFromGitHub }:

let
  pname = "erigon";
  version = "2021.06.03";

  # this derivation uses the makefile to build mdbx-static.o and put in the
  # right place for the standard gomodules build to succeed.
  prepare-mdbx = stdenv.mkDerivation {
    inherit pname version;
    src = fetchFromGitHub {
      owner = "ledgerwatch";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-Y7qsPrH9ZZD2QDmguefs7S1q+YANl5u3WdpNtcnuRsI=";
    };
    buildPhase = ''
      make mdbx
    '';
    installPhase = ''
      mkdir -p $out
      cp -r /build/source/* $out
    '';
  };
in

buildGoModule rec {
  inherit pname version;
  src = prepare-mdbx;

  vendorSha256 = "1nlgby1vv23a0abgd85wdywx01v7a0i6i1797hhwazvsrm1lphb0";
  runVend = true;

  # Build errors in mdbx when format hardening is enabled:
  #   cc1: error: '-Wformat-security' ignored without '-Wformat' [-Werror=format-security]
  hardeningDisable = [ "format" ];

  subPackages = [
    "cmd/erigon"
    "cmd/evm"
    "cmd/rpcdaemon"
    "cmd/rlpdump"
  ];

  meta = with lib; {
    homepage = "https://github.com/ledgerwatch/erigon/";
    description = "Ethereum node implementation focused on scalability and modularity";
    license = with licenses; [ lgpl3Plus gpl3Plus ];
    maintainers = with maintainers; [ xwvvvvwx ];
  };
}
