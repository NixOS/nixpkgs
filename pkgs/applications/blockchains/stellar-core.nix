{ lib, stdenv, fetchFromGitHub, autoconf, libtool, automake, pkg-config, git
, bison, flex, postgresql, ripgrep }:

stdenv.mkDerivation rec {
  pname = "stellar-core";
  version = "17.0.0";

  src = fetchFromGitHub {
    owner = "stellar";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ngl8yjqb8xzhdwzlxzzxf14q2hgwy2ysb17sn5380rrn0jswin1";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ automake autoconf git libtool pkg-config ripgrep ];

  propagatedBuildInputs = [ bison flex postgresql ];

  preConfigure = ''
    # Due to https://github.com/NixOS/nixpkgs/issues/8567 we cannot rely on
    # having the .git directory present, so directly provide the version
    substituteInPlace src/Makefile.am --replace '$$vers' '${pname} ${version}';

    # Everything needs to be staged in git because the build uses
    # `git ls-files` to search for source files to compile.
    git init
    git add .

    ./autogen.sh
  '';

  meta = with lib; {
    description = "Implements the Stellar Consensus Protocol, a federated consensus protocol";
    longDescription = ''
      Stellar-core is the backbone of the Stellar network. It maintains a
      local copy of the ledger, communicating and staying in sync with other
      instances of stellar-core on the network. Optionally, stellar-core can
      store historical records of the ledger and participate in consensus.
    '';
    homepage = "https://www.stellar.org/";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ ];
    license = licenses.asl20;
  };
}
