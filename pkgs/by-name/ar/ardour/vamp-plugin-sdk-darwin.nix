{
  lib,
  stdenv,
  fetchurl,
  fixDarwinDylibNames,
  libsndfile,
  pkg-config,
}:
stdenv.mkDerivation rec {
  pname = "vamp-plugin-sdk";
  version = "2.9.0";

  src = fetchurl {
    url = "https://ardour.org/files/deps/vamp-plugin-sdk-${version}.tar.gz";
    hash = "sha256-typ474/4qSfcLtfmbs9MYtIyaKXXTQLaJb4rjQA0EJk=";
  };

  nativeBuildInputs = [
    fixDarwinDylibNames
    pkg-config
  ];

  buildInputs = [ libsndfile ];

  # https://github.com/vamp-plugins/vamp-plugin-sdk/issues/12
  enableParallelBuilding = false;

  makeFlags = [
    "AR:=$(AR)"
    "RANLIB:=$(RANLIB)"
    "LINK_SDK_DYNAMIC=-dynamiclib"
    "PLUGIN_EXT=.dylib"
    "VAMP_HOSTSDK_DYNAMIC_EXTENSION=.dylib"
    "VAMP_SDK_DYNAMIC_EXTENSION=.dylib"
  ] ++ lib.optional (stdenv.buildPlatform != stdenv.hostPlatform) "-o test";

  postInstall = ''
    for dylib in "$out"/lib/*.so; do
      if [ -f "$dylib" ]; then
        mv "$dylib" "''${dylib%.so}.dylib"
      fi
    done

    install_name_tool -id "$out/lib/libvamp-sdk.dylib" "$out/lib/libvamp-sdk.dylib"
    install_name_tool -id "$out/lib/libvamp-hostsdk.dylib" "$out/lib/libvamp-hostsdk.dylib"
  '';

  meta = {
    description = "Audio processing plugin system for descriptive audio analysis plugins";
    homepage = "https://vamp-plugins.org/";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.marcweber ];
    platforms = [ "aarch64-darwin" ];
  };
}
