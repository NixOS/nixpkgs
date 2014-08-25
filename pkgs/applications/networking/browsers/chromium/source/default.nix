{ stdenv, fetchurl, python
, channel ? "stable"
, useOpenSSL # XXX
}:

with stdenv.lib;

with (import ./update.nix {
  inherit (stdenv) system;
}).getChannel channel;

stdenv.mkDerivation {
  name = "chromium-source-${version}";

  src = fetchurl main;

  buildInputs = [ python ]; # cannot patch shebangs otherwise

  phases = [ "unpackPhase" "patchPhase" "installPhase" ];

  opensslPatches = optional useOpenSSL openssl.patches;

  prePatch = "patchShebangs .";

  patches = singleton ./sandbox_userns_36.patch;

  postPatch = ''
    sed -i -r \
      -e 's/-f(stack-protector)(-all)?/-fno-\1/' \
      -e 's|/bin/echo|echo|' \
      -e "/python_arch/s/: *'[^']*'/: '""'/" \
      build/common.gypi chrome/chrome_tests.gypi
  '' + optionalString (versionOlder version "38.0.0.0") ''
    sed -i -e '/not RunGN/,+1d' -e '/import.*depot/d' build/gyp_chromium
    sed -i -e 's|/usr/bin/gcc|gcc|' \
      third_party/WebKit/Source/build/scripts/scripts.gypi \
      third_party/WebKit/Source/build/scripts/preprocessor.pm
  '' + optionalString useOpenSSL ''
    cat $opensslPatches | patch -p1 -d third_party/openssl/openssl
  '';

  outputs = [ "out" "sandbox" "bundled" "main" ];
  installPhase = ''
    mkdir -p "$out" "$sandbox" "$bundled" "$main"

    header "copying browser main sources to $main"
    find . -mindepth 1 -maxdepth 1 \
      \! -path ./sandbox \
      \! -path ./third_party \
      \! -path ./build \
      \! -path ./tools \
      \! -name '.*' \
      -print | xargs cp -rt "$main"
    stopNest

    header "copying sandbox components to $sandbox"
    cp -rt "$sandbox" sandbox/*
    stopNest

    header "copying third party sources to $bundled"
    cp -rt "$bundled" third_party/*
    stopNest

    header "copying build requisites to $out"
    cp -rt "$out" build tools
    stopNest

    rm -rf "$out/tools/gyp" # XXX: Don't even copy it in the first place.
  '';

  preferLocalBuild = true;

  passthru = {
    inherit version channel;
    plugins = fetchurl binary;
  };
}
