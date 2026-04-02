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
      url = "https://download.jetbrains.com/rustrover/RustRover-2025.3.5.tar.gz";
      hash = "sha256-2yEZOWUoD6ELs0WSvdMSZSVAmA/LsoKyfJiR20I86aQ=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/rustrover/RustRover-2025.3.5-aarch64.tar.gz";
      hash = "sha256-tl8lxMH6XH+2VGqv6vxGEjjALevaEl7VAzs9LAjwtPQ=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/rustrover/RustRover-2025.3.5.dmg";
      hash = "sha256-8ONWTld29DJjaDH4ubsBRmYYosQ6wTAQInuko76Ucoc=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/rustrover/RustRover-2025.3.5-aarch64.dmg";
      hash = "sha256-N3D6YE6vV8x+slvphyqzDu2mTp8y2uAeSZTZg0pMABQ=";
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
  version = "2025.3.5";
  buildNumber = "253.31033.204";
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
