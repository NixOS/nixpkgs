{ stdenv, ninja, which, nodejs, fetchurl, gnutar

# default dependencies
, bzip2, flac, speex, libopus
, libevent, expat, libjpeg, snappy
, libpng, libcap
, xdg_utils, yasm, minizip, libwebp
, libusb1, pciutils, nss, re2, zlib, libvpx

, python2Packages, perl, pkgconfig
, nspr, systemd, kerberos
, utillinux, alsaLib
, bison, gperf
, glib, gtk2, gtk3, dbus_glib
, libXScrnSaver, libXcursor, libXtst, mesa
, protobuf, speechd, libXdamage, cups
, ffmpeg, harfbuzz, harfbuzz-icu, libxslt, libxml2

# optional dependencies
, libgcrypt ? null # gnomeSupport || cupsSupport
, libexif ? null # only needed for Chromium before version 51

# package customization
, enableNaCl ? false
, enableHotwording ? false
, enableWideVine ? false
, gnomeSupport ? false, gnome ? null
, gnomeKeyringSupport ? false, libgnome_keyring3 ? null
, proprietaryCodecs ? true
, cupsSupport ? true
, pulseSupport ? false, libpulseaudio ? null

}:

buildFun:

with stdenv.lib;

# see http://www.linuxfromscratch.org/blfs/view/cvs/xsoft/chromium.html

