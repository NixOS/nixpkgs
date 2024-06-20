{ lib, stdenv, fetchFromGitHub, fetchpatch, zlib }:

stdenv.mkDerivation rec {
  pname = "bowtie";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "BenLangmead";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mWItmrTMPst/NnzSpxxTHcBztDqHPCza9yOsZPwp7G4=";
  };

  patches = [
    # Without this patch, compiling with clang on an M1 Mac fails because
    # 'cpuid.h' is included. It only works on x86 and throws an error.
    (fetchpatch {
      name = "fix_compilation_on_arm64";
      url = "https://github.com/BenLangmead/bowtie/commit/091d72f4cb69ca0713704d38bd7f9b37e6c4ff2d.patch";
      sha256 = "sha256-XBvgICUBnE5HKpJ36IHTDiKjJgLFKETsIaJC46uN+2I=";
    })

    # Without this patch, compilation adds the current source directory to the
    # include search path, and #include <version> in standard library code can
    # end up picking the unrelated VERSION source code file on case-insensitive
    # file systems.
    (fetchpatch {
      name = "fix_include_search_path";
      url = "https://github.com/BenLangmead/bowtie/commit/c208b9db936eab0bc3ffdf0182b4f59a9017a1c4.patch";
      sha256 = "sha256-772EE+oWFWXssSMabPryb0AfIS1tC10mPTRCBm7RrUs=";
    })
  ];

  buildInputs = [ zlib ];

  installFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    description = "Ultrafast memory-efficient short read aligner";
    license = licenses.artistic2;
    homepage = "https://bowtie-bio.sourceforge.net";
    maintainers = with maintainers; [ prusnak ];
    platforms = platforms.all;
  };
}
