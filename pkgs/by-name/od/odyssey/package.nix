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

stdenv.mkDerivation (finalAttrs: {
  pname = "odyssey";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "yandex";
    repo = "odyssey";
    rev = "v${finalAttrs.version}";
    hash = "sha256-70h8JJH9+2xmgrADz106DNBLGUH0gnvatoeAbD03eKY=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/yandex/odyssey/commit/51c0e777aa45157f4f03fbd036113ce6d11ca41f.patch?full_index=1";
      hash = "sha256-yytyA2K62v7XwJQ+WJnBGh87AVyeOv0cuzlQ7oYnhFg=";
    })

    # fix build w/ glibc-2.44
    (fetchpatch {
      url = "https://github.com/yandex/odyssey/commit/1edf6bfd05dc34324162fda1b4ca4bc38b1b581c.patch";
      hash = "sha256-Rd/dqmvpY2gJMqg3hX5rXMu3vRjOG5V3QXV/S1M625Q=";
    })
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

  meta = {
    description = "Scalable PostgreSQL connection pooler";
    homepage = "https://github.com/yandex/odyssey";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "odyssey";
  };
})
