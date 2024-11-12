# This file has been autogenerate with cabal2nix.
# Update via ./update.sh
{
  mkDerivation,
  aeson,
  base,
  bytestring,
  containers,
  directory,
  fetchgit,
  hsyslog,
  http-conduit,
  lib,
  mtl,
  network,
  network-uri,
  optparse-applicative,
  pretty-simple,
  process,
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
  version = "0.14";
  src = fetchgit {
    url = "https://github.com/pdobsan/oama.git";
    sha256 = "1hdhkc6hh4nvx31vkaii7hd2rxlwqrsvr6i1i0a9r1xlda05ffq0";
    rev = "4e1ffd3001034771d284678f0160060c1871707c";
    fetchSubmodules = true;
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson
    base
    bytestring
    containers
    directory
    hsyslog
    http-conduit
    mtl
    network
    network-uri
    optparse-applicative
    pretty-simple
    process
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
    bytestring
    containers
    directory
    hsyslog
    http-conduit
    mtl
    network
    network-uri
    optparse-applicative
    pretty-simple
    process
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
