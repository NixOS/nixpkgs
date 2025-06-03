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
  http-types,
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
  version = "0.20.1";
  src = fetchgit {
    url = "https://github.com/pdobsan/oama.git";
    sha256 = "sha256-59tKAHL7rCZJyfraD7NnwFR5iP6784IcgH82hfsFHiA=";
    rev = "99659a8567808b28885ed241abe4df03f37e92fc";
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
    http-types
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
    http-types
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
