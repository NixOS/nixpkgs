{ stdenv, llvmPackages, gn, ninja, which, nodejs, fetchpatch, gnutar

# default dependencies
, bzip2, flac, speex, libopus
, libevent, expat, libjpeg, snappy
, libpng, libcap
, xdg_utils, yasm, minizip, libwebp
, libusb1, pciutils, nss, re2, zlib

, python2Packages, perl, pkgconfig
, nspr, systemd, kerberos
, utillinux, alsaLib
, bison, gperf
, glib, gtk3, dbus-glib
, glibc
, libXScrnSaver, libXcursor, libXtst, libGLU, libGL
, protobuf, speechd, libXdamage, cups
, ffmpeg, libxslt, libxml2, at-spi2-core
, jre

# optional dependencies
, libgcrypt ? null # gnomeSupport || cupsSupport
, libva ? null # useVaapi

# package customization
, useVaapi ? false
, gnomeSupport ? false, gnome ? null
, gnomeKeyringSupport ? false, libgnome-keyring3 ? null
, proprietaryCodecs ? true
, cupsSupport ? true
, pulseSupport ? false, libpulseaudio ? null

, upstream-info
}:

buildFun:

with stdenv.lib;

# see http://www.linuxfromscratch.org/blfs/view/cvs/xsoft/chromium.html

