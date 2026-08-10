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
      url = "https://download.jetbrains.com/rustrover/RustRover-2026.2.1.tar.gz";
      hash = "sha256-/XuqMqaynPhnu4r8BewAHh/KdAgngZJUFhG9XT9IL1s=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/rustrover/RustRover-2026.2.1-aarch64.tar.gz";
      hash = "sha256-M90sp/Coyb49V87gX9AVP7C087HkxrTo5ZN4I3RrpNw=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/rustrover/RustRover-2026.2.1-aarch64.dmg";
      hash = "sha256-vz7DY+BgjLYIBE5KUCJ7AuZtMTppEuHmcTJOOT+ElRM=";
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
  version = "2026.2.1";
  buildNumber = "262.9437.161";
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
