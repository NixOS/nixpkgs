{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  buildNpmPackage,
  makeWrapper,
  ffmpeg,
  git,
  pkg-config,
  sqlite,
  libvaSupport ? stdenv.hostPlatform.isLinux,
  libva,
  fetchpatch,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dim";
  version = "0-unstable-2025-09-21";

  src = fetchFromGitHub {
    owner = "Dusk-Labs";
    repo = "dim";
    rev = "d9a4bd0b7e985398ee4f494bf6da8884ab84b8ef";
    hash = "sha256-WktDQF2YqF/3TFnpUvz7lge8+w/W56aFjUG0v58ash4=";
  };

  frontend = buildNpmPackage {
    pname = "dim-ui";
    inherit (finalAttrs) version;
    src = "${finalAttrs.src}/ui";

    postPatch = ''
      ln -s ${./package-lock.json} package-lock.json
    '';

    npmDepsHash = "sha256-fVcx5K4r5P/pokmW31IobHSYsshB7PJOHsk6BP5dA1Q=";

    installPhase = ''
      runHook preInstall

      cp -r build $out

      runHook postInstall
    '';
  };

  cargoPatches = [
    # Bump the first‐party nightfall dependency to the latest Git
    # revision for FFmpeg >= 6 support.
    ./bump-nightfall.patch

    # Upstream has some unused imports that prevent things from compiling...
    # Remove for next release.
    (fetchpatch {
      name = "remove-unused-imports.patch";
      url = "https://github.com/Dusk-Labs/dim/commit/f62de1d38e6e52f27b1176f0dabbbc51622274cb.patch";
      hash = "sha256-Gk+RHWtCKN7McfFB3siIOOhwi3+k17MCQr4Ya4RCKjc=";
    })
  ];

  cargoHash = "sha256-NY7iw4Xq8jEBQIeJ8rqiMmIs3Z6YwfePGulpuIP5DJ0=";

  postPatch = ''
    substituteInPlace dim-core/src/lib.rs \
      --replace-fail "#![deny(warnings)]" "#![warn(warnings)]"
    substituteInPlace dim-events/src/lib.rs \
      --replace-fail "#![deny(warnings)]" "#![warn(warnings)]"
    substituteInPlace dim-database/src/lib.rs \
      --replace-fail "#![deny(warnings)]" "#![warn(warnings)]"
  '';

  postConfigure = ''
    ln -ns $frontend ui/build
  '';

  preBuild = ''
    export CARGO_TARGET_DIR=$(pwd)/target
  '';

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    git
  ];

  buildInputs = [ sqlite ] ++ lib.optional libvaSupport libva;

  buildFeatures = lib.optional libvaSupport "vaapi";

  checkFlags = [
    # Requires network
    "--skip=tmdb::tests::johhny_test_seasons"
    "--skip=tmdb::tests::once_upon_get_year"
    "--skip=tmdb::tests::tmdb_get_cast"
    "--skip=tmdb::tests::tmdb_get_details"
    "--skip=tmdb::tests::tmdb_get_episodes"
    "--skip=tmdb::tests::tmdb_get_seasons"
    "--skip=tmdb::tests::tmdb_search"
    # Broken doctest
    "--skip=dim-utils/src/lib.rs"
  ];

  postInstall = ''
    wrapProgram $out/bin/dim \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
  '';

  meta = {
    homepage = "https://github.com/Dusk-Labs/dim";
    description = "Self-hosted media manager";
    license = lib.licenses.agpl3Only;
    mainProgram = "dim";
    maintainers = [ lib.maintainers.misterio77 ];
    platforms = lib.platforms.unix;
  };
})
