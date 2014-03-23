{ stdenv, fetchurl, ninja, which

# default dependencies
, bzip2, flac, speex, icu, libopus
, libevent, expat, libjpeg, snappy
, libpng, libxml2, libxslt, v8
, xdg_utils, yasm, minizip, libwebp
, libusb1, libexif, pciutils

, python, pythonPackages, perl, pkgconfig
, nspr, udev, krb5
, utillinux, alsaLib
, gcc, bison, gperf
, glib, gtk, dbus_glib
, libXScrnSaver, libXcursor, libXtst, mesa
, protobuf, speechd, libXdamage

# optional dependencies
, libgcrypt ? null # gnomeSupport || cupsSupport

# package customization
, enableSELinux ? false, libselinux ? null
, enableNaCl ? false
, useOpenSSL ? false, nss ? null, openssl ? null
, gnomeSupport ? false, gnome ? null
, gnomeKeyringSupport ? false, libgnome_keyring3 ? null
, proprietaryCodecs ? true
, cupsSupport ? false
, pulseSupport ? false, pulseaudio ? null

, source
, plugins
}:

with stdenv.lib;

let

  mkGypFlags =
    let
      sanitize = value:
        if value == true then "1"
        else if value == false then "0"
        else "${value}";
      toFlag = key: value: "-D${key}=${sanitize value}";
    in attrs: concatStringsSep " " (attrValues (mapAttrs toFlag attrs));

  gypFlagsUseSystemLibs = {
    use_system_bzip2 = true;
    use_system_flac = true;
    use_system_libevent = true;
    use_system_libexpat = true;
    use_system_libexif = true;
    use_system_libjpeg = true;
    use_system_libpng = true;
    use_system_libwebp = true;
    use_system_libxml = true;
    use_system_opus = true;
    use_system_snappy = true;
    use_system_speex = true;
    use_system_ssl = useOpenSSL;
    use_system_stlport = true;
    use_system_xdg_utils = true;
    use_system_yasm = true;
    use_system_zlib = true;
    use_system_protobuf = true;

    use_system_harfbuzz = false;
    use_system_icu = false; # Doesn't support ICU 52 yet.
    use_system_libusb = false; # http://crbug.com/266149
    use_system_skia = false;
    use_system_sqlite = false; # http://crbug.com/22208
    use_system_v8 = !versionOlder source.version "34.0.0.0";
  };

  defaultDependencies = [
    bzip2 flac speex icu libopus
    libevent expat libjpeg snappy
    libpng libxml2 libxslt v8
    xdg_utils yasm minizip libwebp
    libusb1 libexif
  ];

  # build paths and release info
  packageName = "chromium";
  buildType = "Release";
  buildPath = "out/${buildType}";
  libExecPath = "$out/libexec/${packageName}";

