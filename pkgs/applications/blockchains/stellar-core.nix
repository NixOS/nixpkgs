{ stdenv, fetchgit, autoconf, libtool, automake, pkgconfig, git
, bison, flex, postgresql }:

let
  pname = "stellar-core";
  version = "0.5.1";

in stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchgit {
    url = "https://github.com/stellar/stellar-core.git";
    rev = "refs/tags/v${version}";
    sha256 = "0ldw3qr0sajgam38z2w2iym0214ial6iahbzx3b965cw92n8n88z";
    fetchSubmodules = true;
    leaveDotGit = true;
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ autoconf automake libtool git ];

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
    homepage = "https://www.stellar.org/";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ chris-martin ];
    license = licenses.asl20;
  };
}
