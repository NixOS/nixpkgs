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
    "s,^/,,"
  ]);

in stdenv.mkDerivation {
  name = "chromium-source-${version}";

  src = fetchurl main;

  buildInputs = [ python ]; # cannot patch shebangs otherwise

  phases = [ "unpackPhase" "patchPhase" ];
  outputs = [ "out" "bundled" "main" ];

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

  patches =
    if versionOlder version "45.0.0.0"
    then singleton ./nix_plugin_paths_44.patch
    else singleton ./nix_plugin_paths_46.patch ++
         optional (!versionOlder version "46.0.0.0") ./build_fixes_46.patch;

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
  '' + optionalString useOpenSSL ''
    cat $opensslPatches | patch -p1 -d "$bundled/openssl/openssl"
  '';

  preferLocalBuild = true;

  passthru = {
    inherit version channel;
    plugins = fetchurl binary;
  };
}
