{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  # Transport
  curl,
  # Libraries
  boost,
  jsoncpp,
  libbsd,
  # GUI/Desktop
  dbus,
  glibmm,
  gsettings-desktop-schemas,
  hicolor-icon-theme,
  libappindicator-gtk3,
  libnotify,
  libxdg_basedir,
  wxGTK,
  # GStreamer
  glib-networking,
  gst_all_1,
  # User-agent info
  lsb-release,
  # rt2rtng
  python3,
  # Testing
  gtest,
  # Fixup
  wrapGAppsHook3,
  makeWrapper,
}:

let
  gstInputs = with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
    gst-libav
  ];
  # For the rt2rtng utility for converting bookmark file to -ng format
  pythonInputs = with python3.pkgs; [
    python
    lxml
  ];
in
stdenv.mkDerivation rec {
  pname = "radiotray-ng";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "ebruck";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-vGxDwU2E6VAKxydbS2YTBgkBWcJAQ0R5bltidd5CUHE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook3
    makeWrapper
  ];

  buildInputs =
    [
      curl
      boost
      jsoncpp
      libbsd
      glibmm
      hicolor-icon-theme
      gsettings-desktop-schemas
      libappindicator-gtk3
      libnotify
      libxdg_basedir
      lsb-release
      wxGTK
      # for https gstreamer / libsoup
      glib-networking
    ]
    ++ gstInputs
    ++ pythonInputs;

  patches = [
    ./no-dl-googletest.patch
  ];

  postPatch = ''
    for x in package/CMakeLists.txt include/radiotray-ng/common.hpp data/*.desktop; do
      substituteInPlace $x --replace /usr $out
    done
    substituteInPlace package/CMakeLists.txt --replace /etc/xdg/autostart $out/etc/xdg/autostart

    # We don't find the radiotray-ng-notification icon otherwise
    substituteInPlace data/radiotray-ng.desktop \
      --replace radiotray-ng-notification radiotray-ng-on
    substituteInPlace data/rtng-bookmark-editor.desktop \
      --replace radiotray-ng-notification radiotray-ng-on
  '';

  cmakeFlags = [
    "-DBUILD_TESTS=${if doCheck then "ON" else "OFF"}"
  ];

  # NOTE gtest >=1.17 now requires C++17, but this workaround is insufficient
  # and it breaks tests compilation, even if you just restrict -std=c++17 to
  # the tests/ subdirectory. It seems to require an upstream fix.
  # > In file included from /nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-gtest-1.17.0-dev/include/gtest/gtest-printers.h:122,
  # >                  from /nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-gtest-1.17.0-dev/include/gtest/gtest-matchers.h:49,
  # >                  from /nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-gtest-1.17.0-dev/include/gtest/internal/gtest-death-test-internal.h:47,
  # >                  from /nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-gtest-1.17.0-dev/include/gtest/gtest-death-test.h:43,
  # >                  from /nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-gtest-1.17.0-dev/include/gtest/gtest.h:64,
  # >                  from /build/source/tests/bookmarks_test.cpp:20:
  # > /build/source/tests/bookmarks_test.cpp: In member function 'virtual void Bookmarks_test_that_stations_are_added_and_removed_from_a_group_and_moved_Test::TestBody()':
  # > /build/source/tests/bookmarks_test.cpp:218:39: error: ignoring return value of 'std::vector<_Tp, _Alloc>::reference std::vector<_Tp, _Alloc>::at(size_type) [with _Tp = IBookmarks::<unnamed struct>; _Alloc = std::allocator<IBookmarks::<unnamed struct> >; reference = IBookmarks::<unnamed struct>&; size_type = long unsigned int]', declared with attribute 'nodiscard' [-Werror=unused-result]
  # >   218 |         EXPECT_THROW(bm[0].stations.at(100), std::out_of_range);
  # >       |                      ~~~~~~~~~~~~~~~~~^~~~~
  # > In file included from /nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-gcc-14.3.0/include/c++/14.3.0/vector:66,
  # >                  from /nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-gcc-14.3.0/include/c++/14.3.0/functional:64,
  # >                  from /nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-boost-1.87.0-dev/include/boost/parameter/aux_/unwrap_cv_reference.hpp:38,
  # >                  from /nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-boost-1.87.0-dev/include/boost/parameter/aux_/tag.hpp:10,
  # >                  from /nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-boost-1.87.0-dev/include/boost/parameter/keyword.hpp:10,
  # >                  from /nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-boost-1.87.0-dev/include/boost/log/keywords/severity.hpp:18,
  # >                  from /nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-boost-1.87.0-dev/include/boost/log/trivial.hpp:22,
  # >                  from /build/source/include/radiotray-ng/common.hpp:20,
  # >                  from /build/source/src/radiotray-ng/bookmarks/bookmarks.hpp:20,
  # >                  from /build/source/tests/bookmarks_test.cpp:18:
  # > /nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-gcc-14.3.0/include/c++/14.3.0/bits/stl_vector.h:1193:7: note: declared here

  env.NIX_CFLAGS_COMPILE = "-std=c++17";
  nativeCheckInputs = [ gtest ];
  doCheck = false;

  preFixup = ''
    gappsWrapperArgs+=(--suffix PATH : ${lib.makeBinPath [ dbus ]})
    wrapProgram $out/bin/rt2rtng --prefix PYTHONPATH : $PYTHONPATH
  '';

  meta = {
    description = "Internet radio player for linux";
    homepage = "https://github.com/ebruck/radiotray-ng";
    license = lib.licenses.gpl3;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
