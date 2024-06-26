{
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  lib,
  arch,
  ocamlPackages,
  ocaml,
  zlib,
  z3,
}:

stdenv.mkDerivation rec {
  pname = "sail-riscv";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "riscv";
    repo = pname;
    rev = version;
    hash = "sha256-7PZNNUMaCZEBf0lOCqkquewRgZPooBOjIbGF7JlLnEo=";
  };

  nativeBuildInputs = with ocamlPackages; [
    ocamlbuild
    findlib
    ocaml
    z3
    sail
  ];
  buildInputs = with ocamlPackages; [
    zlib
    linksem
  ];
  strictDeps = true;

  patches = [
    (fetchpatch {
      url = "https://github.com/riscv/sail-riscv/pull/250/commits/8bd37c484b83a8ce89c8bb7a001b8ae34dc4d77f.patch";
      hash = "sha256-tDgkGhcbT6phoCAvilxMI56YUuUqQFgvh+2QduOjdMg=";
    })
  ];

  postPatch =
    ''
      rm -r prover_snapshots
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace Makefile --replace "-flto" ""
    '';

  makeFlags = [
    "SAIL=sail"
    "ARCH=${arch}"
    "SAIL_DIR=${ocamlPackages.sail}/share/sail"
    "LEM_DIR=${ocamlPackages.sail}/share/lem"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp c_emulator/riscv_sim_${arch} $out/bin
    mkdir $out/share/
    cp -r generated_definitions/{coq,hol4,isabelle} $out/share/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/riscv/sail-riscv";
    description = "Formal specification of the RISC-V architecture, written in Sail";
    maintainers = with maintainers; [ genericnerdyusername ];
    broken = stdenv.isDarwin && stdenv.isAarch64;
    license = licenses.bsd2;
  };
}
