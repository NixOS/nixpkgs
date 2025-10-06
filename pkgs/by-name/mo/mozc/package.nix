{
  lib,
  buildBazelPackage,
  fetchFromGitHub,
  qt6,
  pkg-config,
  protobuf_27,
  bazel_7,
  ibus,
  unzip,
  xdg-utils,
  jp-zip-codes,
  dictionaries ? [ ],
  merge-ut-dictionaries,
}:

let
  ut-dictionary = merge-ut-dictionaries.override { inherit dictionaries; };
in
buildBazelPackage rec {
  pname = "mozc";
  version = "2.30.5544.102"; # make sure to update protobuf if needed

  src = fetchFromGitHub {
    owner = "google";
    repo = "mozc";
    tag = version;
    hash = "sha256-w0bjoMmq8gL7DSehEG7cKqp5e4kNOXnCYLW31Zl9FRs=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    pkg-config
    unzip
  ];

  buildInputs = [
    ibus
    qt6.qtbase
  ];

  dontAddBazelOpts = true;
  removeRulesCC = false;

  bazel = bazel_7;

  fetchAttrs = {
    hash = "sha256-c+v2vWvTmwJ7MFh3VJlUh+iSINjsX66W9K0UBX5K/1s=";

    preInstall = ''
      # Remove zip code data. It will be replaced with jp-zip-codes from nixpkgs
      rm -rv "$bazelOut"/external/zip_code_{jigyosyo,ken_all}
      # Remove references to buildInputs
      rm -rv "$bazelOut"/external/{ibus,qt_linux}
      # Remove reference to the host platform
      rm -rv "$bazelOut"/external/host_platform
    '';
  };

  bazelFlags = [
    "--config"
    "oss_linux"
    "--compilation_mode"
    "opt"
  ];

  bazelTargets = [ "package" ];

  postPatch = ''
    # replace protobuf with our own
    rm -r src/third_party/protobuf
    cp -r ${protobuf_27.src} src/third_party/protobuf
    substituteInPlace src/config.bzl \
      --replace-fail "/usr/bin/xdg-open" "${xdg-utils}/bin/xdg-open" \
      --replace-fail "/usr" "$out"
    substituteInPlace src/WORKSPACE.bazel \
      --replace-fail "https://www.post.japanpost.jp/zipcode/dl/kogaki/zip/ken_all.zip" "file://${jp-zip-codes}/ken_all.zip" \
      --replace-fail "https://www.post.japanpost.jp/zipcode/dl/jigyosyo/zip/jigyosyo.zip" "file://${jp-zip-codes}/jigyosyo.zip"
  '';

  preConfigure = ''
    cd src
  ''
  + lib.optionalString (dictionaries != [ ]) ''
    cat ${ut-dictionary}/mozcdic-ut.txt >> data/dictionary_oss/dictionary00.txt
  '';

  buildAttrs.installPhase = ''
    runHook preInstall

    unzip bazel-bin/unix/mozc.zip -x "tmp/*" -d /

    # create a desktop file for gnome-control-center
    # copied from ubuntu
    mkdir -p $out/share/applications
    cp ${./ibus-setup-mozc-jp.desktop} $out/share/applications/ibus-setup-mozc-jp.desktop
    substituteInPlace $out/share/applications/ibus-setup-mozc-jp.desktop \
      --replace-fail "@mozc@" "$out"

    runHook postInstall
  '';

  meta = with lib; {
    isIbusEngine = true;
    description = "Japanese input method from Google";
    mainProgram = "mozc_emacs_helper";
    homepage = "https://github.com/google/mozc";
    license = licenses.free;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      pineapplehunter
    ];
  };
}
