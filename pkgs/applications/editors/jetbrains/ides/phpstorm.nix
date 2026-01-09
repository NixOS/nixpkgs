{
  stdenv,
  lib,
  fetchurl,
  mkJetBrainsProduct,
  libdbm,
  fsnotifier,
  musl,
}:
let
  system = stdenv.hostPlatform.system;
  # update-script-start: urls
  urls = {
    x86_64-linux = {
      url = "https://download.jetbrains.com/webide/PhpStorm-2025.3.1.tar.gz";
      hash = "sha256-/Yk3q2t5YFzvyZF//moI4FprfMAlb6IXhiPSTsMi+ik=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/webide/PhpStorm-2025.3.1-aarch64.tar.gz";
      hash = "sha256-dkhmf4W0xFkosE1MJvIogqiqZaeHpk+i96/+UaG8KmE=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/webide/PhpStorm-2025.3.1.dmg";
      hash = "sha256-EZiLzuXZSycepnrqzT6DYClZWmz+v+wmWVZfwYpK0tE=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/webide/PhpStorm-2025.3.1-aarch64.dmg";
      hash = "sha256-BFPgpu6Gw8v5e4xI8oJnUdgIW/ghG1QaBHUmIcWvFrw=";
    };
  };
  # update-script-end: urls
in
mkJetBrainsProduct {
  inherit libdbm fsnotifier;

  pname = "phpstorm";

  wmClass = "jetbrains-phpstorm";
  product = "PhpStorm";

  # update-script-start: version
  version = "2025.3.1";
  buildNumber = "253.29346.151";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  buildInputs = [
    musl
  ];

  # NOTE: meta attrs are currently used by the desktop entry, so changing them may cause rebuilds (see TODO in README)
  meta = {
    homepage = "https://www.jetbrains.com/phpstorm/";
    description = "PHP IDE from JetBrains";
    longDescription = "PhpStorm provides an editor for PHP, HTML and JavaScript with on-the-fly code analysis, error prevention and automated refactorings for PHP and JavaScript code. ";
    maintainers = with lib.maintainers; [
      dritter
      tymscar
    ];
    license = lib.licenses.unfree;
    sourceProvenance =
      if stdenv.hostPlatform.isDarwin then
        [ lib.sourceTypes.binaryNativeCode ]
      else
        [ lib.sourceTypes.binaryBytecode ];
  };
}
