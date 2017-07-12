{ stdenv, lib, fetchFromGitHub, autoconf, libtool, automake, pkgconfig, git
, bison, flex, postgresql }:

let
  pname = "stellar-core";
  version = "0.5.1";

in stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "stellar";
    repo = "stellar-core";
    rev = "refs/tags/v${version}";
    sha256 = "16iszfbsrb0hwrmcdqc88asdhzdgyalvifkdrvlmnijwwjyidmx2";
    fetchSubmodules = true;
    leaveDotGit = true;
  };

  buildInputs = [ autoconf automake libtool pkgconfig git ];

  propagatedBuildInputs = [ bison flex postgresql ];

  patches = [ ./stellar-core-dirty-version.patch ];

  preConfigure = ''
    # Everything needs to be staged in git because the build uses
    # `git ls-files` to search for source files to compile.
    git add .

    ./autogen.sh
  '';

  meta = with stdenv.lib; {
    description = "Implements the Stellar Consensus Protocol, a federated consensus protocol";
    longDescription = ''
      Stellar-core is the backbone of the Stellar network. It maintains a
      local copy of the ledger, communicating and staying in sync with other
      instances of stellar-core on the network. Optionally, stellar-core can
      store historical records of the ledger and participate in consensus.
    '';
    homepage = https://www.stellar.org/;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ chris-martin ];
    license = licenses.asl20;
  };
}
