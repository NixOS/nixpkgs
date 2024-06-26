{lib, stdenv, z3, cmake}:
stdenv.mkDerivation rec {
  pname = "z3-tptp";
  version = z3.version;

  src = z3.src;

  sourceRoot = "${src.name}/examples/tptp";

  nativeBuildInputs = [cmake];
  buildInputs = [z3];

  preConfigure = ''
    echo 'set(Z3_LIBRARIES "-lz3")' >> CMakeLists.new
    cat CMakeLists.txt | grep -E 'add_executable|project|link_libraries' >> CMakeLists.new
    mv CMakeLists.new CMakeLists.txt
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    cp "z3_tptp5" "$out/bin/"
    ln -s "z3_tptp5" "$out/bin/z3-tptp"
  '';

  meta = {
    inherit (z3.meta) license homepage platforms;
    description = "TPTP wrapper for Z3 prover";
    maintainers = [lib.maintainers.raskin];
  };
}
