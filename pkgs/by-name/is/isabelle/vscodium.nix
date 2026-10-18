{
  buildVscode,
  fetchurl,
  stdenv,
  lib,
  isabelle,
}:

buildVscode rec {
  version = "1.105.17075";
  vscodeVersion = "1.105.1";
  pname = "vscodium";

  executableName = "electron";
  longName = "VSCodium";
  shortName = "vscodium";

  src = fetchurl {
    url = "https://isabelle.in.tum.de/components/vscodium-${version}.tar.gz";
    hash = "sha256-sKMUOZP8C0kHcKtH5J4+JaBDAM1kL7DXn+sak6kE8fk=";
  };
  sourceRoot =
    "vscodium-${version}/${isabelle.platform}"
    + lib.optionalString stdenv.hostPlatform.isDarwin "/VSCodium.app";

  tests = { };
  commandLineArgs = "";
  useVSCodeRipgrep = stdenv.hostPlatform.isDarwin;
  patchVSCodePath = false;
  updateScript = null;
  hasVsceSign = false;
  # isabelle vscodium doesn't properly wrap it's electron, so can't be called directly
  # instead it is executed through `isabelle vscode`, which calls electron with the proper arguments
  installExecutable = false;
  appDir = "vscodium";

  dontFixup = stdenv.hostPlatform.isDarwin;

  meta = {
    description = "Patched version of vscodium with support for Isabelle specific charsets";
    homepage = "https://isabelle.in.tum.de/";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = [ lib.maintainers.sempiternal-aurora ];
    inherit (isabelle.meta) platforms;
    # requires libc.so.6 and other glibc specifics
    broken = stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isGnu;
  };
}