let
  # The additional attributes for creating derivations based on the chromium
  # source tree.
  extraAttrs = buildFun base;

  githubPatch = commit: sha256: fetchpatch {
    url = "https://github.com/chromium/chromium/commit/${commit}.patch";
    inherit sha256;
  };

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
    "flac" "libwebp" "libxslt" "yasm" "opus" "snappy" "libpng"
    # "zlib" # version 77 reports unresolved dependency on //third_party/zlib:zlib_config
    # "libjpeg" # fails with multiple undefined references to chromium_jpeg_*
    # "re2" # fails with linker errors
    # "ffmpeg" # https://crbug.com/731766
    # "harfbuzz-ng" # in versions over 63 harfbuzz and freetype are being built together
                    # so we can't build with one from system and other from source
  ];

  opusWithCustomModes = libopus.override {
    withCustomModes = true;
  };

  defaultDependencies = [
    bzip2 flac speex opusWithCustomModes
    libevent expat libjpeg snappy
    libpng libcap
    xdg_utils yasm minizip libwebp
    libusb1 re2 zlib
    ffmpeg libxslt libxml2
    # harfbuzz # in versions over 63 harfbuzz and freetype are being built together
               # so we can't build with one from system and other from source
  ];

  # build paths and release info
  packageName = extraAttrs.packageName or extraAttrs.name;
  buildType = "Release";
  buildPath = "out/${buildType}";
  libExecPath = "$out/libexec/${packageName}";

  versionRange = min-version: upto-version:
    let inherit (upstream-info) version;
        result = versionAtLeast version min-version && versionOlder version upto-version;
        stable-version = (import ./upstream-info.nix).stable.version;
    in if versionAtLeast stable-version upto-version
       then warn "chromium: stable version ${stable-version} is newer than a patchset bounded at ${upto-version}. You can safely delete it."
            result
       else result;

  base = rec {
    name = "${packageName}-unwrapped-${version}";
    inherit (upstream-info) channel version;
    inherit packageName buildType buildPath;

    src = upstream-info.main;

    nativeBuildInputs = [
      ninja which python2Packages.python perl pkgconfig
      python2Packages.ply python2Packages.jinja2 nodejs
      gnutar
    ];

    buildInputs = defaultDependencies ++ [
      nspr nss systemd
      utillinux alsaLib
      bison gperf kerberos
      glib gtk3 dbus-glib
      libXScrnSaver libXcursor libXtst libGLU libGL
      pciutils protobuf speechd libXdamage at-spi2-core
      jre
    ] ++ optional gnomeKeyringSupport libgnome-keyring3
      ++ optionals gnomeSupport [ gnome.GConf libgcrypt ]
      ++ optionals cupsSupport [ libgcrypt cups ]
      ++ optional useVaapi libva
      ++ optional pulseSupport libpulseaudio;

    patches = [
      ./patches/nix_plugin_paths_68.patch
      ./patches/remove-webp-include-69.patch
      ./patches/no-build-timestamps.patch
      ./patches/widevine-79.patch
      ./patches/dont-use-ANGLE-by-default.patch
      # Unfortunately, chromium regularly breaks on major updates and
      # then needs various patches backported in order to be compiled with GCC.
      # Good sources for such patches and other hints:
      # - https://gitweb.gentoo.org/repo/gentoo.git/plain/www-client/chromium/
      # - https://git.archlinux.org/svntogit/packages.git/tree/trunk?h=packages/chromium
      # - https://github.com/chromium/chromium/search?q=GCC&s=committer-date&type=Commits
      #
      # ++ optionals (channel == "dev") [ ( githubPatch "<patch>" "0000000000000000000000000000000000000000000000000000000000000000" ) ]
      # ++ optional (versionRange "68" "72") ( githubPatch "<patch>" "0000000000000000000000000000000000000000000000000000000000000000" )
    ] ++ optionals (useVaapi) [
      # source: https://aur.archlinux.org/cgit/aur.git/tree/vaapi-fix.patch?h=chromium-vaapi
      ./patches/vaapi-fix.patch
    ];

    postPatch = ''
      # We want to be able to specify where the sandbox is via CHROME_DEVEL_SANDBOX
      substituteInPlace sandbox/linux/suid/client/setuid_sandbox_host.cc \
        --replace \
          'return sandbox_binary;' \
          'return base::FilePath(GetDevelSandboxPath());'

      substituteInPlace services/audio/audio_sandbox_hook_linux.cc \
        --replace \
          '/usr/share/alsa/' \
          '${alsaLib}/share/alsa/' \
        --replace \
          '/usr/lib/x86_64-linux-gnu/gconv/' \
          '${glibc}/lib/gconv/' \
        --replace \
          '/usr/share/locale/' \
          '${glibc}/share/locale/'

      sed -i -e 's@"\(#!\)\?.*xdg-@"\1${xdg_utils}/bin/xdg-@' \
        chrome/browser/shell_integration_linux.cc

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

      # remove unused third-party
      # in third_party/crashpad third_party/zlib contains just a header-adapter
      for lib in ${toString gnSystemLibraries}; do
        find -type f -path "*third_party/$lib/*"     \
            \! -path "*third_party/crashpad/crashpad/third_party/zlib/*"  \
            \! -path "*third_party/$lib/chromium/*"  \
            \! -path "*third_party/$lib/google/*"    \
            \! -path "*base/third_party/icu/*"       \
            \! -path "*base/third_party/libevent/*"  \
            \! -regex '.*\.\(gn\|gni\|isolate\|py\)' \
            -delete
      done
    '' + optionalString stdenv.isAarch64 ''
      substituteInPlace build/toolchain/linux/BUILD.gn \
        --replace 'toolprefix = "aarch64-linux-gnu-"' 'toolprefix = ""'
    '' + optionalString stdenv.cc.isClang ''
      mkdir -p third_party/llvm-build/Release+Asserts/bin
      ln -s ${stdenv.cc}/bin/clang              third_party/llvm-build/Release+Asserts/bin/clang
      ln -s ${stdenv.cc}/bin/clang++            third_party/llvm-build/Release+Asserts/bin/clang++
      ln -s ${llvmPackages.llvm}/bin/llvm-ar    third_party/llvm-build/Release+Asserts/bin/llvm-ar
    '';

    gnFlags = mkGnFlags ({
      linux_use_bundled_binutils = false;
      use_lld = false;
      use_gold = true;
      gold_path = "${stdenv.cc}/bin";
      is_debug = false;

      proprietary_codecs = false;
      use_sysroot = false;
      use_gnome_keyring = gnomeKeyringSupport;
      use_gio = gnomeSupport;
      # ninja: error: '../../native_client/toolchain/linux_x86/pnacl_newlib/bin/x86_64-nacl-objcopy',
      # needed by 'nacl_irt_x86_64.nexe', missing and no known rule to make it
      enable_nacl = false;
      # Enabling the Widevine component here doesn't affect whether we can
      # redistribute the chromium package; the Widevine component is either
      # added later in the wrapped -wv build or downloaded from Google.
      enable_widevine = true;
      use_cups = cupsSupport;

      treat_warnings_as_errors = false;
      is_clang = stdenv.cc.isClang;
      clang_use_chrome_plugins = false;
      blink_symbol_level = 0;
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
    } // optionalAttrs useVaapi {
      use_vaapi = true;
    } // optionalAttrs pulseSupport {
      use_pulseaudio = true;
      link_pulseaudio = true;
    } // (extraAttrs.gnFlags or {}));

    configurePhase = ''
      runHook preConfigure

      # This is to ensure expansion of $out.
      libExecPath="${libExecPath}"
      python build/linux/unbundle/replace_gn_files.py \
        --system-libraries ${toString gnSystemLibraries}
      ${gn}/bin/gn gen --args=${escapeShellArg gnFlags} out/Release | tee gn-gen-outputs.txt

      # Fail if `gn gen` contains a WARNING.
      grep -o WARNING gn-gen-outputs.txt && echo "Found gn WARNING, exiting nix build" && exit 1

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
        (
          source chrome/installer/linux/common/installer.include
          PACKAGE=$packageName
          MENUNAME="Chromium"
          process_template chrome/app/resources/manpage.1.in "${buildPath}/chrome.1"
        )
      '';
      targets = extraAttrs.buildTargets or [];
      commands = map buildCommand targets;
    in concatStringsSep "\n" commands;

    postFixup = ''
      # Make sure that libGLESv2 is found by dlopen (if using EGL).
      chromiumBinary="$libExecPath/$packageName"
      origRpath="$(patchelf --print-rpath "$chromiumBinary")"
      patchelf --set-rpath "${libGL}/lib:$origRpath" "$chromiumBinary"
    '';
  };

# Remove some extraAttrs we supplied to the base attributes already.
in stdenv.mkDerivation (base // removeAttrs extraAttrs [
  "name" "gnFlags" "buildTargets"
])
