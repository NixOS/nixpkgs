{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  util-linux,
  libselinux,
  libsepol,
  lerc,
  libthai,
  libdatrie,
  libxkbcommon,
  libepoxy,
  libXtst,
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
  pcre2,
  libsigcxx,
  lensfun,
  librsvg,
  libcanberra-gtk3,
  gtk-mac-integration,
  exiv2,
  libraw,
  libjxl,
}:

stdenv.mkDerivation rec {
  pname = "rawtherapee";
  version = "5.11";

  src = fetchFromGitHub {
    owner = "Beep6581";
    repo = "RawTherapee";
    rev = version;
    hash = "sha256-jIAbguwF2aqRTk72ro5oHNTawA7biPSFC41YHgRR730=";
    # The developpers ask not to use the tarball from Github releases, see
    # https://www.rawtherapee.com/downloads/5.10/#news-relevant-to-package-maintainers
    forceFetchGit = true;
  };

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
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      makeWrapper
    ];

  buildInputs =
    [
      util-linux
      libselinux
      libsepol
      lerc
      libthai
      libdatrie
      libxkbcommon
      libepoxy
      libXtst
      pixman
      libpthreadstubs
      gtkmm3
      libXau
      libXdmcp
      lcms2
      libiptcdata
      fftw
      expat
      pcre2
      libsigcxx
      lensfun
      librsvg
      exiv2
      libraw
      libjxl
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libcanberra-gtk3
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      gtk-mac-integration
    ];

  cmakeFlags =
    [
      "-DPROC_TARGET_NUMBER=2"
      "-DCACHE_NAME_SUFFIX=\"\""
      "-DWITH_SYSTEM_LIBRAW=\"ON\""
      "-DWITH_JXL=\"ON\""
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "-DCMAKE_OSX_DEPLOYMENT_TARGET=${stdenv.hostPlatform.darwinMinVersion}"
    ];

  CMAKE_CXX_FLAGS = toString [
    "-std=c++11"
    "-Wno-deprecated-declarations"
    "-Wno-unused-result"
  ];
  env.CXXFLAGS = "-include cstdint"; # needed at least with gcc13 on aarch64-linux

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
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
