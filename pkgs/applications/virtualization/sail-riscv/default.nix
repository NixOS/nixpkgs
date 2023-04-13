{ stdenv
, fetchFromGitHub
, lib
, arch
, ocamlPackages
, ocaml
, zlib
, z3
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

  nativeBuildInputs = with ocamlPackages; [ ocamlbuild findlib ocaml z3 sail ];
  buildInputs = with ocamlPackages; [ zlib linksem ];
  strictDeps = true;

  postPatch = ''
    rm -r prover_snapshots
  '';

  makeFlags = [
    "SAIL=sail"
    "ARCH=${arch}"
    "SAIL_DIR=${ocamlPackages.sail}/share/sail"
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
    description = "A formal specification of the RISC-V architecture, written in Sail";
    maintainers = with maintainers; [ genericnerdyusername ];
    license = licenses.bsd2;
  };
}
