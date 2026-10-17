{
  lib,
  stdenv,
  fetchFromGitHub,
  runCommand,
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
    tag = "2.0.9";
    hash = "sha256-w+BZ9SZ8G3r0wl7rO+vVq1TFt8yrgfX93243OP/3+tA=";
  };

  # Same submodules (and pinned commits) as non-mixer-xt.
  nonlibSrc = fetchFromGitHub {
    owner = "Stazed";
    repo = "nonlib-xt";
    rev = "33b704d638d1383826ea4c36e5607aefabf83371";
    hash = "sha256-RNlKCTn4o2E9h0zXssdyrfretA90MM/aoE5ezG5wpDs=";
  };

  flSrc = fetchFromGitHub {
    owner = "Stazed";
    repo = "non-FL";
    rev = "37158cd7b23d47ab150a82381d7cd3536c473854";
    hash = "sha256-DoEdaQCaohZFQcoaK0HgICQy03IjStD/gPaMbk4rAKA=";
  };

  postUnpack = ''
    rm -rf source/nonlib source/FL
    cp -r --no-preserve=mode,ownership "$nonlibSrc" source/nonlib
    cp -r --no-preserve=mode,ownership "$flSrc" source/FL
  '';

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

  # Upstream installs timeline/doc/icon.png as a relative symlink to a path
  # that doesn't exist in the install tree (icons go to share/icons, not
  # share/doc/icons, and the filename differs: non-timeline vs non-timeline-xt).
  postInstall = ''
    rm -f "$out/share/doc/non-timeline-xt/icon.png"
  '';

  passthru.tests.help = runCommand "${finalAttrs.pname}-test-help" { } ''
    output="$(${finalAttrs.finalPackage}/bin/non-timeline-xt --help 2>&1)" || true
    [[ "$output" == *"Non-Timeline-XT ${finalAttrs.version}"* ]]
    touch $out
  '';

  meta = {
    description = "Modular multitrack audio recorder/timeline for JACK (reboot of Non-Timeline/Non-DAW)";
    homepage = "https://github.com/Stazed/non-timeline-xt";
    changelog = "https://github.com/Stazed/non-timeline-xt/releases/tag/2.0.9";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.rickprice ];
    mainProgram = "non-timeline-xt";
  };
})
