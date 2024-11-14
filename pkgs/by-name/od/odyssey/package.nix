{ lib, stdenv, fetchFromGitHub, cmake, openssl, postgresql, zstd, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "odyssey";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "yandex";
    repo = pname;
    rev = version;
    sha256 = "sha256-1ALTKRjpKmmFcAuhmgpcbJBkNuUlTyau8xWDRHh7gf0=";
  };

  patches = [
    # Fix compression build. Remove with the next release. https://github.com/yandex/odyssey/pull/441
    (fetchpatch {
      url = "https://github.com/yandex/odyssey/commit/01ca5b345c4483add7425785c9c33dfa2c135d63.patch";
      sha256 = "sha256-8UPkZkiI08ZZL6GShhug/5/kOVrmdqYlsD1bcqfxg/w=";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openssl postgresql zstd ];
  cmakeFlags = [ "-DPQ_LIBRARY=${postgresql.lib}/lib" "-DBUILD_COMPRESSION=ON" ];

  installPhase = ''
    install -Dm755 -t $out/bin sources/odyssey
  '';

  meta = with lib; {
    description = "Scalable PostgreSQL connection pooler";
    homepage = "https://github.com/yandex/odyssey";
    license = licenses.bsd3;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "odyssey";
  };
}
