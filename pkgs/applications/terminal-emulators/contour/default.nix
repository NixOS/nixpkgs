{ lib
, stdenv
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, freetype
, fontconfig
, libGL
, pcre
, boost
, catch2
, fmt
, microsoft_gsl
, range-v3
, yaml-cpp
, ncurses
, file
, darwin
, nixosTests
}:

let
  # Commits refs come from https://github.com/contour-terminal/contour/blob/master/scripts/install-deps.sh
  libunicode-src = fetchFromGitHub {
    owner = "contour-terminal";
    repo = "libunicode";
    rev = "c2369b6380df1197476b08d3e2d0e96b6446f776";
    sha256 = "sha256-kq7GpFCkrJG7F9/YEGz3gMTgYzhp/QB8D5b9wwMaLvQ=";
  };

  termbench-pro-src = fetchFromGitHub {
    owner = "contour-terminal";
    repo = "termbench-pro";
    rev = "cd571e3cebb7c00de9168126b28852f32fb204ed";
    sha256 = "sha256-dNtOmBu63LFYfiGjXf34C2tiG8pMmsFT4yK3nBnK9WI=";
  };
in
mkDerivation rec {
  pname = "contour";
  version = "0.3.1.200";

  src = fetchFromGitHub {
    owner = "contour-terminal";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TpxVC0GFZD3jGISnDWHKEetgVVpznm5k/Vc2dwVfSG4=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    ncurses
    file
  ];

  buildInputs = [
    fontconfig
    freetype
    libGL
    pcre
    boost
    catch2
    fmt
    microsoft_gsl
    range-v3
    yaml-cpp
  ] ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.libs.utmp ];

  preConfigure = ''
    mkdir -p _deps/sources

    cat > _deps/sources/CMakeLists.txt <<EOF
    macro(ContourThirdParties_Embed_libunicode)
        add_subdirectory(\''${ContourThirdParties_SRCDIR}/libunicode EXCLUDE_FROM_ALL)
    endmacro()
    macro(ContourThirdParties_Embed_termbench_pro)
        add_subdirectory(\''${ContourThirdParties_SRCDIR}/termbench_pro EXCLUDE_FROM_ALL)
    endmacro()
    EOF

    ln -s ${libunicode-src} _deps/sources/libunicode
    ln -s ${termbench-pro-src} _deps/sources/termbench_pro

    # Don't fix Darwin app bundle
    sed -i '/fixup_bundle/d' src/contour/CMakeLists.txt
  '';

  passthru.tests.test = nixosTests.terminal-emulators.contour;

  meta = with lib; {
    # never built on Hydra https://hydra.nixos.org/job/nixpkgs/staging-next/contour.x86_64-darwin
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "Modern C++ Terminal Emulator";
    homepage = "https://github.com/contour-terminal/contour";
    changelog = "https://github.com/contour-terminal/contour/raw/v${version}/Changelog.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fortuneteller2k ];
    platforms = platforms.unix;
  };
}
