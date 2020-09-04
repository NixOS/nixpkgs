{ lib
, mkDerivation
, fetchFromGitHub
, fetchpatch
, pkg-config
, qmake
, qttools
, gstreamer
, libX11
, qtbase
, qtmultimedia
, qtx11extras

, gst-plugins-base
, gst-plugins-good
, gst-plugins-bad
, gst-plugins-ugly
}:
mkDerivation rec {

  pname = "vokoscreen-ng";
  version = "3.0.5";

  src = fetchFromGitHub {
    owner = "vkohaupt";
    repo = "vokoscreenNG";
    rev = version;
    sha256 = "1spyqw8h8bkc1prdb9aixiw5h3hk3gp2p0nj934bnwq04kmfp660";
  };

  patches = [
    # Better linux integration
    (fetchpatch {
      url = "https://github.com/vkohaupt/vokoscreenNG/commit/0a3784095ecca582f7eb09551ceb34c309d83637.patch";
      sha256 = "1iibimv8xfxxfk44kkbrkay37ibdndjvs9g53mxr8x8vrsp917bz";
    })
  ];

  qmakeFlags = [ "src/vokoscreenNG.pro" ];

  nativeBuildInputs = [ qttools pkg-config qmake ];
  buildInputs = [
    gstreamer
    libX11
    qtbase
    qtmultimedia
    qtx11extras

    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly
  ];

  postPatch = ''
    substituteInPlace src/vokoscreenNG.pro \
      --replace lrelease-qt5 lrelease
  '';

  postInstall = ''
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  meta = with lib; {
    description = "User friendly Open Source screencaster for Linux and Windows";
    license = licenses.gpl2Plus;
    homepage = "https://github.com/vkohaupt/vokoscreenNG";
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
