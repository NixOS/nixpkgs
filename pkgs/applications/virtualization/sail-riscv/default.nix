{ stdenv
, fetchFromGitHub

, arch

, ocamlPackages
, ncurses
, ocaml
, zlib
, z3
}:


stdenv.mkDerivation rec {
  pname = "sail-riscv";
  version = "0.5";

  nativeBuildInputs = with ocamlPackages; [ sail ocamlbuild findlib ncurses ocaml zlib.dev z3 ];

  src = fetchFromGitHub {
    owner = "riscv";
    repo = pname;
    rev = version;
    hash = "sha256-7PZNNUMaCZEBf0lOCqkquewRgZPooBOjIbGF7JlLnEo=";
  };

  ARCH = arch;

  outputs = [ "out" "ocaml_emu" "isabelle_model" "coq_model" "hol4_model" ];

  preConfigure = "sed 's/^SAIL:=$(/SAIL:=sail #/' -i Makefile";

  SAIL_DIR = "${ocamlPackages.sail}/share/sail";
  SAIL = "sail";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp c_emulator/riscv_sim_${arch} $out/bin
    mkdir -p $ocaml_emu/bin
    cp ocaml_emulator/riscv_ocaml_sim_${arch} $ocaml_emu/bin
    cp -r generated_definitions/coq/ $coq_model
    cp -r generated_definitions/isabelle/ $isabelle_model
    cp -r generated_definitions/hol4/ $hol4_model
    runHook postInstall
  '';
}