let
  # The additional attributes for creating derivations based on the chromium
  # source tree.
  extraAttrs = buildFun base;

  mkGnFlags =
    let
      # Serialize Nix types into GN types according to this document:
      # https://chromium.googlesource.com/chromium/src/+/master/tools/gn/docs/language.md
      mkGnString = value: "\"${escape ["\"" "$" "\\"] value}\"";
      sanitize = value:
        if value == true then "true"
        else if value == false then "false"
        else if isList value then "[${concatMapStringsSep ", " sanitize value}]"
        else if isInt value then toString value
        else if isString value then mkGnString value
        else throw "Unsupported type for GN value `${value}'.";
      toFlag = key: value: "${key}=${sanitize value}";
    in attrs: concatStringsSep " " (attrValues (mapAttrs toFlag attrs));

  gnSystemLibraries = [
    "flac" "harfbuzz-ng" "libwebp" "libxslt" "yasm" "snappy" "libpng" "zlib"
    # "libjpeg" # fails with multiple undefined references to chromium_jpeg_*
    # "re2" # fails with linker errors
    # "ffmpeg" # https://crbug.com/731766

    # "opus" # ungoogled-chromium fails
  ];

  opusWithCustomModes = libopus.override {
    withCustomModes = false;
  };

  defaultDependencies = [
    bzip2 flac speex #opusWithCustomModes
    libevent expat libjpeg snappy
    libpng libcap
    xdg_utils yasm minizip libwebp
    libusb1 re2 zlib
    ffmpeg harfbuzz-icu libxslt libxml2
  ];

  # build paths and release info
  packageName = extraAttrs.packageName or extraAttrs.name;
  version = "58.0.3029.110";
  buildType = "Release";
  buildPath = "out/${buildType}";
  libExecPath = "$out/libexec/${packageName}";

  freetype_source = fetchurl {
    url = http://anduin.linuxfromscratch.org/BLFS/other/chromium-freetype.tar.xz;
    sha256 = "1vhslc4xg0d6wzlsi99zpah2xzjziglccrxn55k7qna634wyxg77";
  };

  base = rec {
    name = "${packageName}-${version}";
    inherit version;
    inherit packageName buildType buildPath;

    src = fetchurl {
      url = "https://commondatastorage.googleapis.com/chromium-browser-official/chromium-${version}.tar.xz";
      #sha256 = "1r495ffcwxsd4pxn5akfr7k9iiv1dj0zq6w9i6xxii8knf8a40va";
      sha256 = "1zvqim75mlqckvf7awrbyggis71dlkz4gjpfrmfdvydcs8yyyk7j";
    };

    nativeBuildInputs = [
      ninja which python2Packages.python perl pkgconfig
      python2Packages.ply python2Packages.jinja2 nodejs
      gnutar
    ];

    buildInputs = defaultDependencies ++ [
      nspr nss systemd
      utillinux alsaLib
      bison gperf kerberos
      glib gtk2 gtk3 dbus_glib
      libXScrnSaver libXcursor libXtst mesa
      pciutils protobuf speechd libXdamage
    ] ++ optional gnomeKeyringSupport libgnome_keyring3
      ++ optionals gnomeSupport [ gnome.GConf libgcrypt ]
      ++ optionals cupsSupport [ libgcrypt cups ]
      ++ optional pulseSupport libpulseaudio;

    patches = [
      ./patches/nix_plugin_paths_52.patch
      # To enable ChromeCast, go to chrome://flags and set "Load Media Router Component Extension" to Enabled
      # Fixes Chromecast: https://bugs.chromium.org/p/chromium/issues/detail?id=734325
      ./patches/fix_network_api_crash.patch
      # As major versions are added, you can trawl the gentoo and arch repos at
      # https://gitweb.gentoo.org/repo/gentoo.git/plain/www-client/chromium/
      # https://git.archlinux.org/svntogit/packages.git/tree/trunk?h=packages/chromium
      # for updated patches and hints about build flags
      ### ungoogled-chromium patches
      ### currently unable to build with commented patches
      ./patches/ungoogled-chromium/iridium-browser/prefs-only-keep-cookies-until-exit.patch
      ./patches/ungoogled-chromium/iridium-browser/prefs-do-not-store-passwords-by-default.patch
      ./patches/ungoogled-chromium/iridium-browser/browser-disable-profile-auto-import-on-first-run.patch
      ./patches/ungoogled-chromium/iridium-browser/promo-disable-Google-promotion-fetching.patch
      ./patches/ungoogled-chromium/iridium-browser/net-cert-increase-default-key-length-for-newly-gener.patch
      ./patches/ungoogled-chromium/iridium-browser/updater-disable-auto-update.patch
      ./patches/ungoogled-chromium/iridium-browser/prefs-always-prompt-for-download-directory-by-defaul.patch
      ./patches/ungoogled-chromium/iridium-browser/all-add-trk-prefixes-to-possibly-evil-connections.patch
      ./patches/ungoogled-chromium/iridium-browser/safe_browsing-support-trk-prefix.patch
      ./patches/ungoogled-chromium/iridium-browser/net-add-trk-scheme-and-help-identify-URLs-being-retr.patch
      ./patches/ungoogled-chromium/iridium-browser/hotword-disable-at-build-time-by-default.patch
      ./patches/ungoogled-chromium/iridium-browser/safe_browsing-disable-reporting-of-safebrowsing-over.patch
      ./patches/ungoogled-chromium/iridium-browser/safe_browsing-disable-incident-reporting.patch
      ./patches/ungoogled-chromium/iridium-browser/mime_util-force-text-x-suse-ymp-to-be-downloaded.patch
      ./patches/ungoogled-chromium/iridium-browser/Remove-EV-certificates.patch
      ./patches/ungoogled-chromium/debian/fixes/gpu-timeout.patch
      ./patches/ungoogled-chromium/debian/fixes/widevine-revision.patch
      ./patches/ungoogled-chromium/debian/fixes/chromedriver-revision.patch
      ./patches/ungoogled-chromium/debian/fixes/ps-print.patch
      ./patches/ungoogled-chromium/debian/master-preferences.patch
      ./patches/ungoogled-chromium/debian/disable/promo.patch
      ./patches/ungoogled-chromium/debian/disable/external-components.patch
      ./patches/ungoogled-chromium/debian/disable/google-api-warning.patch
      ./patches/ungoogled-chromium/debian/disable/third-party-cookies.patch
      ./patches/ungoogled-chromium/debian/manpage.patch
      ./patches/ungoogled-chromium/debian/gn/buildflags.patch
      ./patches/ungoogled-chromium/debian/gn/callback.patch
      ./patches/ungoogled-chromium/debian/gn/parallel.patch
      #./patches/ungoogled-chromium/debian/system/event.patch
      ./patches/ungoogled-chromium/debian/system/icu.patch
      #./patches/ungoogled-chromium/debian/system/nspr.patch
      ./patches/ungoogled-chromium/debian/system/vpx.patch
      ./patches/ungoogled-chromium/debian/system/ffmpeg.patch
      ./patches/ungoogled-chromium/ungoogled-chromium/disable-rlz.patch
      ./patches/ungoogled-chromium/ungoogled-chromium/disable-signin.patch
      ./patches/ungoogled-chromium/ungoogled-chromium/disable-intranet-redirect-detector.patch
      ./patches/ungoogled-chromium/ungoogled-chromium/remove-get-help-button.patch
      ./patches/ungoogled-chromium/ungoogled-chromium/enable-page-saving-on-more-pages.patch
      ./patches/ungoogled-chromium/ungoogled-chromium/disable-gcm.patch
      #./patches/ungoogled-chromium/ungoogled-chromium/intercept-all-modified-domains.patch
      ./patches/ungoogled-chromium/ungoogled-chromium/disable-domain-reliability.patch
      ./patches/ungoogled-chromium/ungoogled-chromium/disable-logging-urls-to-stderr.patch
      ./patches/ungoogled-chromium/ungoogled-chromium/disable-fonts-googleapis-references.patch
      #./patches/ungoogled-chromium/ungoogled-chromium/linux/remove-new-flags.patch
      ./patches/ungoogled-chromium/ungoogled-chromium/disable-webstore-urls.patch
      ./patches/ungoogled-chromium/ungoogled-chromium/disable-formatting-in-omnibox.patch
      ./patches/ungoogled-chromium/ungoogled-chromium/disable-gaia.patch
      ./patches/ungoogled-chromium/ungoogled-chromium/disable-download-quarantine.patch
      ./patches/ungoogled-chromium/ungoogled-chromium/clear-http-auth-cache-menu-item.patch
      ./patches/ungoogled-chromium/ungoogled-chromium/disable-translate.patch
      ./patches/ungoogled-chromium/ungoogled-chromium/prevent-trace-url-requests.patch
      ./patches/ungoogled-chromium/ungoogled-chromium/gn-modify-hardcoded-settings.patch
      ./patches/ungoogled-chromium/ungoogled-chromium/add-ipv6-probing-option.patch
      ./patches/ungoogled-chromium/ungoogled-chromium/remove-disable-setuid-sandbox-as-bad-flag.patch
      ./patches/ungoogled-chromium/ungoogled-chromium/disable-google-host-detection.patch
      ./patches/ungoogled-chromium/ungoogled-chromium/macos/disable-symbol-order-verification.patch
      ./patches/ungoogled-chromium/ungoogled-chromium/macos/fix-widevine-macos.patch
      ./patches/ungoogled-chromium/ungoogled-chromium/macos/add-trknotify-gn-dependency.patch
      #./patches/ungoogled-chromium/ungoogled-chromium/windows/windows-use-system-binaries.patch
      #./patches/ungoogled-chromium/ungoogled-chromium/windows/windows-fix-missing-include-es_parser_adts-cc.patch
      #./patches/ungoogled-chromium/ungoogled-chromium/windows/windows-disable-reorder-fix-linking.patch
      #./patches/ungoogled-chromium/ungoogled-chromium/windows/windows-fix-gn-bootstrap.patch
      ./patches/ungoogled-chromium/ungoogled-chromium/fix-building-without-one-click-signin.patch
      #./patches/ungoogled-chromium/ungoogled-chromium/add-flag-to-disable-trkbar.patch
      ./patches/ungoogled-chromium/ungoogled-chromium/disable-crash-reporter.patch
      ./patches/ungoogled-chromium/ungoogled-chromium/disable-untraceable-urls.patch
      ./patches/ungoogled-chromium/ungoogled-chromium/popups-to-tabs.patch
      ./patches/ungoogled-chromium/ungoogled-chromium/change-trace-infobar-message.patch
      ./patches/ungoogled-chromium/ungoogled-chromium/replace-google-search-engine-with-nosearch.patch
      ./patches/ungoogled-chromium/ungoogled-chromium/disable-profile-avatar-downloading.patch
      ./patches/ungoogled-chromium/inox-patchset/0019-disable-battery-status-service.patch
      ./patches/ungoogled-chromium/inox-patchset/0011-add-duckduckgo-search-engine.patch
      ./patches/ungoogled-chromium/inox-patchset/0017-disable-new-avatar-menu.patch
      ./patches/ungoogled-chromium/inox-patchset/0010-disable-gcm-status-check.patch
      ./patches/ungoogled-chromium/inox-patchset/0007-disable-web-resource-service.patch
      ./patches/ungoogled-chromium/inox-patchset/0006-modify-default-prefs.patch
      ./patches/ungoogled-chromium/inox-patchset/0014-disable-translation-lang-fetch.patch
      ./patches/ungoogled-chromium/inox-patchset/0016-chromium-sandbox-pie.patch
      ./patches/ungoogled-chromium/inox-patchset/0004-disable-google-url-tracker.patch
      ./patches/ungoogled-chromium/inox-patchset/0005-disable-default-extensions.patch
      ./patches/ungoogled-chromium/inox-patchset/0001-fix-building-without-safebrowsing.patch
      ./patches/ungoogled-chromium/inox-patchset/0018-disable-first-run-behaviour.patch
      ./patches/ungoogled-chromium/inox-patchset/0015-disable-update-pings.patch
      ./patches/ungoogled-chromium/inox-patchset/0008-restore-classic-ntp.patch
      ./patches/ungoogled-chromium/inox-patchset/0003-disable-autofill-download-manager.patch
    ]
      ++ optional enableWideVine ./patches/widevine.patch;

    postPatch = ''
      # We want to be able to specify where the sandbox is via CHROME_DEVEL_SANDBOX
      substituteInPlace sandbox/linux/suid/client/setuid_sandbox_host.cc \
        --replace \
          'return sandbox_binary;' \
          'return base::FilePath(GetDevelSandboxPath());'

      sed -i -e '/lib_loader.*Load/s!"\(libudev\.so\)!"${systemd.lib}/lib/\1!' \
        device/udev_linux/udev?_loader.cc

      sed -i -e '/libpci_loader.*Load/s!"\(libpci\.so\)!"${pciutils}/lib/\1!' \
        gpu/config/gpu_info_collector_linux.cc

      sed -i -re 's/([^:])\<(isnan *\()/\1std::\2/g' \
        chrome/browser/ui/webui/engagement/site_engagement_ui.cc

      sed -i -e '/#include/ {
        i #include <algorithm>
        :l; n; bl
      }' gpu/config/gpu_control_list.cc

      # Allow to put extensions into the system-path.
      sed -i -e 's,/usr,/run/current-system/sw,' chrome/common/chrome_paths.cc

      patchShebangs .
      # use our own nodejs
      mkdir -p third_party/node/linux/node-linux-x64/bin
      ln -s $(which node) third_party/node/linux/node-linux-x64/bin/node

      # use patched freetype
      # FIXME https://bugs.chromium.org/p/pdfium/issues/detail?id=733
      # FIXME http://savannah.nongnu.org/bugs/?51156
      tar -xJf ${freetype_source}

      # remove unused third-party
      for lib in ${toString gnSystemLibraries}; do
        find -type f -path "*third_party/$lib/*"     \
            \! -path "*third_party/$lib/chromium/*"  \
            \! -path "*third_party/$lib/google/*"    \
            \! -path "*base/third_party/icu/*"       \
            \! -path "*base/third_party/libevent/*"  \
            \! -regex '.*\.\(gn\|gni\|isolate\|py\)' \
            -delete
      done
    '';

    gnFlags = mkGnFlags ({
      linux_use_bundled_binutils = false;
      use_gold = true;
      gold_path = "${stdenv.cc}/bin";
      is_debug = false;

      proprietary_codecs = false;
      use_sysroot = false;
      use_gnome_keyring = gnomeKeyringSupport;
      use_gconf = gnomeSupport;
      use_gio = gnomeSupport;
      enable_nacl = enableNaCl;
      enable_hotwording = enableHotwording;
      enable_widevine = enableWideVine;
      use_cups = cupsSupport;

      treat_warnings_as_errors = false;
      is_clang = false;
      clang_use_chrome_plugins = false;
      remove_webcore_debug_symbols = true;
      use_gtk3 = true;
      enable_swiftshader = false;
      fieldtrial_testing_like_official_build = true;

      # Google API keys, see:
      #   http://www.chromium.org/developers/how-tos/api-keys
      # Note: These are for NixOS/nixpkgs use ONLY. For your own distribution,
      # please get your own set of keys.
      google_api_key = "AIzaSyDGi15Zwl11UNe6Y-5XW_upsfyw31qwZPI";
      google_default_client_id = "404761575300.apps.googleusercontent.com";
      google_default_client_secret = "9rIFQjfnkykEmqb6FfjJQD1D";
    } // optionalAttrs proprietaryCodecs {
      # enable support for the H.264 codec
      proprietary_codecs = true;
      enable_hangout_services_extension = true;
      ffmpeg_branding = "Chrome";
    } // optionalAttrs pulseSupport {
      use_pulseaudio = true;
      link_pulseaudio = true;
    } // (extraAttrs.gnFlags or {}));

    configurePhase = ''
      runHook preConfigure

      # Build gn
      python tools/gn/bootstrap/bootstrap.py -v -s --no-clean
      PATH="$PWD/out/Release:$PATH"

      # This is to ensure expansion of $out.
      libExecPath="${libExecPath}"
      python build/linux/unbundle/replace_gn_files.py \
        --system-libraries ${toString gnSystemLibraries}
      gn gen --args=${escapeShellArg gnFlags} out/Release

      runHook postConfigure
    '';

    buildPhase = let
      # Build paralelism: on Hydra the build was frequently running into memory
      # exhaustion, and even other users might be running into similar issues.
      # -j is halved to avoid memory problems, and -l is slightly increased
      # so that the build gets slight preference before others
      # (it will often be on "critical path" and at risk of timing out)
      buildCommand = target: ''
        ninja -C "${buildPath}"  \
          -j$(( ($NIX_BUILD_CORES+1) / 2 )) -l$(( $NIX_BUILD_CORES+1 )) \
          "${target}"
      '' + optionalString (target == "mksnapshot" || target == "chrome") ''
        paxmark m "${buildPath}/${target}"
      '';
      targets = extraAttrs.buildTargets or [];
      commands = map buildCommand targets;
    in concatStringsSep "\n" commands;
  };

# Remove some extraAttrs we supplied to the base attributes already.
in stdenv.mkDerivation (base // removeAttrs extraAttrs [
  "name" "gnFlags" "buildTargets"
])
