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
  version = "5.12";

  src = fetchFromGitHub {
    owner = "RawTherapee";
    repo = "RawTherapee";
    tag = version;
    hash = "sha256-h8eWnw9I1R0l9WAI/DylsdA241qU9NhYGEPYz+JlE18=";
    # The developers ask not to use the tarball from Github releases, see
    # https://www.rawtherapee.com/downloads/5.10/#news-relevant-to-package-maintainers
    forceFetchGit = true;
  };

  postPatch = ''
    cat <<EOF > ReleaseInfo.cmake
    set(GIT_DESCRIBE ${version})
    set(GIT_BRANCH ${version})
    set(GIT_VERSION ${version})
    # Missing GIT_COMMIT and GIT_COMMIT_DATE, which are not easy to obtain.
    set(GIT_COMMITS_SINCE_TAG 0)
    set(GIT_COMMITS_SINCE_BRANCH 0)
    set(GIT_VERSION_NUMERIC_BS ${version})
    EOF
    substituteInPlace tools/osx/Info.plist.in rtgui/config.h.in \
      --replace "/Applications" "${placeholder "out"}/Applications"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    makeWrapper
  ];

  buildInputs = [
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

  cmakeFlags = [
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
