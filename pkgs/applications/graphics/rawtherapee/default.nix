{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
  pkg-config,
  wrapGAppsHook3,
  makeWrapper,
  pixman,
  libpthreadstubs,
  gtkmm3,
  libXau,
  libXdmcp,
  lcms2,
  libiptcdata,
  fftw,
  expat,
  pcre,
  libsigcxx,
  lensfun,
  librsvg,
  libcanberra-gtk3,
  gtk-mac-integration,
  exiv2,
}:

stdenv.mkDerivation rec {
  pname = "rawtherapee";
  version = "5.10";

  src = fetchFromGitHub {
    owner = "Beep6581";
    repo = "RawTherapee";
    rev = version;
    hash = "sha256-rIwwKNm7l7oPEt95sHyRj4aF3mtnvM4KAu8oVaIMwyE=";
    # The developpers ask not to use the tarball from Github releases, see
    # https://www.rawtherapee.com/downloads/5.10/#news-relevant-to-package-maintainers
    forceFetchGit = true;
  };

  # https://github.com/Beep6581/RawTherapee/issues/7074
  patches = [
    (fetchurl {
      url = "https://github.com/Beep6581/RawTherapee/commit/6b9f45c69c1ddfc3607d3d9c1206dcf1def30295.diff";
      hash = "sha256-3Rti9HV8N1ueUm5B9qxEZL7Lb9bBb+iy2AGKMpJ9YOM=";
    })
  ];

  postPatch = ''
    echo "set(HG_VERSION ${version})" > ReleaseInfo.cmake
    substituteInPlace tools/osx/Info.plist.in rtgui/config.h.in \
      --replace "/Applications" "${placeholder "out"}/Applications"
  '';

  nativeBuildInputs =
    [
      cmake
      pkg-config
      wrapGAppsHook3
    ]
    ++ lib.optionals stdenv.isDarwin [
      makeWrapper
    ];

  buildInputs =
    [
      pixman
      libpthreadstubs
      gtkmm3
      libXau
      libXdmcp
      lcms2
      libiptcdata
      fftw
      expat
      pcre
      libsigcxx
      lensfun
      librsvg
      exiv2
    ]
    ++ lib.optionals stdenv.isLinux [
      libcanberra-gtk3
    ]
    ++ lib.optionals stdenv.isDarwin [
      gtk-mac-integration
    ];

  cmakeFlags =
    [
      "-DPROC_TARGET_NUMBER=2"
      "-DCACHE_NAME_SUFFIX=\"\""
    ]
    ++ lib.optionals stdenv.isDarwin [
      "-DCMAKE_OSX_DEPLOYMENT_TARGET=${stdenv.hostPlatform.darwinMinVersion}"
    ];

  CMAKE_CXX_FLAGS = toString [
    "-std=c++11"
    "-Wno-deprecated-declarations"
    "-Wno-unused-result"
  ];
  env.CXXFLAGS = "-include cstdint"; # needed at least with gcc13 on aarch64-linux

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications/RawTherapee.app $out/bin
    cp -R Release $out/Applications/RawTherapee.app/Contents
    for f in $out/Applications/RawTherapee.app/Contents/MacOS/*; do
      makeWrapper $f $out/bin/$(basename $f)
    done
  '';

  meta = {
    description = "RAW converter and digital photo processing software";
    homepage = "http://www.rawtherapee.com/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      jcumming
      mahe
    ];
    platforms = with lib.platforms; unix;
  };
}
