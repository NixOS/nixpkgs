# This file has been autogenerate with cabal2nix.
# Update via ./update.sh
{
  mkDerivation,
  aeson,
  base,
  base64-bytestring,
  bytestring,
  containers,
  cryptohash-sha256,
  directory,
  fetchgit,
  hsyslog,
  http-conduit,
  http-types,
  lib,
  mtl,
  network,
  network-uri,
  optparse-applicative,
  pretty-simple,
  process,
  random,
  streaming-commons,
  string-qq,
  strings,
  text,
  time,
  twain,
  unix,
  utf8-string,
  warp,
  yaml,
}:
mkDerivation {
  pname = "oama";
  version = "0.20.2";
  src = fetchgit {
    url = "https://github.com/pdobsan/oama.git";
    sha256 = "1zr2a77b3azdqyk6hzchhg573gwwb5h0d7x382srggm25lp3isk9";
    rev = "bbe5a6d9f87659c8a24b6515694acf1b522a396b";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson
    base
    base64-bytestring
    bytestring
    containers
    cryptohash-sha256
    directory
    hsyslog
    http-conduit
    http-types
    mtl
    network
    network-uri
    optparse-applicative
    pretty-simple
    process
    random
    streaming-commons
    string-qq
    strings
    text
    time
    twain
    unix
    utf8-string
    warp
    yaml
  ];
  executableHaskellDepends = [
    aeson
    base
    base64-bytestring
    bytestring
    containers
    cryptohash-sha256
    directory
    hsyslog
    http-conduit
    http-types
    mtl
    network
    network-uri
    optparse-applicative
    pretty-simple
    process
    random
    streaming-commons
    string-qq
    strings
    text
    time
    twain
    unix
    utf8-string
    warp
    yaml
  ];
  license = lib.licenses.bsd3;
  mainProgram = "oama";
}
