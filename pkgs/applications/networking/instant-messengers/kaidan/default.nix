{ mkDerivation
, lib
, fetchFromGitLab
, cmake
, extra-cmake-modules
, pkg-config
, qtquickcontrols2
, qtmultimedia
, qtlocation
, qqc2-desktop-style
, kirigami2
, knotifications
, zxing-cpp
, qxmpp
, sonnet
, gst_all_1
}:

mkDerivation rec {
  pname = "kaidan";
  version = "0.8.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "network";
    repo = pname;
    rev = "v${version}";
    sha256 = "070njci5zyzahmz3nqyp660chxnqx1mxp31w17syfllvrw403qmg";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules pkg-config ];

  buildInputs = with gst_all_1; [
    qtquickcontrols2
    qtmultimedia
    qtlocation
    qqc2-desktop-style
    kirigami2
    knotifications
    zxing-cpp
    qxmpp
    sonnet
    gstreamer
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
  ];
  postInstall = ''
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  meta = with lib; {
    description = "User-friendly and modern chat app, using XMPP";
    longDescription = ''
       Kaidan is a user-friendly and modern chat app for every device. It uses
       the open communication protocol XMPP (Jabber). Unlike other chat apps,
       you are not dependent on one specific service provider.

       Kaidan does not have all basic features yet and has still some
       stability issues. Current features include audio messages, video
       messages, and file sharing.
    '';
    homepage = "https://www.kaidan.im";
    license = with licenses; [
      gpl3Plus
      mit
      asl20
      cc-by-sa-40
    ];
    maintainers = with maintainers; [ astro ];
    platforms = with platforms; linux;
  };
}
