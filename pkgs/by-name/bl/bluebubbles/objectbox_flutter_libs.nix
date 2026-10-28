{
  lib,
  stdenv,
  fetchzip,
  replaceVars,
}:

{ version, src, ... }:

let
  selectSystem =
    attrs:
    attrs.${stdenv.hostPlatform.system}
      or (throw "objectbox_flutter_libs: ${stdenv.hostPlatform.system} is not supported");

  arch = selectSystem {
    x86_64-linux = "x64";
    aarch64-linux = "aarch64";
  };

  objectbox-c = fetchzip {
    name = "objectbox-linux-5.3.1";
    url = "https://github.com/objectbox/objectbox-c/releases/download/v5.3.1/objectbox-linux-${arch}.tar.gz";
    hash = selectSystem {
      x86_64-linux = "sha256-Avd5y6Y6NCCQokzxwfBpkipt+JxF/M46MCLcDpqv8Kk=";
      aarch64-linux = "sha256-S6/QbqRhIm3f51e3AcEfuq56cde3aQb0ITN6qPuWCps=";
    };
    stripRoot = false;
    meta.license = lib.licenses.unfree; # the release tarball has a proprietary shared library
  };
in
stdenv.mkDerivation {
  pname = "objectbox_flutter_libs";
  inherit version src;
  inherit (src) passthru;

  patches = [
    (replaceVars ./CMakeLists.patch {
      OBJECTBOX_SHARED_LIBRARY = "${objectbox-c}/lib/libobjectbox.so";
    })
  ];

  installPhase = ''
    runHook preInstall

    cp -r . $out

    runHook postInstall
  '';

  meta.sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
}
