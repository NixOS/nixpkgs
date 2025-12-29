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
  urls = {
    x86_64-linux = {
      url = "https://download.jetbrains.com/rustrover/RustRover-2025.3.1.tar.gz";
      sha256 = "5a1b34e10a1c59eee30694236baa8233c7787580769381be01b4ccb09618ec89";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/rustrover/RustRover-2025.3.1-aarch64.tar.gz";
      sha256 = "fb0f81c9d2a2a604718484954b261a642be9ed6f51de98fcdc6cedb32b0a4c9e";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/rustrover/RustRover-2025.3.1.dmg";
      sha256 = "3899875452a5182db93b132c00dbc84394ffb637430b97f2390be8abb0412537";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/rustrover/RustRover-2025.3.1-aarch64.dmg";
      sha256 = "103a12ed1c37b6b38cff5d637e7dc7b8dcc78f5c576ba38b8f862c6ba3647d52";
    };
  };
in
(mkJetBrainsProduct {
  inherit libdbm fsnotifier;

  pname = "rust-rover";

  wmClass = "jetbrains-rustrover";
  product = "RustRover";

  version = "2025.3.1";
  buildNumber = "253.29346.139";

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

  meta = {
    homepage = "https://www.jetbrains.com/rust/";
    description = "Rust IDE from JetBrains";
    longDescription = "Rust IDE from JetBrains";
    maintainers = with lib.maintainers; [ genericnerdyusername ];
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
