{ stdenv, fetchFromGitHub, zlib }:

stdenv.mkDerivation rec {
  pname    = "megahit";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "voutcn";
    repo = "megahit";
    rev = "v${version}";
    sha256 = "011k0776w76l03zmy70kfd3y9zjmdnspfbs9fcxmnl3bdwd36kcw";
  };

  buildInputs = [ zlib ];

  installPhase = ''
    for bin in megahit_sdbg_build megahit megahit_asm_core megahit_toolkit; do
        install -vD $bin $out/bin/$bin
    done
  '';

  meta = with stdenv.lib; {
    description = "An ultra-fast single-node solution for large and complex metagenomics assembly via succinct de Bruijn graph";
    license     = licenses.gpl3;
    homepage    = https://github.com/voutcn/megahit;
    maintainers = with maintainers; [ luispedro ];
    platforms = [ "x86_64-linux" ];
  };
}
