{ lib, stdenv, fetchFromGitHub, fetchpatch, zlib, automake, autoconf, libtool }:

stdenv.mkDerivation rec {
  pname = "kssd";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "yhg926";
    repo = "public_kssd";
    rev = "v${version}";
    sha256 = "sha256-8jzYqo9LXF66pQ1EIusm+gba2VbTYpJz2K3NVlA3QxY=";
  };

  patches = [
    # Pull upstream patch for -fno-common toolchain support:
    #   https://github.com/yhg926/public_kssd/pull/9
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/yhg926/public_kssd/commit/cdd1e8aae256146f5913a3b4c723b638d53bdf27.patch";
      sha256 = "sha256-HhaTRqPfKR+ouh0PwEH6u22pbuqbX2OypRzw8BXm0W4=";
    })
  ];

  nativeBuildInputs = [ autoconf automake ];
  buildInputs = [ zlib libtool ];

  installPhase = ''
      install -vD kssd $out/bin/kssd
  '';

  meta = with lib; {
    description = "K-mer substring space decomposition";
    license     = licenses.asl20;
    homepage    = "https://github.com/yhg926/public_kssd";
    maintainers = with maintainers; [ unode ];
    platforms = [ "x86_64-linux" ];
  };
}
