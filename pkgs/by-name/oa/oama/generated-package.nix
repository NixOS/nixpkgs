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
  githash,
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
  version = "0.22.0";
  src = fetchgit {
    url = "https://github.com/pdobsan/oama.git";
    sha256 = "1lasr8psfsgc43in6lgaf7byvmdvanhg7idxijz504z6ga7v0pnj";
    rev = "e419ef10ca4feacf4818c5cd9bd5e617f7ee2ee7";
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
    githash
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
    githash
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
