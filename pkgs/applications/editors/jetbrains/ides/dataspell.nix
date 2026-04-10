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
      url = "https://download.jetbrains.com/python/dataspell-2025.3.2.tar.gz";
      hash = "sha256-rRcGQOEVc7nnqyFDVvkjgZlvoKZfnuSCR5TnqrMFDjo=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/python/dataspell-2025.3.2-aarch64.tar.gz";
      hash = "sha256-WQqGvwaBkdJU9AN+LIThnZlW/HDzEpZuS0q+ir/ncfw=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/python/dataspell-2025.3.2.dmg";
      hash = "sha256-k3GEiAnqst8EB8AFwcVMGaZYJ/jR+MGhQ59ysTP/9uI=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/python/dataspell-2025.3.2-aarch64.dmg";
      hash = "sha256-R8iT4fDtpOzI6Xcw1mR0rE0Gqhk6r8wl8HoDoaTGzfs=";
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
  version = "2025.3.2";
  buildNumber = "253.30387.154";
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
