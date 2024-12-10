{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "elfx86exts";
  version = "unstable-2023-04-20";

  src = fetchFromGitHub {
    owner = "pkgw";
    repo = pname;
    rev = "26bf98cf1fc773196e594c48bfe808d7151076f6";
    hash = "sha256-xNmaKGbMN92CPIQQRbdmeePk5Wt9XcIsB/2vbk5NJzg=";
  };

  cargoHash = "sha256-NH7QK8a+ndhZGlLa3gWlnQdBQil1pi2AAi5TtFgkVf0=";

  meta = with lib; {
    description = "Decode x86 binaries and print out which instruction set extensions they use.";
    longDescription = ''
      Disassemble a binary containing x86 instructions and print out which extensions it uses.
      Despite the utterly misleading name, this tool supports ELF and MachO binaries, and
      perhaps PE-format ones as well. (It used to be more limited.)
    '';
    homepage = "https://github.com/pkgw/elfx86exts";
    maintainers = with maintainers; [ rmcgibbo ];
    license = with licenses; [ mit ];
    mainProgram = "elfx86exts";
  };
}
