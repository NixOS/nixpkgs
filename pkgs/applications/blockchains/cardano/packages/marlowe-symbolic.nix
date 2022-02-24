{ mkDerivation, aeson, base, clock, containers, deriving-aeson
, fetchgit, formatting, http-client, http-client-tls, lib, marlowe
, plutus-ledger, plutus-tx, process, servant, servant-client
, servant-server, template-haskell, text, utf8-string, wl-pprint
}:
mkDerivation {
  pname = "marlowe-symbolic";
  version = "0.3.0.0";
  src = fetchgit {
    url = "https://github.com/input-output-hk/plutus/";
    sha256 = "1jicyk4hr8p0xksj4048gdxndrb42jz4wsnkhc3ymxbm5v6snalf";
    rev = "1efbb276ef1a10ca6961d0fd32e6141e9798bd11";
    fetchSubmodules = true;
  };
  postUnpack = "sourceRoot+=/marlowe-symbolic; echo source root reset to $sourceRoot";
  libraryHaskellDepends = [
    aeson base clock containers deriving-aeson formatting http-client
    http-client-tls marlowe plutus-ledger plutus-tx process servant
    servant-client servant-server template-haskell text utf8-string
    wl-pprint
  ];
  license = lib.licenses.bsd3;
}