in stdenv.mkDerivation rec {
  name = "${packageName}-browser-${source.version}";
  inherit packageName;
  src = source;

  buildInputs = defaultDependencies ++ [
    which
    python perl pkgconfig
    nspr udev
    (if useOpenSSL then openssl else nss)
    utillinux alsaLib
    gcc bison gperf
    gcc bison gperf krb5
    glib gtk dbus_glib
    libXScrnSaver libXcursor libXtst mesa
    pciutils protobuf speechd libXdamage
    pythonPackages.gyp
  ] ++ optional gnomeKeyringSupport libgnome_keyring3
    ++ optionals gnomeSupport [ gnome.GConf libgcrypt ]
    ++ optional enableSELinux libselinux
    ++ optional cupsSupport libgcrypt
    ++ optional pulseSupport pulseaudio;

  prePatch = let
    lntree = [ "cp" "-dsr" "--no-preserve=mode" ];
    lntreeList = concatStringsSep ", " (map (arg: "'${arg}'") lntree);
    lntreeSh = concatStringsSep " " lntree;
  in ''
    ${lntreeSh} "${source.main}"/* .
    ${lntreeSh} "${source.sandbox}" sandbox

    ensureDir third_party

    # ONLY the dependencies we can't use from nixpkgs!
    for bundled in ${concatStringsSep " " ([
      # This is in preparation of splitting up the bundled sources into separate
      # derivations so we some day can tremendously reduce build time.
      "adobe"
      "angle"
      "cacheinvalidation"
      "cld_2"
      "codesighs"
      "cros_dbus_cplusplus"
      "cros_system_api"
      "flot"
      "freetype2"
      "hunspell"
      "iccjpeg"
      "jinja2"
      "JSON"
      "jstemplate"
      "khronos"
      "leveldatabase"
      "libaddressinput"
      "libjingle"
      "libmtp"
      "libphonenumber"
      "libsrtp"
      "libXNVCtrl"
      "libyuv"
      "lss"
      "lzma_sdk"
      "markupsafe"
      "mesa"
      "modp_b64"
      "mt19937ar"
      "mtpd"
      "npapi"
      "ots"
      "ply"
      "protobuf"
      "qcms"
      "readability"
      "safe_browsing"
      "sfntly"
      "skia"
      "smhasher"
      "speech-dispatcher"
      "tcmalloc"
      "trace-viewer"
      "undoview"
      "usb_ids"
      "usrsctp"
      "WebKit"
      "webrtc"
      "widevine"
      "x86inc"
      "yasm"
    ] ++ optionals (!versionOlder source.version "34.0.0.0") [
      "brotli"
      "libwebm"
      "nss.isolate"
      "polymer"
    ])}; do
      echo -n "Linking ${source.bundled}/$bundled to third_party/..." >&2
      ${lntreeSh} "${source.bundled}/$bundled" third_party/
      echo " done." >&2
    done

    # Everything else is decided based on gypFlags.
    PYTHONPATH="build/linux/unbundle:$PYTHONPATH" python <<PYTHON
    import os, sys, subprocess
    from replace_gyp_files import REPLACEMENTS
    for flag, path in REPLACEMENTS.items():
      if path.startswith("v8/"):
        continue
      if "-D{0}=1".format(flag) in os.environ.get('gypFlags'):
        target = os.path.join("build/linux/unbundle", os.path.basename(path))
        dest = path
      else:
        target_base = os.path.basename(os.path.dirname(path))
        target = os.path.join("${source.bundled}", target_base)
        dest = os.path.join("third_party", target_base)
      try:
        os.makedirs(os.path.dirname(dest))
      except:
        pass
      sys.stderr.write("Linking {0} to {1}...".format(target, dest))
      subprocess.check_call([${lntreeList}, os.path.abspath(target), dest])
      sys.stderr.write(" done.\n")
    PYTHON

    # Auxilliary files needed in unbundled trees
    ${lntreeSh} "${source.bundled}/libxml/chromium" third_party/libxml/chromium
    ${lntreeSh} "${source.bundled}/zlib/google" third_party/zlib/google

    find -iname '*.gyp*' \( -type f -o -type l \) \
      -exec sed -i -e 's|<(DEPTH)|'"$(pwd)"'|g' {} +

    # XXX: Really ugly workaround to fix improper symlink dereference.
    sed -i -e '/args\['"'"'name'"'"'\] *= *parts\[0\]$/ {
      s|$|.split("-bundled/WebKit/Source/", 1)[1] |;
      s|$|if parts[0].startswith("../") else parts[0]|;
    }' third_party/WebKit/Source/build/scripts/in_file.py \
       third_party/WebKit/Source/build/scripts/make_event_factory.py
  '' + optionalString (!versionOlder source.version "35.0.0.0") ''
    # Transform symlinks into plain files
    sed -i -e "" third_party/jinja2/__init__.py \
                 third_party/jinja2/environment.py \
                 third_party/WebKit/Source/bindings/scripts/idl_compiler.py

    sed -i -e '/tools_dir *=/s|=.*|= "'"$(pwd)"'/tools"|' \
      third_party/WebKit/Source/bindings/scripts/blink_idl_parser.py
  '';

  postPatch = ''
    sed -i -e '/base::FilePath exe_dir/,/^ *} *$/c \
      sandbox_binary = base::FilePath(getenv("CHROMIUM_SANDBOX_BINARY_PATH"));
    ' content/browser/browser_main_loop.cc
  '';

  gypFlags = mkGypFlags (gypFlagsUseSystemLibs // {
    linux_use_gold_binary = false;
    linux_use_gold_flags = false;
    proprietary_codecs = false;
    use_gnome_keyring = gnomeKeyringSupport;
    use_gconf = gnomeSupport;
    use_gio = gnomeSupport;
    use_pulseaudio = pulseSupport;
    disable_nacl = !enableNaCl;
    use_openssl = useOpenSSL;
    selinux = enableSELinux;
    use_cups = cupsSupport;
    linux_sandbox_chrome_path="${libExecPath}/${packageName}";
    werror = "";

    # Google API keys, see http://www.chromium.org/developers/how-tos/api-keys.
    # Note: These are for NixOS/nixpkgs use ONLY. For your own distribution,
    # please get your own set of keys.
    google_api_key = "AIzaSyDGi15Zwl11UNe6Y-5XW_upsfyw31qwZPI";
    google_default_client_id = "404761575300.apps.googleusercontent.com";
    google_default_client_secret = "9rIFQjfnkykEmqb6FfjJQD1D";

  } // optionalAttrs proprietaryCodecs {
    # enable support for the H.264 codec
    proprietary_codecs = true;
    ffmpeg_branding = "Chrome";
  } // optionalAttrs (stdenv.system == "x86_64-linux") {
    target_arch = "x64";
    python_arch = "x86-64";
  } // optionalAttrs (stdenv.system == "i686-linux") {
    target_arch = "ia32";
    python_arch = "ia32";
  });

  configurePhase = ''
    python build/gyp_chromium -f ninja --depth "$(pwd)" ${gypFlags}
  '';

  buildPhase = let
    CC = "${gcc}/bin/gcc";
    CXX = "${gcc}/bin/g++";
  in ''
    CC="${CC}" CC_host="${CC}"     \
    CXX="${CXX}" CXX_host="${CXX}" \
    LINK_host="${CXX}"             \
      "${ninja}/bin/ninja" -C "${buildPath}"  \
        -j$NIX_BUILD_CORES -l$NIX_BUILD_CORES \
        chrome
  '';

  installPhase = ''
    ensureDir "${libExecPath}"
    cp -v "${buildPath}/"*.pak "${libExecPath}/"
    ${optionalString (!versionOlder source.version "34.0.0.0") ''
    cp -v "${buildPath}/icudtl.dat" "${libExecPath}/"
    ''}
    cp -vR "${buildPath}/locales" "${buildPath}/resources" "${libExecPath}/"
    cp -v ${buildPath}/libffmpegsumo.so "${libExecPath}/"

    cp -v "${buildPath}/chrome" "${libExecPath}/${packageName}"

    mkdir -vp "$out/share/man/man1"
    cp -v "${buildPath}/chrome.1" "$out/share/man/man1/${packageName}.1"

    for icon_file in chrome/app/theme/chromium/product_logo_*[0-9].png; do
      num_and_suffix="''${icon_file##*logo_}"
      icon_size="''${num_and_suffix%.*}"
      expr "$icon_size" : "^[0-9][0-9]*$" || continue
      logo_output_prefix="$out/share/icons/hicolor"
      logo_output_path="$logo_output_prefix/''${icon_size}x''${icon_size}/apps"
      mkdir -vp "$logo_output_path"
      cp -v "$icon_file" "$logo_output_path/${packageName}.png"
    done
  '';

  meta = {
    description = "An open source web browser from Google";
    homepage = http://www.chromium.org/;
    maintainers = with maintainers; [ goibhniu chaoflow aszlig wizeman ];
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
