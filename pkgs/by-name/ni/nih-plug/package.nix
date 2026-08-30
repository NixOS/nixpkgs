{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  alsa-lib,
  libjack2,
  libGL,
  libxkbcommon,
  libx11,
  libxcursor,
  libxcb,
  libxcb-wm,
  python3,
}:

# NIH-plug is split into two things:
#
#   * a Rust audio-plugin framework (the `nih_plug*` library crates), and
#   * a collection of end-user CLAP/VST3 plugins in `plugins/` built on top of
#     it (Buffr Glitch, Crisp, Loudness War Winner,
#     Puberty Simulator, Safety Limiter, Soft Vacuum, Spectral Compressor).
#
# Only the second is packageable in nixpkgs — the framework is consumed by
# downstream plugin authors via Cargo, not installed system-wide. This
# derivation builds every plugin listed in upstream's `bundler.toml` and
# installs the resulting bundles to the standard Linux locations under
# `$out/lib/{clap,vst3}` so they're discovered by hosts when the package is
# in the user environment.

rustPlatform.buildRustPackage rec {
  pname = "nih-plug";
  # Upstream does not tag releases. Use the `0-unstable-<date>` convention so
  # the version compares lower than any future tagged release.
  version = "0-unstable-2026-05-10";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "robbert-vdh";
    repo = "nih-plug";
    rev = "f36931f7af4646065488a9845d8f8c2f95252c23";
    hash = "sha256-Jvd1RHs2VXzHN8Koj+JS1bcbGMSA30g2e3i8lhGjGlc=";
  };

  # `cargoLock.outputHashes` would have to be used here because the lockfile
  # pins several crates by git rev. However, the lockfile contains four
  # different revs of `baseview` all at version 0.1.0, and `importCargoLock`
  # keys hashes by `<name>-<version>` — so it cannot represent more than one
  # rev per name. The `fetchCargoVendor` path (default since 25.05) does not
  # have this limitation: it produces one combined vendor directory hash.
  cargoHash = "sha256-d89GZf9cwSlqdC/q3xMHh8ehDiOhuiZAI0/ygKQHuqc=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    python3
  ];

  buildInputs = [
    alsa-lib # cpal (pulled in by the `standalone` feature) and midir
    libjack2 # `jack` crate (also from the `standalone` feature)
    libGL # baseview / nih_plug_egui & friends
    libxkbcommon
    libx11
    libxcursor
    libxcb
    libxcb-wm
  ];

  # Only the production plugins are listed in upstream's `bundler.toml`. The
  # `plugins/examples/*` crates exist for documentation and are deliberately
  # excluded. Keep this list in sync with `bundler.toml`.
  bundlePackages = [
    "buffr_glitch"
    "crisp"
    "loudness_war_winner"
    "puberty_simulator"
    "safety_limiter"
    "soft_vacuum"
    "spectral_compressor"
  ];

  # `cargo xtask bundle` is a workspace alias for running the in-tree `xtask`
  # binary, which itself invokes `cargo build --release -p <package>` for each
  # named plugin and then assembles the resulting cdylibs into CLAP/VST3
  # bundle layouts under `target/bundled/`. We invoke the alias directly so
  # buildRustPackage's offline cargo environment is inherited by the nested
  # build.
  buildPhase = ''
    runHook preBuild

    cargoBuildArgs=( )
    for p in ${lib.escapeShellArgs bundlePackages}; do
      cargoBuildArgs+=( -p "$p" )
    done

    cargo run \
      --frozen \
      --offline \
      --release \
      --package xtask -- \
      bundle "''${cargoBuildArgs[@]}" --release

    runHook postBuild
  '';

  # The plugins themselves are audio-processing libraries; there is nothing
  # meaningful to run as `cargo test` at the workspace level for the bundled
  # outputs, and several workspace members would pull in heavy GUI toolkits
  # for no benefit. Upstream's own CI does not run tests as part of the
  # packaging job either.
  doCheck = false;

  installPhase = ''
    runHook preInstall

    install -d "$out/lib/clap" "$out/lib/vst3"

    # CLAP plugins are single `.clap` shared objects.
    find target/bundled -maxdepth 1 -type f -name '*.clap' \
      -exec install -Dm644 -t "$out/lib/clap" {} +

    # VST3 plugins are directory bundles. On Linux the layout is
    # `Foo.vst3/Contents/<arch>-linux/Foo.so`.
    for vst3 in target/bundled/*.vst3; do
      [ -e "$vst3" ] || continue
      cp -r "$vst3" "$out/lib/vst3/"
    done

    runHook postInstall
  '';

  meta = {
    description = "Collection of CLAP and VST3 audio plugins built with the NIH-plug framework";
    longDescription = ''
      Builds the upstream NIH-plug plugin collection: Buffr Glitch (a MIDI-
      triggered buffer-repeat effect), Crisp (high-frequency excitement
      inspired by Polarity's Fake Distortion), Loudness War Winner
      (digital saturation/clipper), Puberty Simulator (octave-down with
      formant artefacts), Safety Limiter (hearing-protection  tool that cuts
      to Morse-code SOS on clip), Soft Vacuum (oversampled port of Airwindows'
      Hard Vacuum) and Spectral Compressor (FFT-based dynamics processor).

      Outputs install to `$out/lib/clap` and `$out/lib/vst3`. Hosts that
      honour `CLAP_PATH` / `VST3_PATH` will pick them up automatically when
      the package is in the user's profile; otherwise symlink them into
      `~/.clap` and `~/.vst3` (or `~/.local/share/{clap,vst3}`).

      The NIH-plug framework itself is in upstream-declared maintenance mode;
      a community fork at codeberg.org/BillyDM/nih-plug is the active
      successor for new framework development. These plugin binaries continue
      to be developed in the upstream repository.

      Crossover and Diopser are part of the upstream repository but
      unconditionally require nightly Rust (std::simd) and are not built here.
    '';
    homepage = "https://github.com/robbert-vdh/nih-plug";
    changelog = "https://github.com/robbert-vdh/nih-plug/blob/${src.rev}/CHANGELOG.md";
    # The framework crates are ISC. Every plugin in `plugins/` declares
    # `GPL-3.0-or-later` in its `Cargo.toml`, and the produced bundles link
    # `vst3-sys` which is also GPLv3+. The binaries shipped by this
    # derivation are therefore GPLv3+.
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ magnetophon ];
    # CI also targets macOS and Windows, but the bundle install layout and
    # required system frameworks differ on Darwin (`CoreFoundation`, `AppKit`,
    # bundles under `~/Library/Audio/Plug-Ins/...`) and have not been wired up
    # here. Restrict to Linux until someone tests Darwin properly.
    platforms = lib.platforms.linux;
  };
}
