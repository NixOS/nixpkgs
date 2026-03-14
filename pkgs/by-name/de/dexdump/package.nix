{
  stdenv,
  fetchurl,
  unzip,
  patchelf,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dexdump";
  version = "36.1";

  src = fetchurl {
    url = "https://dl.google.com/android/repository/build-tools_r${finalAttrs.version}_linux.zip";
    hash = "sha256-p7WInkp5/POwl2vvQNQB9CQPse7YkdnZEWnaERHhHXg=";
  };

  nativeBuildInputs = [
    unzip
    patchelf
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp dexdump $out/bin/

    # Patch ELF interpreter and RPATH so the binary runs on NixOS
    patchelf \
      --set-interpreter ${stdenv.cc.bintools.dynamicLinker} \
      --set-rpath ${stdenv.cc.cc.lib}/lib \
      $out/bin/dexdump
  '';

  meta = {
    description = "Dexdump from Android SDK build-tools";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
})
