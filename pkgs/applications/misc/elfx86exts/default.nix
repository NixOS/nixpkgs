{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "elfx86exts";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "pkgw";
    repo = pname;
    rev = "${pname}@${version}";
    sha256 = "1j9ca2lyxjsrf0rsfv83xi53vj6jz5nb76xibh367brcsc26mvd6";
  };

  cargoSha256 = "1wvsdfdldh8pmh2c00p7l6bfpxqbvg1nj256aq92v0d3hsmwszxb";

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
  };
}
