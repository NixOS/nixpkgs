{
  # keep-sorted start
  expat,
  fetchurl,
  fsnotifier,
  jetbrains,
  jetbrains-libdbm,
  lib,
  libxcrypt-legacy,
  libxml2,
  openssl,
  python3,
  stdenv,
  xz,
  # keep-sorted end
}:
let
  system = stdenv.hostPlatform.system;
  # update-script-start: urls
  urls = {
    x86_64-linux = {
      url = "https://download.jetbrains.com/rustrover/RustRover-2026.2.2.tar.gz";
      hash = "sha256-0te7wU8fy4+nAWRtASP3HFIVl9LzcHLSByV3uAP9BBo=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/rustrover/RustRover-2026.2.2-aarch64.tar.gz";
      hash = "sha256-jtfIKtA6ivQURYvxu0IReVLG5gtHgavSAcbOP7qNlXQ=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/rustrover/RustRover-2026.2.2-aarch64.dmg";
      hash = "sha256-YcYmrbaKhdi0NgcjxN8ZYIggFUJrZiKpF43aohtJhbo=";
    };
  };
  # update-script-end: urls
in
jetbrains.mkJetBrainsProduct {
  inherit jetbrains-libdbm fsnotifier;

  pname = "rust-rover";

  wmClass = "jetbrains-rustrover";
  product = "RustRover";

  # update-script-start: version
  version = "2026.2.2";
  buildNumber = "262.10315.167";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  # the jdk is bundled on Darwin.
  jdk =
    if lib.meta.availableOn stdenv.hostPlatform jetbrains.jdk-no-jcef then
      jetbrains.jdk-no-jcef
    else
      null;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ jetbrains.sharedLibsHook ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [
      # keep-sorted start
      libxcrypt-legacy
      openssl
      python3
      # keep-sorted end
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch) [
      # keep-sorted start
      expat
      libxml2
      xz
      # keep-sorted end
    ];

  # NOTE: meta attrs are used for the Linux desktop entries and may cause rebuilds when changed
  meta = {
    homepage = "https://www.jetbrains.com/rust/";
    description = "Rust IDE from JetBrains";
    longDescription = "Rust IDE from JetBrains";
    maintainers = [ ];
    teams = [ lib.teams.jetbrains ];
    license = lib.licenses.unfree;
    sourceProvenance =
      if stdenv.hostPlatform.isDarwin then
        [ lib.sourceTypes.binaryNativeCode ]
      else
        [ lib.sourceTypes.binaryBytecode ];
  };
}
