{lib, stdenv, fetchurl, fetchFromGitHub, cmake, boost179, gmp, htslib, zlib, xz, pkg-config}:

stdenv.mkDerivation rec {
  pname = "octopus";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "luntergroup";
    repo = "octopus";
    rev = "v${version}";
    sha256 = "sha256-FAogksVxUlzMlC0BqRu22Vchj6VX+8yNlHRLyb3g1sE=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ boost179 gmp htslib zlib xz ];

  patches = [ (fetchurl {
    url = "https://github.com/luntergroup/octopus/commit/17a597d192bcd5192689bf38c5836a98b824867a.patch";
    sha256 = "sha256-VaUr63v7mzhh4VBghH7a7qrqOYwl6vucmmKzTi9yAjY=";
  }) ];

  postPatch = ''
    # Disable -Werror to avoid build failure on fresh toolchains like
    # gcc-13.
    substituteInPlace lib/date/CMakeLists.txt --replace-fail ' -Werror ' ' '
    substituteInPlace lib/ranger/CMakeLists.txt --replace-fail ' -Werror ' ' '
    substituteInPlace lib/tandem/CMakeLists.txt --replace-fail ' -Werror ' ' '
    substituteInPlace src/CMakeLists.txt --replace-fail ' -Werror ' ' '

    # Fix gcc-13 build due to missing <cstdint> header.
    sed -e '1i #include <cstdint>' -i src/core/tools/vargen/utils/assembler.hpp
  '';

  postInstall = ''
    mkdir $out/bin
    mv $out/octopus $out/bin
  '';

  meta = with lib; {
    description = "Bayesian haplotype-based mutation calling";
    mainProgram = "octopus";
    license = licenses.mit;
    homepage = "https://github.com/luntergroup/octopus";
    maintainers = with maintainers; [ jbedo ];
    platforms = platforms.x86_64;
  };
}
