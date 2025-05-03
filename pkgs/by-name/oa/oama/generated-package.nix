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
  version = "0.19.0";
  src = fetchgit {
    url = "https://github.com/pdobsan/oama.git";
    sha256 = "1nrgpnh76fcmkdw1j3ha5cam7bnxkgfns2plj8609qv0v0swmj4s";
    rev = "3eef17b7e290dfced252375a13bc8dd46849adf0";
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
