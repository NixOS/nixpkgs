{ lib
, stdenv
, mkDerivationWith
, fetchFromGitHub
, fetchpatch
, doxygen
, gtk3
, libopenshot
, python3
, qtsvg
, wrapGAppsHook
}:

mkDerivationWith python3.pkgs.buildPythonApplication rec {
  pname = "openshot-qt";
  version = "2.6.1";

  src = fetchFromGitHub {
    owner = "OpenShot";
    repo = "openshot-qt";
    rev = "v${version}";
    hash = "sha256-29fAg4SDoAFzv6q43Dcs2HdaeKZfPEzlGqCcICiPSF0=";
  };

  nativeBuildInputs = [
    doxygen
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
  ];

  propagatedBuildInputs = with python3.pkgs; [
    httplib2
    libopenshot
    pyqtwebengine
    pyzmq
    requests
    sip_4
  ];

  preConfigure = ''
    # tries to create caching directories during install
    export HOME=$(mktemp -d)
  '';

  # Following Arch PKGBUILD for Python 3.10 compatibility
  # https://github.com/OpenShot/openshot-qt/issues/4608
  # https://github.com/archlinux/svntogit-community/commits/packages/openshot/trunk
  patches = [
    (fetchpatch {
      name = "video-widget.patch";
      url = "https://github.com/OpenShot/openshot-qt/commit/9748a13268d66a5949aebc970637b5903756d018.patch";
      hash = "sha256-QwLtcooDJeYWDp80a1dUFo2so/zEWqqsq5IgkXWX324=";
    })
    (fetchpatch {
      name = "python-3.10-int.patch";
      url = "https://github.com/OpenShot/openshot-qt/commit/fff785eb1e3e0c30ed6ca57e2d1933aaa807ae22.patch";
      hash = "sha256-ee/s7rhF71ot5oPkGK+j59mL1B3e72xoH27KFoDL8s8=";
    })
  ];

  doCheck = false;

  dontWrapGApps = true;
  dontWrapQtApps = true;

  postFixup = ''
    wrapProgram $out/bin/openshot-qt \
  ''
  # Fix toolbar icons on Darwin
  + lib.optionalString stdenv.isDarwin ''
    --suffix QT_PLUGIN_PATH : "${lib.getBin qtsvg}/lib/qt-5.12.7/plugins" \
  '' + ''
    "''${gappsWrapperArgs[@]}" \
    "''${qtWrapperArgs[@]}"
  '';

  passthru = {
    inherit libopenshot;
    inherit (libopenshot) libopenshot-audio;
  };

  meta = with lib; {
    homepage = "http://openshot.org/";
    description = "Free, open-source video editor";
    longDescription = ''
      OpenShot Video Editor is a free, open-source video editor for Linux.
      OpenShot can take your videos, photos, and music files and help you
      create the film you have always dreamed of. Easily add sub-titles,
      transitions, and effects, and then export your film to DVD, YouTube,
      Vimeo, Xbox 360, and many other common formats.
    '';
    license = with licenses; gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; unix;
  };
}
