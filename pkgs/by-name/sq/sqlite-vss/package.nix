{ lib
, cmake
, faiss
, fetchFromGitHub
, gomp
, llvmPackages
, nlohmann_json
, sqlite
, stdenv
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sqlite-vss";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "asg017";
    repo = "sqlite-vss";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cb9UlSUAZp8B5NpNDBvJ2+ung98gjVKLxrM2Ek9fOcs=";
  };

  patches = [ ./use-nixpkgs-libs.patch ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ nlohmann_json faiss sqlite ]
    ++ lib.optional stdenv.isLinux gomp
    ++ lib.optional stdenv.isDarwin llvmPackages.openmp;

  SQLITE_VSS_CMAKE_VERSION = finalAttrs.version;

  installPhase = ''
    runHook preInstall

    install -Dm444 -t "$out/lib" \
      "libsqlite_vector0${stdenv.hostPlatform.extensions.staticLibrary}" \
      "libsqlite_vss0${stdenv.hostPlatform.extensions.staticLibrary}" \
      "vector0${stdenv.hostPlatform.extensions.sharedLibrary}" \
      "vss0${stdenv.hostPlatform.extensions.sharedLibrary}"

    runHook postInstall
  '';

  meta = with lib;{
    description = "SQLite extension for efficient vector search based on Faiss";
    homepage = "https://github.com/asg017/sqlite-vss";
    changelog = "https://github.com/asg017/sqlite-vss/releases/tag/v${finalAttrs.version}";
    license = licenses.mit;
    maintainers = with maintainers; [ elohmeier ];
    platforms = platforms.unix;
  };
})
