{ lib, stdenv, fetchurl, fetchpatch, ocamlPackages, zlib }:

stdenv.mkDerivation rec {
  pname = "mldonkey";
  version = "3.1.7-2";

  src = fetchurl {
    url = "https://ygrek.org/p/release/mldonkey/mldonkey-${version}.tar.bz2";
    sha256 = "b926e7aa3de4b4525af73c88f1724d576b4add56ef070f025941dd51cb24a794";
  };

  patches = [
    # Fixes C++17 compat
    (fetchpatch {
      url = "https://github.com/ygrek/mldonkey/pull/66/commits/20ff84c185396f3d759cf4ef46b9f0bd33a51060.patch";
      hash = "sha256-MCqx0jVfOaLkZhhv0b1cTdO6BK2/f6TxTWmx+NZjXME=";
    })
    # Fixes OCaml 4.12 compat
    (fetchpatch {
      url = "https://github.com/ygrek/mldonkey/commit/a153f0f7a4826d86d51d4bacedc0330b70fcbc34.patch";
      hash = "sha256-/Muk3mPFjQJ48FqaozGa7o8YSPhDLXRz9K1EyfxlzC8=";
    })
    # Fixes OCaml 4.14 compat
    (fetchpatch {
      url = "https://github.com/FabioLolix/AUR-artifacts/raw/6721c2d4ef0be9a99499ecf2787e378e50b915e9/mldonkey-fix-build.patch";
      hash = "sha256-HPW/CKfhywy+Km5/64Iok4tO9LJjAk53jVlsYzIRPfs=";
    })
  ];

  preConfigure = ''
    substituteInPlace Makefile --replace '+camlp4' \
      '${ocamlPackages.camlp4}/lib/ocaml/${ocamlPackages.ocaml.version}/site-lib/camlp4'
  '';

  strictDeps = true;
  nativeBuildInputs = with ocamlPackages; [ ocaml camlp4 ];
  buildInputs = (with ocamlPackages; [ num ]) ++ [ zlib ];

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Client for many p2p networks, with multiple frontends";
    homepage = "https://github.com/ygrek/mldonkey";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
  };
}
