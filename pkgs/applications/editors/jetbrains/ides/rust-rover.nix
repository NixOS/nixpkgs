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
      url = "https://download.jetbrains.com/rustrover/RustRover-2026.1.tar.gz";
      hash = "sha256-qiOgAHz/tCnyEwljTy1D0sJBhWpOXZCCf5Uq66PZjzk=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/rustrover/RustRover-2026.1-aarch64.tar.gz";
      hash = "sha256-jU61XQ+3zliH3y6nz6o8U/DrRkZ2vs4ff8Fd/RPb0a0=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/rustrover/RustRover-2026.1.dmg";
      hash = "sha256-VwVvTSUdFpPhAeWyzkID6TFNE0S1vVeR82FRfU2v3s4=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/rustrover/RustRover-2026.1-aarch64.dmg";
      hash = "sha256-DeLkwKq01M3zmr2yZnOYXCn0CZ+0P9MtWC9bMIzKrVE=";
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
  version = "2026.1";
  buildNumber = "261.22158.331";
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
