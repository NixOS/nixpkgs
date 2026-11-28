{
  lib,
  stdenv,
  fetchzip,
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
    name = "objectbox-linux-${version}";
    url = "https://github.com/objectbox/objectbox-c/releases/download/v${version}/objectbox-linux-${arch}.tar.gz";
    hash = selectSystem {
      x86_64-linux = "sha256-K0pp24TB9epi4HYsIZ4dph+xIJ9KrmTJSuVzSyTdROg=";
      aarch64-linux = "sha256-eID2d6bqV22p+s/lbugv+LGQAuWHYuHbeWgxTE+8mwI=";
    };
    stripRoot = false;
    meta.license = lib.licenses.unfree; # the release tarball has a proprietary shared library
  };
in
stdenv.mkDerivation {
  pname = "objectbox_flutter_libs";
  inherit version src;
  inherit (src) passthru;

  # Use the prefetched objectbox-c instead of downloading it with FetchContent
  postPatch = ''
    substituteInPlace linux/CMakeLists.txt \
      --replace-fail "include(FetchContent)" "" \
      --replace-fail "FetchContent_Declare(" "set(_unused_objectbox_download " \
      --replace-fail "FetchContent_GetProperties(objectbox-download)" "" \
      --replace-fail "FetchContent_Populate(objectbox-download)" "" \
      --replace-fail "\''${objectbox-download_SOURCE_DIR}" "${objectbox-c}"
  '';

  installPhase = ''
    runHook preInstall

    cp -r . $out

    runHook postInstall
  '';

  meta.sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
}
