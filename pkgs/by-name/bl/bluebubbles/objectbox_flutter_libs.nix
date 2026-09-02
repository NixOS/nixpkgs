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
    name = "objectbox-linux-4.3.0";
    url = "https://github.com/objectbox/objectbox-c/releases/download/v4.3.0/objectbox-linux-${arch}.tar.gz";
    hash = selectSystem {
      x86_64-linux = "sha256-VaDUQcTk0ArmeKFpdKN35WEGL8QX89k8KPHTRP9xadI=";
      aarch64-linux = "sha256-vnsxkNiYoZIBfw6IcYg4cFgsdRyHGDbyA0y8J4NuYE0=";
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

  meta.sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
}
