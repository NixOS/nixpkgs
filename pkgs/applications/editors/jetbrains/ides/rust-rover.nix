{
  stdenv,
  lib,
  fetchurl,
  mkJetBrainsProduct,
  libdbm,
  fsnotifier,
  patchSharedLibs,
  python3,
  openssl,
  libxcrypt-legacy,
  expat,
  libxml2,
  xz,
}:
let
  system = stdenv.hostPlatform.system;
  # update-script-start: urls
  urls = {
    x86_64-linux = {
      url = "https://download.jetbrains.com/rustrover/RustRover-2025.3.2.tar.gz";
      hash = "sha256-c6Pou6a27cwCcvcpKnhQOt2Emf+iSHyOIQIyXTEB3hE=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/rustrover/RustRover-2025.3.2-aarch64.tar.gz";
      hash = "sha256-YUBymEX/fv71/cFrBUi0jvgTHn0eFh02tFT/HIE3+5k=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/rustrover/RustRover-2025.3.2.dmg";
      hash = "sha256-UlcMaFh7o/X8RkfjUr1fsDrHvN/rFhH7X1rvwaMTSzY=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/rustrover/RustRover-2025.3.2-aarch64.dmg";
      hash = "sha256-fOX2HBJA8CbLVMLGxMMCmw0CFbKtEiW+WgkiIgwIqLE=";
    };
  };
  # update-script-end: urls
in
(mkJetBrainsProduct {
  inherit libdbm fsnotifier;

  pname = "rust-rover";

  wmClass = "jetbrains-rustrover";
  product = "RustRover";

  # update-script-start: version
  version = "2025.3.2";
  buildNumber = "253.29346.361";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      python3
      openssl
      libxcrypt-legacy
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch) [
      expat
      libxml2
      xz
    ];

  # NOTE: meta attrs are used for the Linux desktop entries and may cause rebuilds when changed
  meta = {
    homepage = "https://www.jetbrains.com/rust/";
    description = "Rust IDE from JetBrains";
    longDescription = "Rust IDE from JetBrains";
    maintainers = [ ];
    license = lib.licenses.unfree;
    sourceProvenance =
      if stdenv.hostPlatform.isDarwin then
        [ lib.sourceTypes.binaryNativeCode ]
      else
        [ lib.sourceTypes.binaryBytecode ];
  };
}).overrideAttrs
  (attrs: {
    postFixup = ''
      ${attrs.postFixup or ""}
      ${patchSharedLibs}
    '';
  })
