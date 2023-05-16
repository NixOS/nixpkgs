<<<<<<< HEAD
{ autoconf
, automake
, bison
, fetchFromGitHub
, flex
, git
, lib
, libtool
, libunwind
, pkg-config
, postgresql
, ripgrep
, stdenv
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stellar-core";
  version = "19.13.0";

  src = fetchFromGitHub {
    owner = "stellar";
    repo = "stellar-core";
    rev = "v${finalAttrs.version}";
    hash = "sha256-C775tL+x1IX4kfCM/7gOg/V8xunq/rkhIfdkwkhLENk=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    automake
    autoconf
    git
    libtool
    pkg-config
    ripgrep
  ];

  buildInputs = [
    libunwind
  ];

  propagatedBuildInputs = [
    bison
    flex
    postgresql
  ];
=======
{ lib, stdenv, fetchFromGitHub, autoconf, libtool, automake, pkg-config, git
, bison, flex, postgresql, ripgrep, libunwind }:

stdenv.mkDerivation rec {
  pname = "stellar-core";
  version = "19.10.0";

  src = fetchFromGitHub {
    owner = "stellar";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BcZsj2TbeJW91aiZ2I7NbDa+rgjfs6lQUsWOnhFQXtw=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ automake autoconf git libtool pkg-config ripgrep ];

  buildInputs = [ libunwind ];

  propagatedBuildInputs = [ bison flex postgresql ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  enableParallelBuilding = true;

  preConfigure = ''
    # Due to https://github.com/NixOS/nixpkgs/issues/8567 we cannot rely on
    # having the .git directory present, so directly provide the version
<<<<<<< HEAD
    substituteInPlace src/Makefile.am --replace '$$vers' 'stellar-core ${finalAttrs.version}';
=======
    substituteInPlace src/Makefile.am --replace '$$vers' '${pname} ${version}';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    # Everything needs to be staged in git because the build uses
    # `git ls-files` to search for source files to compile.
    git init
    git add .

    ./autogen.sh
  '';

<<<<<<< HEAD
  meta = {
    description = "Implements the Stellar Consensus Protocol, a federated consensus protocol";
    homepage = "https://www.stellar.org/";
    license = lib.licenses.asl20;
=======
  meta = with lib; {
    description = "Implements the Stellar Consensus Protocol, a federated consensus protocol";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    longDescription = ''
      Stellar-core is the backbone of the Stellar network. It maintains a
      local copy of the ledger, communicating and staying in sync with other
      instances of stellar-core on the network. Optionally, stellar-core can
      store historical records of the ledger and participate in consensus.
    '';
<<<<<<< HEAD
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
=======
    homepage = "https://www.stellar.org/";
    platforms = platforms.linux;
    maintainers = with maintainers; [ ];
    license = licenses.asl20;
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
