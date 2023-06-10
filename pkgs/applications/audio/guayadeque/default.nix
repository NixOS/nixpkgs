{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, wrapGAppsHook
, libgpod
, wxGTK31
, sqlite
, curl
, taglib
, wxsqlite3
, jsoncpp
, gst_all_1
}:

stdenv.mkDerivation rec {
  pname = "guayadeque";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "anonbeat";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ZeGuqT4M/hKBlbmjK9AEY3hkOPMbBPFamHxJZWsWKrQ=";
  };

  patches = [
    (fetchpatch {
      url = "https://aur.archlinux.org/cgit/aur.git/plain/wxwidgets.patch?h=guayadeque-git&id=3a830d61daa64cd720cb5fda81f88a22dcce726f";
      hash = "sha256-mQw6+X1rBj62azVv4WN9qaBYpT3hQA6aANukwLy0dC8=";
    })
  ];

  postPatch = "rm build";

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    libgpod
    wxGTK31
    sqlite
    curl
    taglib
    wxsqlite3
    jsoncpp
    gst_all_1.gstreamer
    gst_all_1.gstreamermm
  ];

  cmakeFlags = [ "-DCMAKE_CXX_STANDARD=11" ];

  meta = with lib; {
    description = "Full Featured Linux media player that can easily manage large collections";
    longDescription = ''
      Guayadeque is a music management program designed for all music enthusiasts. It is Full Featured Linux media player that can easily manage large collections and uses the Gstreamer media framework.
    '';
    homepage = "https://www.guayadeque.org";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.unix;
  };
}
