{ stdenv, fetchurl, python
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

  pre42 = versionOlder version "42.0.0.0";

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

  patches = if pre42 then [
    ./sandbox_userns_36.patch ./nix_plugin_paths.patch
  ] else [
    ./nix_plugin_paths_42.patch
  ];

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
  '' + optionalString (!pre42) ''
    sed -i -e '/LOG.*no_suid_error/d' \
      "$main/content/browser/browser_main_loop.cc"
  '';

  preferLocalBuild = true;

  passthru = {
    inherit version channel;
    plugins = fetchurl binary;
  };
}
