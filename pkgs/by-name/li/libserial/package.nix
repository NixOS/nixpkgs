{
  lib,
  stdenv,
  cmake,
  pkg-config,
  runCommand,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libserial";
  version = "1.0.0-unstable-2025-09-02";

  src = fetchFromGitHub {
    owner = "crayzeewulf";
    repo = "libserial";
    # The v1.0.0 tag (most recent tag) lacks the <cstdint> fix and the CMake options to
    # disable docs, tests, and Python bindings. Pin a later commit.
    rev = "50e0f443666d48d7c7e181dc73a6b35700517fae";
    hash = "sha256-i4Ty3X5uj1m3EzDbgS5tt+JiDGvoJf0TCf3pC5oyS0s=";
  };

  strictDeps = true;
  __structuredAttrs = true;
  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeFeature "LIBSERIAL_BUILD_DOCS" "OFF")
    (lib.cmakeFeature "LIBSERIAL_ENABLE_TESTING" "OFF")
    (lib.cmakeFeature "LIBSERIAL_PYTHON_ENABLE" "OFF")
    (lib.cmakeFeature "LIBSERIAL_BUILD_EXAMPLES" "OFF")
  ];

  postInstall = ''
    # Upstream concatenates CMAKE_INSTALL_PREFIX onto the GNUInstallDirs
    # variables, which nixpkgs already passes as absolute paths. This
    # doubles libdir/includedir both in the pkg-config file contents and
    # in its install DESTINATION (landing under a nested path). Relocate
    # the file and repair its paths.
    mkdir -p "$out/lib/pkgconfig"
    mv "$(find "$out/nix" -name libserial.pc -type f)" "$out/lib/pkgconfig/"
    rm -rf "$out/nix"
    substituteInPlace "$out/lib/pkgconfig/libserial.pc" \
      --replace-fail "$out/$out" "$out"
  '';

  passthru.tests.roundtrip = stdenv.mkDerivation {
    name = "libserial-roundtrip-test";
    dontUnpack = true;

    nativeBuildInputs = [ pkg-config ];

    # Keep libserial out of buildInputs so compiler and linker search paths
    # come from libserial.pc rather than the stdenv setup hooks.
    PKG_CONFIG_PATH = "${finalAttrs.finalPackage}/lib/pkgconfig";

    buildPhase = ''
      $CXX -std=c++17 ${./test-roundtrip.cpp} -o roundtrip \
        $(pkg-config --cflags --libs libserial) \
        -Wl,-rpath,"$(pkg-config --variable=libdir libserial)"
    '';

    installPhase = ''
      ./roundtrip
      touch $out
    '';
  };

  meta = {
    description = "Serial port programming in C++";
    homepage = "https://github.com/crayzeewulf/libserial";
    changelog = "https://github.com/crayzeewulf/libserial/compare/v1.0.0...${finalAttrs.src.rev}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bugsaplenty ];
    platforms = lib.platforms.linux;
  };
})
