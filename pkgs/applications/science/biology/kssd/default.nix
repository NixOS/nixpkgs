{ lib, stdenv, fetchFromGitHub, fetchpatch, zlib, automake, autoconf, libtool }:

stdenv.mkDerivation rec {
  pname = "kssd";
  version = "2.21";

  src = fetchFromGitHub {
    owner = "yhg926";
    repo = "public_kssd";
    rev = "v${version}";
    hash = "sha256-D/s1jL2oKE0rSdRMVljskYFsw5UPOv1L95Of+K+e17w=";
  };

  patches = [
    # https://github.com/yhg926/public_kssd/pull/11
    (fetchpatch {
      name = "allocate-enough-memory.patch";
      url = "https://github.com/yhg926/public_kssd/commit/b1e66bbcc04687bc3201301cd742a0b26a87cb5d.patch";
      hash = "sha256-yFyJetpsGKeu+H6Oxrmn5ea4ESVtblb3YJDja4JEAEM=";
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
