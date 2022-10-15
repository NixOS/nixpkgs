{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "elfx86exts";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "pkgw";
    repo = pname;
    rev = "${pname}@${version}";
    sha256 = "sha256-SDBs5/jEvoKEVKCHQLz2z+CZSSmESP7LoIITRN4qJWA=";
  };

  cargoSha256 = "sha256-fYtFRdH6U8uWshdD1Pb1baE8slo6qajx10tDK3Ukknw=";

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
