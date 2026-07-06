{
  stdenv,
  lib,
  fetchurl,
  mkJetBrainsProduct,
  libdbm,
  fsnotifier,
  libgcc,
  runCommand,
  R,
}:
let
  system = stdenv.hostPlatform.system;
  # update-script-start: urls
  urls = {
    x86_64-linux = {
      url = "https://download.jetbrains.com/python/dataspell-2026.1.tar.gz";
      hash = "sha256-FcbflBzHsSWvkXVtrlltvb3PjihP91s0gm3wmV3zuRA=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/python/dataspell-2026.1-aarch64.tar.gz";
      hash = "sha256-JKAW0YtwNDjk3Un4e/cWipreAI8pJaJgLNvx7oOw4RQ=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/python/dataspell-2026.1.dmg";
      hash = "sha256-w/nFLddHi/l7VqQKngxhYm/LL49eiawXhK+xGBU6Ej0=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/python/dataspell-2026.1-aarch64.dmg";
      hash = "sha256-/yZpE2aY07AedubVG6yarO4uObdaIZ4KCtKl9DaRU4c=";
    };
  };
  # update-script-end: urls
in
mkJetBrainsProduct {
  inherit libdbm fsnotifier;

  pname = "dataspell";

  wmClass = "jetbrains-dataspell";
  product = "DataSpell";

  # update-script-start: version
  version = "2026.1";
  buildNumber = "261.22158.332";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  # NOTE: This `lib.optionals` is only here because the old Darwin builder ignored `buildInputs`.
  #       DataSpell may need these, even on Darwin!
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libgcc
    (runCommand "libR" { } ''
      mkdir -p $out/lib
      ln -s ${R}/lib/R/lib/libR.so $out/lib/libR.so
    '')
  ];

  # NOTE: meta attrs are used for the Linux desktop entries and may cause rebuilds when changed
  meta = {
    homepage = "https://www.jetbrains.com/dataspell/";
    description = "Data science IDE from JetBrains";
    longDescription = ''
      DataSpell is an IDE from JetBrains built for Data Scientists.
      Mainly it integrates Jupyter notebooks in the IntelliJ platform.
    '';
    maintainers = with lib.maintainers; [ leona ];
    license = lib.licenses.unfree;
    sourceProvenance =
      if stdenv.hostPlatform.isDarwin then
        [ lib.sourceTypes.binaryNativeCode ]
      else
        [ lib.sourceTypes.binaryBytecode ];
  };
}
