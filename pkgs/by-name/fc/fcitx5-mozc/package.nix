{
  bazel_6,
  buildBazelPackage,
  fcitx5,
  fetchFromGitHub,
  gettext,
  lib,
  mozc,
  nixosTests,
  pkg-config,
  protobuf_27,
  python3,
  stdenv,
  unzip,
}:

buildBazelPackage {
  pname = "fcitx5-mozc";
  version = "2.30.5544.102"; # make sure to update protobuf if needed

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "mozc";
    fetchSubmodules = true;
    rev = "57e67f2a25e4c0861e0e422da0c7d4c232d89fcc";
    hash = "sha256-1EZjEbMl+LRipH5gEgFpaKP8uEKPfupHmiiTNJc/T1k=";
  };

  nativeBuildInputs = [
    gettext
    pkg-config
    python3
    unzip
  ];

  buildInputs = [
    mozc
    fcitx5
  ];

  postPatch = ''
    # replace protobuf with our own
    rm -r src/third_party/protobuf
    cp -r ${protobuf_27.src} src/third_party/protobuf
    sed -i -e 's|^\(LINUX_MOZC_SERVER_DIR = \).\+|\1"${mozc}/lib/mozc"|' src/config.bzl
  '';

  bazel = bazel_6;
  removeRulesCC = false;
  dontAddBazelOpts = true;

  bazelFlags = [
    "--config"
    "oss_linux"
    "--compilation_mode"
    "opt"
  ];

  bazelTargets = [
    "unix/fcitx5:fcitx5-mozc.so"
    "unix/icons"
  ];

  fetchAttrs = {
    preInstall = ''
      rm -rf $bazelOut/external/fcitx5
    '';

    sha256 = "sha256-rrRp/v1pty7Py80/6I8rVVQvkeY72W+nlixUeYkjp+o=";
  };

  preConfigure = ''
    cd src
  '';

  buildAttrs = {
    installPhase = ''
      runHook preInstall

      install -Dm444 ../LICENSE $out/share/licenses/fcitx5-mozc/LICENSE
      install -Dm444 data/installer/credits_en.html $out/share/licenses/fcitx5-mozc/Submodules

      install -Dm555 bazel-bin/unix/fcitx5/fcitx5-mozc.so $out/lib/fcitx5/fcitx5-mozc.so
      install -Dm444 unix/fcitx5/mozc-addon.conf $out/share/fcitx5/addon/mozc.conf
      install -Dm444 unix/fcitx5/mozc.conf $out/share/fcitx5/inputmethod/mozc.conf

      for pofile in unix/fcitx5/po/*.po; do
        filename=$(basename $pofile)
        lang=''${filename/.po/}
        mofile=''${pofile/.po/.mo}
        msgfmt $pofile -o $mofile
        install -Dm444 $mofile $out/share/locale/$lang/LC_MESSAGES/fcitx5-mozc.mo
      done

      msgfmt --xml -d unix/fcitx5/po/ --template unix/fcitx5/org.fcitx.Fcitx5.Addon.Mozc.metainfo.xml.in -o unix/fcitx5/org.fcitx.Fcitx5.Addon.Mozc.metainfo.xml
      install -Dm444 unix/fcitx5/org.fcitx.Fcitx5.Addon.Mozc.metainfo.xml $out/share/metainfo/org.fcitx.Fcitx5.Addon.Mozc.metainfo.xml

      cd bazel-bin/unix

      unzip -o icons.zip

      # These are relative symlinks, they will always resolve to files within $out

      install -Dm444 mozc.png $out/share/icons/hicolor/128x128/apps/org.fcitx.Fcitx5.fcitx_mozc.png
      ln -s org.fcitx.Fcitx5.fcitx_mozc.png $out/share/icons/hicolor/128x128/apps/fcitx_mozc.png

      for svg in \
        alpha_full.svg \
        alpha_half.svg \
        direct.svg \
        hiragana.svg \
        katakana_full.svg \
        katakana_half.svg \
        outlined/dictionary.svg \
        outlined/properties.svg \
        outlined/tool.svg
      do
        name=$(basename -- $svg)
        path=$out/share/icons/hicolor/scalable/apps
        prefix=org.fcitx.Fcitx5.fcitx_mozc

        install -Dm444 $svg $path/$prefix_$name
        ln -s $prefix_$name $path/fcitx_mozc_$name
      done

      runHook postInstall
    '';
  };

  passthru.tests = lib.optionalAttrs stdenv.hostPlatform.isLinux {
    inherit (nixosTests) fcitx5;
  };

  meta = with lib; {
    description = "Mozc - a Japanese Input Method Editor designed for multi-platform";
    homepage = "https://github.com/fcitx/mozc";
    license = with licenses; [
      asl20 # abseil-cpp
      bsd3 # mozc, breakpad, gtest, gyp, japanese-usage-dictionary, protobuf
      mit # wil
      naist-2003 # IPAdic
      publicDomain # src/data/test/stress_test, Okinawa dictionary
      unicode-30 # src/data/unicode, breakpad
    ];
    maintainers = with maintainers; [
      berberman
      govanify
      musjj
    ];
    platforms = platforms.linux;
  };
}
