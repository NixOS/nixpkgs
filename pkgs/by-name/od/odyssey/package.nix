{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  openssl,
  libpq,
  zstd,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "odyssey";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "yandex";
    repo = "odyssey";
    rev = version;
    sha256 = "sha256-1ALTKRjpKmmFcAuhmgpcbJBkNuUlTyau8xWDRHh7gf0=";
  };

  patches = [
    # Fix compression build. Remove with the next release. https://github.com/yandex/odyssey/pull/441
    (fetchpatch {
      url = "https://github.com/yandex/odyssey/commit/01ca5b345c4483add7425785c9c33dfa2c135d63.patch";
      sha256 = "sha256-8UPkZkiI08ZZL6GShhug/5/kOVrmdqYlsD1bcqfxg/w=";
    })
    # Fixes kiwi build.
    ./fix-missing-c-header.patch
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    openssl
    libpq
    zstd
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-int -Wno-error=incompatible-pointer-types";

  cmakeFlags = [
    "-DBUILD_COMPRESSION=ON"
    "-DPOSTGRESQL_INCLUDE_DIR=${lib.getDev libpq}/include/postgresql/server"
    "-DPOSTGRESQL_LIBRARY=${libpq}/lib"
    "-DPOSTGRESQL_LIBPGPORT=${lib.getDev libpq}/lib"
  ];

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
