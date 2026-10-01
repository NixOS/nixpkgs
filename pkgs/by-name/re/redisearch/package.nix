{
  boost,
  cargo,
  cctools,
  cmake,
  fetchFromGitHub,
  lib,
  libxcrypt,
  nix-update-script,
  openssl,
  redis,
  rustPlatform,
  stdenv,
  vectorsimilarity,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "redisearch";
  version = "8.8.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "RediSearch";
    repo = "RediSearch";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-Wc7KHCoK2LUXvH8kQkGhABfsZd+hw/Nq9aLDKD9gNjQ=";
    leaveDotGit = true;
    postFetch = ''
      # Fetcher fails to remove the `.git/modules` directory due it
      # not being empty after all submodules have been initialized.
      rm -rf $out/.git

      # Remove unused submodules for legal compliance.
      rm -rf $out/deps/{googletest,VectorSimilarity}
    '';
  };

  cargoRoot = "src/redisearch_rs";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) cargoRoot src;
    hash = "sha256-YnlIOHRRBSan6uPVR9oYs9epRSLWKDXsKl0GmMWsc2s=";
  };

  patches = [
    ./external-libs.patch
    ./devendor-vectorsimilarity.patch
  ];

  makeFlags = [
    "IGNORE_MISSING_DEPS=1"
  ];

  dontUseCmakeConfigure = true;

  postPatch = ''
    # RediSearch needs a `.git` file to find the git root.
    touch .git

    patchShebangs build.sh
  '';

  nativeBuildInputs = [
    cargo
    cmake
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
  ]
  # Required for creating the combined library on darwin.
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ cctools.libtool ];

  buildInputs = [
    boost
    libxcrypt
    openssl
    vectorsimilarity
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp bin/*/*/*.so $out/lib

    runHook postInstall
  '';

  # Try to keep redis modules in sync with the version of redis.
  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=${redis.version}" ];
  };

  meta = {
    description = "Query and indexing engine for Redis";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.all;
    teams = [ lib.teams.redis ];
  };
})
