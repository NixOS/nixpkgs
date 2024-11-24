{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  darwin,
  fmt,
  gtk3,
  iir1,
  imgui,
  imnodes,
  implot,
  openssl,
  curl,
}:

stdenv.mkDerivation rec {
  pname = "implot-demos";
  version = "unstable-2023-08-20";

  src = fetchFromGitHub {
    owner = "epezent";
    repo = "implot_demos";
    rev = "f33219d3ade192a2333d4a32e749842010952a29";
    hash = "sha256-Xq0kVk8qncj/BzQyIX/l1OLvPSQJU8ckTxIIfLZdO/g=";
  };

  patches = [
    # Resolve "undefined symbols" (GetWindowContentRegionWidth &c)
    (fetchpatch {
      url = "https://github.com/epezent/implot_demos/commit/85a59612c102f8da97d6ead04f528f4c88f4ef9a.patch";
      hash = "sha256-HRhfC3TUwz9Mv+1ODabaDxTWUaj4Nx1iH7C6vjUPo2s=";
    })

    # CMake: make FetchContent optional, add install targets
    (fetchpatch {
      url = "https://github.com/epezent/implot_demos/commit/4add0433a46ed5e2099e1af1a77e8055e49230d0.patch";
      hash = "sha256-jYdM8NuwbZk7INKo2wqMAbjLMTPdrAdM4Kr3xmtquIY=";
    })

    # CMake: link libGL from the "app" target
    (fetchpatch {
      url = "https://github.com/epezent/implot_demos/commit/6742e4202858eb85bd0d67ca5fa15a7a07e6b618.patch";
      hash = "sha256-h4EJ9u1iHLYkGHgxSynskkuCGmY6mmvKdZSRwHJKerY=";
    })
  ];

  cmakeFlags = [ (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true) ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs =
    [
      curl
      fmt
      iir1
      imgui
      imnodes
      implot
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ gtk3 ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.AppKit ];

  meta = {
    description = "Standalone ImPlot Demos";
    homepage = "https://github.com/epezent/implot_demos";
    broken =
      stdenv.hostPlatform.isAarch64 # Target "mandel" relies on AVX2
      || stdenv.hostPlatform.isDarwin;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
    mainProgram = "implot-demos";
    platforms = lib.platforms.all;
  };
}
