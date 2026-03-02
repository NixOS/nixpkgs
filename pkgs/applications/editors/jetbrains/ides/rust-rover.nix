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
      url = "https://download.jetbrains.com/rustrover/RustRover-2025.3.3.tar.gz";
      hash = "sha256-uAPFVBR5KSyJGGZEIDsqCZFBXcmKyDfgQgiaIUvyB2w=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/rustrover/RustRover-2025.3.3-aarch64.tar.gz";
      hash = "sha256-MfItRr0LLQza6uKeGphAd2YN5+DacdQnOpVuvrnJtnw=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/rustrover/RustRover-2025.3.3.dmg";
      hash = "sha256-5Di4lXgbAwq8I1+6XKxB6JsmwEpc8qXNjUiPK+N6reM=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/rustrover/RustRover-2025.3.3-aarch64.dmg";
      hash = "sha256-ftJq0KNkwj/YPw1abPB3wRcDWMryZAEvqbNdY1RaT9g=";
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
  version = "2025.3.3";
  buildNumber = "253.30387.122";
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
