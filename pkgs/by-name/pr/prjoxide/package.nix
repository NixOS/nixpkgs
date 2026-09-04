{
  lib,
  fetchFromGitHub,
  rustPlatform,
  python3,
}:

rustPlatform.buildRustPackage rec {
  pname = "prjoxide";
  version = "0.1-unstable-2026-07-19";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gatecat";
    repo = "prjoxide";
    rev = "ea3fe12094dec200afcecdf9ed3306f82e6e3eb2";
    hash = "sha256-qnfjiN+gd2zc/7uuySc8KlLnp/vmTbiF0s379GH7g4M=";
    fetchSubmodules = true;
    leaveDotGit = true;
    postFetch = "rm -rf $out/.git";
  };

  sourceRoot = "${src.name}/libprjoxide";

  cargoPatches = [ ./fix-cargo-lock.patch ];

  cargoHash = "sha256-+KCoH1ibHAGdD66r/kbLK1HCkKot1VmxNnbcpR8QRbA=";

  # The cargo build fails during the check phase due to not
  # Being able to find python symbols. This fixes it
  env.RUSTFLAGS = "-l python${python3.pythonVersion}";

  nativeBuildInputs = [ python3 ];

  buildInputs = [ python3 ];

  doCheck = true;

  strictDeps = true;

  meta = {
    description = "Documentation and tools for Lattice 28nm FPGA parts";
    longDescription = ''
      Project Oxide aims at creating a framework to place
      parse and fuzz bitstreams for Lattice 28nm FPGA parts.
    '';
    homepage = "https://github.com/gatecat/prjoxide";
    license = lib.licenses.isc;
    mainProgram = "prjoxide";
    maintainers = with lib.maintainers; [ gitRaiku ];
    platforms = lib.platforms.all;
  };
}
