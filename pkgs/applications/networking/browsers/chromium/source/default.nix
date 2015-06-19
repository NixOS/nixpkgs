{ stdenv, fetchurl, fetchpatch, patchutils, python
, channel ? "stable"
, useOpenSSL # XXX
}:

with stdenv.lib;

with (import ./update.nix {
  inherit (stdenv) system;
}).getChannel channel;

let
  transform = flags: concatStringsSep ";" (map (subst: subst + flags) [
    "s,^[^/]+(.*)$,$main\\1,"
    "s,$main/(build|tools)(/.*)?$,$out/\\1\\2,"
    "s,$main/third_party(/.*)?$,$bundled\\1,"
    "s,$main/sandbox(/.*)?$,$sandbox\\1,"
    "s,^/,,"
  ]);

  pre44 = versionOlder version "44.0.0.0";
  is44 = versionOlder version "45.0.0.0" && !pre44;

in stdenv.mkDerivation {
  name = "chromium-source-${version}";

  src = fetchurl main;

  buildInputs = [ python ]; # cannot patch shebangs otherwise

  phases = [ "unpackPhase" "patchPhase" ];
  outputs = [ "out" "sandbox" "bundled" "main" ];

  unpackPhase = ''
    tar xf "$src" -C / \
      --transform="${transform "xS"}" \
      --anchored \
      --no-wildcards-match-slash \
      --exclude='*/tools/gyp' \
      --exclude='*/.*'
  '';

  opensslPatches = optional useOpenSSL openssl.patches;

  prePatch = ''
    for i in $outputs; do
      eval patchShebangs "\$$i"
    done
  '';

  patches = let
    baseURL = "https://codereview.chromium.org/download";

    mkBlinkFix = issue: sha256: fetchpatch {
      url = "${baseURL}/issue${issue}.diff";
      inherit sha256;
      postFetch = ''
        sed -i -e 's,^\(---\|+++\) *[ab]/,&third_party/WebKit/,' "$out"
      '';
    };

    fixes44 = [
      # WebPluginContainer::setNeedsLayout
      # https://codereview.chromium.org/1157943002/
      (mkBlinkFix "1157943002_20001"
                  "0932yd15zlh2g5a5bbm6qrnfvv22jlfdg8pj0w9z58m5zdzw1p82")
      # WebRuntimeFeatures::enablePermissionsAPI
      # https://codereview.chromium.org/1156113007/
      (mkBlinkFix "1156113007_1"
                  "1v76brrgdziv1q62ba4bimg0my2dmnkyl68b21nv2vw661v0hzwh")
      # Revert of https://codereview.chromium.org/1150543002/
      (fetchpatch {
        url = "${baseURL}/issue1150543002_1.diff";
        sha256 = "0x9sya0m1zcb2vcp2vfss88qqdrh6bzcbx2ngfiql7rkbynnpqn6";
        postFetch = ''
          ${patchutils}/bin/interdiff "$out" /dev/null > reversed.patch
          mv reversed.patch "$out"
        '';
      })
    ];
    pluginPaths = if pre44 then singleton ./nix_plugin_paths_42.patch
                  else singleton ./nix_plugin_paths_44.patch;
  in pluginPaths ++ optionals is44 fixes44;

  patchPhase = let
    diffmod = sym: "/^${sym} /{s/^${sym} //;${transform ""};s/^/${sym} /}";
    allmods = "${diffmod "---"};${diffmod "\\+\\+\\+"}";
    sedexpr = "/^(---|\\+\\+\\+) *\\/dev\\/null/b;${allmods}";
  in ''
    runHook prePatch
    for i in $patches; do
      header "applying patch $i" 3
      sed -r -e "${sedexpr}" "$i" | patch -d / -p0
      stopNest
    done
    runHook postPatch
  '';

  postPatch = ''
    sed -i -r \
      -e 's/-f(stack-protector)(-all)?/-fno-\1/' \
      -e 's|/bin/echo|echo|' \
      -e "/python_arch/s/: *'[^']*'/: '""'/" \
      "$out/build/common.gypi" "$main/chrome/chrome_tests.gypi"
    sed -i -e '/LOG.*no_suid_error/d' \
      "$main/content/browser/browser_main_loop.cc"
  '' + optionalString useOpenSSL ''
    cat $opensslPatches | patch -p1 -d "$bundled/openssl/openssl"
  '';

  preferLocalBuild = true;

  passthru = {
    inherit version channel;
    plugins = fetchurl binary;
  };
}
