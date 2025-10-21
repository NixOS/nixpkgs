{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  writeScript,
  testers,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libxshmfence";
  version = "1.3.3";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libxshmfence-${finalAttrs.version}.tar.xz";
    hash = "sha256-1KTfCWq6lv6gLAKe46ROEaR+t/chPBpym+g+hew/3hA=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ xorgproto ];

  passthru = {
    updateScript = writeScript "update-${finalAttrs.pname}" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p common-updater-scripts
      version="$(list-directory-versions --pname ${finalAttrs.pname} \
        --url https://xorg.freedesktop.org/releases/individual/lib/ \
        | sort -V | tail -n1)"
      update-source-version ${finalAttrs.pname} "$version"
    '';
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = {
    description = "Shared memory 'SyncFence' synchronization primitive library";
    longDescription = ''
      This library offers a CPU-based synchronization primitive compatible with the X SyncFence
      objects that can be shared between processes using file descriptor passing.
      There are two underlying implementations:
      - On Linux, the library uses futexes
      - On other systems, the library uses posix mutexes and condition variables.
    '';
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxshmfence";
    license = lib.licenses.hpndSellVariant;
    maintainers = [ ];
    pkgConfigModules = [ "xshmfence" ];
    platforms = lib.platforms.unix;
  };
})
