{
  lib,
  stdenv,
  autoconf,
  automake,
  bison,
  fetchFromGitHub,
  flex,
  gitMinimal,
  libpq,
  libtool,
  libunwind,
  pkg-config,
  ripgrep,
  rustPlatform,
  cargo,
  rustc,
  perl,
}:

let
  p21 = rustPlatform.buildRustPackage {
    pname = "rs-soroban-env";
    version = "21.2.2";

    src = fetchFromGitHub {
      owner = "stellar";
      repo = "rs-soroban-env";
      rev = "7eeddd897cfb0f700f938b0c8d6f0541150d1fcb";
      hash = "sha256-jM/4rYaLdYLdD88cq3dJYOZeZbSiTjyLjv6wGfrX3PI=";
      leaveDotGit = true;
    };

    useFetchCargoVendor = true;
    cargoHash = "sha256-cUhi2YennW+tukwf0woP69bqf1ZMsQ4JDeNqpk0jYjg=";

    nativeBuildInputs = [ gitMinimal ];

    installPhase = ''
      runHook preInstall

      cp -r target $out
      cp -rf target/*-*/release/* $out/release

      runHook postInstall
    '';

    meta = {
      description = "Rust environment for Soroban contracts";
      homepage = "https://github.com/stellar/rs-soroban-env";
      license = lib.licenses.asl20;
      platforms = lib.platforms.linux;
    };
  };
  p22 = rustPlatform.buildRustPackage {
    pname = "rs-soroban-env";
    version = "22.0.0";

    src = fetchFromGitHub {
      owner = "stellar";
      repo = "rs-soroban-env";
      rev = "1cd8b8dca9aeeca9ce45b129cd923992b32dc258";
      hash = "sha256-DHcDzWN2ENv4zaVvIBP3qvUCec+cKPgb/9xsW+20cfg=";
      leaveDotGit = true;
    };

    useFetchCargoVendor = true;
    cargoHash = "sha256-5mNAblS3TYXu5a1ThmIdbKC9hUg/3F8vUPvFex3G58U=";

    nativeBuildInputs = [ gitMinimal ];

    installPhase = ''
      runHook preInstall

      cp -r target $out
      cp -rf target/*-*/release/* $out/release

      runHook postInstall
    '';

    meta = {
      description = "Rust environment for Soroban contracts";
      homepage = "https://github.com/stellar/rs-soroban-env";
      license = lib.licenses.asl20;
      platforms = lib.platforms.linux;
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "stellar-core";
  version = "22.1.0";

  src = fetchFromGitHub {
    owner = "stellar";
    repo = "stellar-core";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zrstzJ9Zy1ftFFu+vSMbPpfX6FipIG2blazkZLwTMgc=";
    fetchSubmodules = true;
  };

  patches = [
    # add cxxbridge-cmd
    ./cargo.patch
    ./Makefile.patch
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    # add cxxbridge-cmd
    patches = [ ./cargo.patch ];
    hash = "sha256-N5srZDD+J17k3pGgK4sNWm46Sgav/4/5b9G/K0UUK00=";
  };

  nativeBuildInputs = [
    automake
    autoconf
    gitMinimal
    libtool
    pkg-config
    ripgrep
    rustPlatform.cargoSetupHook
    cargo
    rustc
    perl
  ];

  buildInputs = [ libunwind ];

  propagatedBuildInputs = [
    bison
    flex
    libpq
  ];

  enableParallelBuilding = true;

  preConfigure = ''
    patchShebangs .
    ln -s ${p21} src/rust/soroban/p21/target
    ln -s ${p22} src/rust/soroban/p22/target
    export CARGO_HOME=$PWD/.cargo
    # Due to https://github.com/NixOS/nixpkgs/issues/8567 we cannot rely on
    # having the .git directory present, so directly provide the version
    substituteInPlace src/Makefile.am \
      --replace-fail '$$vers' 'stellar-core ${finalAttrs.version}';

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
