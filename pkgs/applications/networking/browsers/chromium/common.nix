{ stdenv, llvmPackages, gn, ninja, which, nodejs, fetchurl, fetchpatch, gnutar

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
, glib, gtk2, gtk3, dbus-glib
, glibc
, libXScrnSaver, libXcursor, libXtst, libGLU_combined
, protobuf, speechd, libXdamage, cups
, ffmpeg, libxslt, libxml2, at-spi2-core
, jdk

# optional dependencies
, libgcrypt ? null # gnomeSupport || cupsSupport
, libxkbcommon, libdrm, wayland # useOzone

# package customization
, enableNaCl ? false
, enableWideVine ? false
, useOzone ? false
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

  igaliaPatch = commit: sha256: fetchpatch {
    url = "https://github.com/Igalia/chromium/commit/${commit}.patch";
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
    "flac" "libwebp" "libxslt" "yasm" "opus" "snappy" "libpng" "zlib"
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
    name = "${packageName}-${version}";
    inherit (upstream-info) version;
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
      glib gtk2 gtk3 dbus-glib
      libXScrnSaver libXcursor libXtst libGLU_combined
      pciutils protobuf speechd libXdamage at-spi2-core
    ] ++ optional gnomeKeyringSupport libgnome-keyring3
      ++ optionals gnomeSupport [ gnome.GConf libgcrypt ]
      ++ optionals cupsSupport [ libgcrypt cups ]
      ++ optional pulseSupport libpulseaudio
      ++ optionals useOzone [ libxkbcommon libdrm wayland ]
      ++ optional (versionAtLeast version "72") jdk.jre;

    patches = optional enableWideVine ./patches/widevine.patch ++ [
      ./patches/nix_plugin_paths_68.patch
      ./patches/remove-webp-include-69.patch

      # Unfortunately, chromium regularly breaks on major updates and
      # then needs various patches backported in order to be compiled with GCC.
      # Good sources for such patches and other hints:
      # - https://gitweb.gentoo.org/repo/gentoo.git/plain/www-client/chromium/
      # - https://git.archlinux.org/svntogit/packages.git/tree/trunk?h=packages/chromium
      # - https://github.com/chromium/chromium/search?q=GCC&s=committer-date&type=Commits
      #
      # ++ optional (versionRange "68" "72") ( githubPatch "<patch>" "0000000000000000000000000000000000000000000000000000000000000000" )
    ] ++ optionals (!stdenv.cc.isClang && (versionRange "71" "72")) [
      ( githubPatch "65be571f6ac2f7942b4df9e50b24da517f829eec" "1sqv0aba0mpdi4x4f21zdkxz2cf8ji55ffgbfcr88c5gcg0qn2jh" )
    ] ++ optionals (useOzone && (versionRange "74" "99")) [
      # Go to latest ozone-wayland-dev tag and copy extra commits here
      # https://github.com/Igalia/chromium/commits/ozone-wayland-dev-74.0.3718.0/r635050
      ( igaliaPatch "0af0494e0cdf8319e00e0d07d3700411d6030630" "01838j00f4fwvgisa2g4s109xc9v944wah3y8x60y56gkhjxkzfr" )
      #( igaliaPatch "94c4cd50f69381d4fc989b6bc7569fc7cb6b3c95" "0b07y8a2jrrziajp16k3zgx2yv09ff0av1p970kwnzixflmp4lbg" )
      #( igaliaPatch "6e49d60d38a68ee9e804c50c770618129bc7ba5f" "0z3xw0pya2pr81fvrij2y0kz0479axdmm99ghaqn13ny6wnp5vin" )
      ( igaliaPatch "6168792c37cc7073fe424f4c4c2fc9a6d2d0503e" "15j81c831mksn0sif0f468lyrb1bn00h5xw0nx8ils9n37v8pqcx" )
      ( igaliaPatch "509c1331a6ecbe2d282a4da7e48637cc2330d055" "07aw7i53i45wy0xkn2qkrrp8q5bph1jgadw20j6kz7fc2vdqzii3" )
      ( igaliaPatch "db2948203578a9b1671bca86c1efbabc3dd51e7b" "0ga9bdn0ahwv8sw009s67zp2kac9zy6297j47sbpadzffg2vbnbd" )
      ( igaliaPatch "6727ef6196c31b1d13ecf8129bb975500e544ff9" "1kzjr34izh4qna1ylpjg3kqw46zwdag21xnn5hhsly6a9764cs7a" )
      ( igaliaPatch "0ed9ef9d7a46edc116b8e270efbc9529584b2f71" "0a5p40hv64dixixc0aphc0y9r33pvrq2zzl6br9w6b0fijr62nzp" )
      ( igaliaPatch "987b1d9c1ffbe28d8aa116393c78b24394993a57" "1a8qp974d79nfcbvbja9n889pgkjx9na3ppadhm1lb7x1bcx5227" )
      ( igaliaPatch "f225f4d45dd300dd6d99391f4cc49ac9e01c5eb5" "1ilxsa0kap4vlgjylkfgx2mp9xmljz9kfm8hcrqbdq34b1zkvzbq" )
      ( igaliaPatch "232a93763950ab98e9d855580ffb65c341c7f85b" "0jwid7n1ldbcmkzaxfmhzq0d47c1cmr0aixmlgy1nisk2h9g96hi" )
      ( igaliaPatch "9c61d3259e584cf6f70c49d96b49320000071296" "00xk3700h70v15yjqn2lbymrd3yfbiiibshx1yvvvcg6idlb3yfj" )
      ( igaliaPatch "92c1adf73437784bae00ae3f011dc9e94d4906fe" "01gyknz1v04vgm3a9sqwji0xm00iq2aipjgzffanaa47h8wmrpir" )
    ] ++ optional stdenv.isAarch64
           (if (versionOlder version "71") then
              fetchpatch {
                url       = https://raw.githubusercontent.com/OSSystems/meta-browser/e4a667deaaf9a26a3a1aeb355770d1f29da549ad/recipes-browser/chromium/files/aarch64-skia-build-fix.patch;
                sha256    = "0dkchqair8cy2f5a5p5vi24r9b4d28pgn2bfvm1568lypbjw6iab";
              }
            else
              fetchpatch {
                url       = https://raw.githubusercontent.com/OSSystems/meta-browser/e4a667deaaf9a26a3a1aeb355770d1f29da549ad/recipes-browser/chromium/files/aarch64-skia-build-fix.patch;
                postFetch = "substituteInPlace $out --replace __aarch64__ SK_CPU_ARM64";
                sha256    = "018fbdzyw9rvia8m0qkk5gv8q8gl7x34rrjbn7mi1fgxdsayn22s";
              }
            );

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
      # at least 2X compilation speedup
      use_jumbo_build = true;

      proprietary_codecs = false;
      use_sysroot = false;
      use_gnome_keyring = gnomeKeyringSupport;
      use_gio = gnomeSupport;
      enable_nacl = enableNaCl;
      enable_widevine = enableWideVine;
      use_cups = cupsSupport;

      treat_warnings_as_errors = false;
      is_clang = stdenv.cc.isClang;
      clang_use_chrome_plugins = false;
      remove_webcore_debug_symbols = true;
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
    } // optionalAttrs useOzone {
      use_ozone = true;
      ozone_auto_platforms = false;
      ozone_platform = "wayland";
      ozone_platform_wayland = true;
      ozone_platform_x11 = true;
      ozone_platform_headless = true;
      use_intel_minigbm = true;
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
  };

# Remove some extraAttrs we supplied to the base attributes already.
in stdenv.mkDerivation (base // removeAttrs extraAttrs [
  "name" "gnFlags" "buildTargets"
])
