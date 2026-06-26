{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  autoPatchelfHook,
  # JUCE graphics / GL
  freetype,
  fontconfig,
  libGL,
  # JUCE / standalone audio + MIDI
  alsa-lib,
  libjack2,
  libpulseaudio,
  # JUCE GUI: linked at build time (juce_gui_basics dlopens these at runtime,
  # but the standalone host's X11 GUI path links them directly)
  libx11,
  libxext,
  libxcursor,
  libxinerama,
  libxrandr,
  libxrender,
  libxscrnsaver,
  # clap-wrapper's Linux standalone GUI host (auto-detected via pkg-config;
  # if absent, the standalone still builds but can't show plugin windows)
  gtkmm3,
}:

let
  # The bundled clap-wrapper hard-codes CLAP_WRAPPER_DOWNLOAD_DEPENDENCIES=TRUE
  # and CPM-fetches these from GitHub at configure time. We pre-fetch them so
  # the build is hermetic, and feed the paths in via *_SDK_ROOT cmake flags;
  # `base_sdks.cmake` short-circuits the CPM path when *_SDK_ROOT is set.
  #
  # Revisions are pinned to whatever the clap-wrapper submodule at the
  # six-sines v1.1.0 tag requests in cmake/base_sdks.cmake. When bumping
  # six-sines, re-check those tags here.
  vst3sdk = fetchFromGitHub {
    owner = "steinbergmedia";
    repo = "vst3sdk";
    rev = "v3.7.6_build_18";
    fetchSubmodules = true;
    hash = "sha256-MeMb09bM8D4FPHWvvRbmWbiyO9u8JVxyfgv4jmeogLI=";
    # The `doc` submodule is ~130 MB of PDFs we never reference. The
    # `vstgui4` submodule isn't touched by clap-wrapper's VST3 glue either,
    # but it's small (~12 MB) and removing it would diverge further from
    # upstream Steinberg, so leave it in.
    postFetch = ''
      rm -rf $out/doc
    '';
  };

  rtaudio-src = fetchFromGitHub {
    owner = "thestk";
    repo = "rtaudio";
    rev = "6.0.1";
    hash = "sha256-Acsxbnl+V+Y4mKC1gD11n0m03E96HMK+oEY/YV7rlIY=";
  };

  rtmidi-src = fetchFromGitHub {
    owner = "thestk";
    repo = "rtmidi";
    rev = "6.0.0";
    hash = "sha256-QuUeFx8rPpe0+exB3chT6dUceDa/7ygVy+cQYykq7e0=";
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "six-sines";
  version = "1.1.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "baconpaul";
    repo = "six-sines";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-IQLGC86FqS3dptPzNpHEYKB59MWFDKsOPGM+FuzGcPo=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    autoPatchelfHook
  ];

  # nixpkgs' default `format` hardening injects `-Wformat -Wformat-security
  # -Werror=format-security`. clap-wrapper's base_sdks.cmake adds
  # `-Wno-format` privately to the VST3 SDK targets to silence a known
  # confusion between `%lld` and `long long int`, which leaves
  # `-Werror=format-security` dangling — and gcc treats "X ignored without
  # Y" as a `-Werror=format-security` violation in its own right, breaking
  # the base-sdk-vst3 compile. Disabling the whole hardening flag is the
  # smallest change that lets the SDK's own pragma stand.
  hardeningDisable = [ "format" ];

  buildInputs = [
    freetype
    fontconfig
    libGL
    alsa-lib
    libjack2
    libpulseaudio
    libx11
    libxext
    libxcursor
    libxinerama
    libxrandr
    libxrender
    libxscrnsaver
    gtkmm3
  ];

  # JUCE loads several X11 libraries via dlopen() in juce_XSymbols_linux.h
  # (libx11.so.6, libxext.so.6, libxcursor.so.1, libxinerama.so.1,
  # libxrender.so.1, libxrandr.so.2, plus libxss.so.1 from
  # juce_XWindowSystem_linux.cpp). Listing them in runtimeDependencies makes
  # autoPatchelfHook bake them into the binaries' RPATH.
  runtimeDependencies = [
    libx11
    libxext
    libxcursor
    libxinerama
    libxrandr
    libxrender
    libxscrnsaver
  ];

  postPatch = ''
    # sst-plugininfra's version_from_versionfile_or_git() looks for a
    # BUILD_VERSION file before falling back to `git describe`. fetchFromGitHub
    # strips .git, so we provide the file directly. The format is 5 lines:
    # header (ignored), commit hash, tag, branch, display version.
    cat > BUILD_VERSION <<EOF
    Six Sines v${finalAttrs.version}
    v${finalAttrs.version}
    v${finalAttrs.version}
    main
    ${finalAttrs.version}
    EOF
  '';

  cmakeFlags = [
    # Don't try to copy build artefacts into ~/.clap and ~/.vst3 from
    # within the build (CMake's POST_BUILD step in clap-wrapper's
    # target_copy_after_build()).
    (lib.cmakeBool "COPY_AFTER_BUILD" false)

    # Hand clap-wrapper the SDK trees it would otherwise CPM-download.
    # base_sdks.cmake short-circuits the CPM path whenever a *_SDK_ROOT is
    # set, so we don't need to additionally flip CLAP_WRAPPER_DOWNLOAD_DEPENDENCIES.
    (lib.cmakeFeature "VST3_SDK_ROOT" "${vst3sdk}")
    (lib.cmakeFeature "RTAUDIO_SDK_ROOT" "${rtaudio-src}")
    (lib.cmakeFeature "RTMIDI_SDK_ROOT" "${rtmidi-src}")

    # CMake 4 hard-removed support for cmake_minimum_required(VERSION < 3.5).
    # The bundled libsamplerate submodule still declares `VERSION 3.1..3.18`
    # at the top of its CMakeLists.txt and refuses to configure otherwise.
    # 3.5 is the value CMake itself suggests in the error.
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")
  ];

  # The CMakeLists exposes a `six-sines_all` custom target that aggregates
  # the `_clap`, `_vst3`, and `_standalone` sub-targets (`_auv2` is
  # APPLE-gated and absent on Linux). The default ALL target would build
  # the same outputs in practice — the test subdir is already EXCLUDE_FROM_ALL
  # — but going through `six-sines_all` matches what upstream documents and
  # keeps the surface narrow if extra default targets ever land later.
  buildPhase = ''
    runHook preBuild
    cmake --build . --config Release --parallel "$NIX_BUILD_CORES" --target six-sines_all
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -d $out/lib/clap $out/lib/vst3 $out/bin

    # The clap-wrapper assets dir is flat on Linux — the CLAP/ and VST3/
    # subdirectories only get created on Windows (the relevant branches in
    # make_clapfirst.cmake and wrap_vst3.cmake are gated on WIN32). On
    # Linux and macOS everything lands directly in ''${CMAKE_BINARY_DIR}/
    # six-sines_assets/.
    cp -r 'six-sines_assets/Six Sines.clap' "$out/lib/clap/"
    cp -r 'six-sines_assets/Six Sines.vst3' "$out/lib/vst3/"

    # Rename the standalone to a Unix-friendly $out/bin name.
    install -m755 'six-sines_assets/Six Sines' "$out/bin/six-sines"

    runHook postInstall
  '';

  meta = {
    description = "Small synthesizer exploring audio-rate inter-modulation of sine waves (FM/PM/AM)";
    longDescription = ''
      Six Sines is a six-operator phase-/amplitude-/ring-modulation synthesizer
      by Paul Walker (baconpaul). It ships as a CLAP plug-in, a VST3 plug-in,
      and a standalone application backed by RtAudio (ALSA / JACK / PulseAudio).
    '';
    homepage = "https://github.com/baconpaul/six-sines";
    changelog = "https://github.com/baconpaul/six-sines/blob/v${finalAttrs.version}/doc/changelog.md";
    # Author's own code is MIT (see LICENSE.md), but the binary statically
    # links GPL3 JUCE, so the combined work is distributed under GPL3+
    # (resources/LICENSE_GPL3).
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ magnetophon ];
    mainProgram = "six-sines";
    # cmake/compile-options.cmake hard-codes `-march=nehalem` for non-Apple
    # builds, and clap-wrapper hard-codes the VST3 bundle architecture path
    # to `x86_64-linux`. aarch64-linux would require patching both.
    platforms = [ "x86_64-linux" ];
  };
})
