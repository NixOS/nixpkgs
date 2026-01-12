# TODO: This IDE is deprecated and scheduled for removal in 26.05
{
  stdenv,
  lib,
  fetchurl,
  mkJetBrainsProduct,
  libdbm,
  fsnotifier,
  lldb,
}:
let
  system = stdenv.hostPlatform.system;
  # update-script-start: urls
  urls = {
    x86_64-linux = {
      url = "https://download.jetbrains.com/aqua/aqua-2024.3.2.tar.gz";
      sha256 = "de073e8a3734a2c4ef984b3e1bd68f5de72a6180e73400889510439ac3f419aa";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/aqua/aqua-2024.3.2-aarch64.tar.gz";
      sha256 = "d2a3c781756a83ccea63dc6d9aebf85f819de1edb5bcd4e5a1a161eaa0779c84";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/aqua/aqua-2024.3.2.dmg";
      sha256 = "423d492e9849beb7edbbd1771650a04e8df9f469bf1789b41bc5878c84cee393";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/aqua/aqua-2024.3.2-aarch64.dmg";
      sha256 = "43974cdbbb71aaf5bfcfaf2cfd0e69e9920dda3973e64671936c1d52b267494d";
    };
  };
  # update-script-end: urls
in
mkJetBrainsProduct {
  inherit libdbm fsnotifier;

  pname = "aqua";

  wmClass = "jetbrains-aqua";
  product = "Aqua";

  # update-script-start: version
  version = "2024.3.2";
  buildNumber = "243.23654.154";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  buildInputs = [
    lldb
  ];

  # NOTE: meta attrs are currently used by the desktop entry, so changing them may cause rebuilds (see TODO in README)
  meta = {
    homepage = "https://www.jetbrains.com/aqua/";
    description = "Test automation IDE from JetBrains";
    longDescription = "Aqua is a test automation IDE from jetbrains that can deal with many languages and frameworks to improve your test workflows. Has support for popular testing frameworks like Selenium, Cypress, and Playwright.";
    maintainers = with lib.maintainers; [ remcoschrijver ];
    license = lib.licenses.unfree;
    sourceProvenance =
      if stdenv.hostPlatform.isDarwin then
        [ lib.sourceTypes.binaryNativeCode ]
      else
        [ lib.sourceTypes.binaryBytecode ];
  };
}
