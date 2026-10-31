{
  lib,
  stdenv,
  fetchFromGitHub,
  versionCheckHook,
  cmake,
  pkg-config,
  fltk,
  libjack2,
  liblo,
  libsndfile,
  cairo,
  libjpeg,
  libpng,
  fontconfig,
  libxfixes,
  libxinerama,
  libxcursor,
  libxext,
  libx11,
  libxft,
  libxrender,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "non-timeline-xt";
  version = "2.0.9";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Stazed";
    repo = "non-timeline-xt";
    tag = finalAttrs.version;
    # Pulls in the nonlib/FL submodules this needs (same pinned commits as
    # non-mixer-xt's copies) instead of hand-fetching and splicing them in.
    fetchSubmodules = true;
    hash = "sha256-D4zBaNtJxKR1GHOG1uJVto/3sViektg0v+LF/1UwpA4=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    # provides the `fluid` binary that find_package(FLTK) looks for
    fltk
  ];

  buildInputs = [
    fltk
    libjack2
    liblo
    libsndfile
    cairo
    libjpeg
    libpng
    fontconfig
    libxfixes
    libxinerama
    libxcursor
    libxext
    libx11
    libxft
    libxrender
  ];

  cmakeFlags = [ (lib.cmakeBool "NativeOptimizations" false) ];

  # Upstream installs timeline/doc/icon.png as a relative symlink to a
  # nonexistent share/doc/icons path -- it also still targets the
  # pre-rebrand "non-timeline.png" filename, not non-timeline-xt.png.
  postInstall = ''
    rm "$out/share/doc/non-timeline-xt/icon.png"
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;
  versionCheckProgramArg = "--help";

  meta = {
    description = "Modular multitrack audio recorder/timeline for JACK (reboot of Non-Timeline/Non-DAW)";
    homepage = "https://github.com/Stazed/non-timeline-xt";
    changelog = "https://github.com/Stazed/non-timeline-xt/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.rickprice ];
    mainProgram = "non-timeline-xt";
  };
})
