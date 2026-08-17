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
      url = "https://download.jetbrains.com/rustrover/RustRover-2026.1.4.tar.gz";
      hash = "sha256-8x/AP6uKSVJavwjA9tYT1IM1xVspOZZzwmcwpGloIcw=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/rustrover/RustRover-2026.1.4-aarch64.tar.gz";
      hash = "sha256-KpF3jCnLKCEeEXkBdB8ZsPPqP9FOVRTwRV/FQLKyh1Q=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/rustrover/RustRover-2026.1.4.dmg";
      hash = "sha256-2BwgAD0xF9IxRJh+gW4vLzBW13rFQSzQPbEwdmQGvLU=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/rustrover/RustRover-2026.1.4-aarch64.dmg";
      hash = "sha256-Hly4NBv9mg/RMmxCM6m9w5eS/CQ7ycxp7V2VQZwyGQE=";
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
  version = "2026.1.4";
  buildNumber = "261.26222.73";
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
