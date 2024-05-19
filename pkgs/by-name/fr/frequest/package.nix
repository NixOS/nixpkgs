{ lib, stdenv, fetchFromGitHub, fetchpatch, qt5 }:

stdenv.mkDerivation (finalAttrs: {
  pname = "frequest";
  version = "1.2a";

  srcs = [
    (fetchFromGitHub {
      owner = "fabiobento512";
      name = "frequest";
      repo = "FRequest";
      rev = "v${finalAttrs.version}";
      hash = "sha256-fdn3MK5GWBOhJjpMtRaytO9EsVzz6KJknDhqWtAyXCc=";
    })
    # The application depends on hard-coded relative paths to ../CommonLibs and ../CommonUtils.
    # See https://github.com/fabiobento512/FRequest/wiki/Building-FRequest for more info.
    # Upstream provides no tags for these dependencies, use latest commit on their `master` branch.
    # Changing the name of these srcs will break the build.
    (fetchFromGitHub {
      owner = "fabiobento512";
      name = "CommonLibs";
      repo = "CommonLibs";
      rev = "d3906931bb06ddf4194ff711a59e1dcff80fa82f";
      hash = "sha256-iLJJ95yJ+VjNPuk8fNEDvYBI0db0rcfJF12a9azGv1Y=";
    })
    (fetchFromGitHub {
      owner = "fabiobento512";
      name = "CommonUtils";
      repo = "CommonUtils";
      rev = "53970984f6538d78350be1b9426032bcb5bcf818";
      hash = "sha256-nRv9DriSOuAiWhy+KkOVNEz5oSgNNNJZqk8sNwgbx8U=";
    })
  ];
  sourceRoot = "frequest";

  patches = [
    # This fix has been merged upstream into the develop branch, but it was not released yet. It can be removed once a new version is released.
    (fetchpatch {
      name = "Change-desktop-icon-name";
      url = "https://github.com/fabiobento512/FRequest/commit/22e98970b78f6d9ca0037c39c2492e93e836abff.patch";
      hash = "sha256-YoI68SPMHD4bAgjWpn6eSda3Oon8bevbiwTx1JFFm40=";
    })
  ];

  buildInputs = [
    qt5.qtbase
  ];

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
    qt5.qmake
  ];

  # Without this, nothing gets installed in $out.
  postInstall = ''
    install -D FRequest $out/bin/FRequest
    install -D LinuxAppImageDeployment/frequest.desktop $out/share/applications/frequest.desktop
    install -D LinuxAppImageDeployment/frequest_icon.png $out/share/icons/hicolor/128x128/apps/frequest_icon.png
  '';

  meta = {
    description = "A fast, lightweight and opensource desktop application to make HTTP(s) requests";
    homepage = "https://fabiobento512.github.io/FRequest";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ eliandoran ];
    platforms = lib.platforms.linux;
    mainProgram = "frequest";
  };
})
