{
  autoconf,
  automake,
  bison,
  fetchFromGitHub,
  fetchpatch,
  flex,
  git,
  lib,
  libtool,
  libunwind,
  pkg-config,
  postgresql,
  ripgrep,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stellar-core";
  version = "19.14.0";

  src = fetchFromGitHub {
    owner = "stellar";
    repo = "stellar-core";
    rev = "v${finalAttrs.version}";
    hash = "sha256-lxBn/T01Tsa7tid3mRJUigUwv9d3BAPZhV9Mp1lywBU=";
    fetchSubmodules = true;
  };

  patches = [
    # Fix gcc-13 build failure due to missing <stdexcept> include
    #   https://github.com/stellar/medida/pull/34
    (fetchpatch {
      name = "gcc-13-p1.patch";
      url = "https://github.com/stellar/medida/commit/f91354b0055de939779d392999975d611b1b1ad5.patch";
      stripLen = 1;
      extraPrefix = "lib/libmedida/";
      hash = "sha256-iVeSUY5Rcy62apIKJdbcHGgxAxpQCkygf85oSjbTTXU=";
    })
    (fetchpatch {
      name = "gcc-13-p2.patch";
      url = "https://github.com/stellar/stellar-core/commit/477b3135281b629554cabaeacfcdbcdc170aa335.patch";
      hash = "sha256-UVRcAIA5LEaCn16lWfhg19UU7b/apigzTsfPROLZtYg=";
    })
  ];

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

  enableParallelBuilding = true;

  preConfigure = ''
    # Due to https://github.com/NixOS/nixpkgs/issues/8567 we cannot rely on
    # having the .git directory present, so directly provide the version
    substituteInPlace src/Makefile.am --replace '$$vers' 'stellar-core ${finalAttrs.version}';

    # Everything needs to be staged in git because the build uses
    # `git ls-files` to search for source files to compile.
    git init
    git add .

    ./autogen.sh
  '';

  meta = {
    description = "Implements the Stellar Consensus Protocol, a federated consensus protocol";
    homepage = "https://www.stellar.org/";
    license = lib.licenses.asl20;
    longDescription = ''
      Stellar-core is the backbone of the Stellar network. It maintains a
      local copy of the ledger, communicating and staying in sync with other
      instances of stellar-core on the network. Optionally, stellar-core can
      store historical records of the ledger and participate in consensus.
    '';
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "stellar-core";
  };
})
