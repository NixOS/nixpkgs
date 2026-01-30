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
      url = "https://download.jetbrains.com/webide/PhpStorm-2025.3.2.tar.gz";
      hash = "sha256-W9O2DYzJAEtgFb79xYGMUNvi8yMmH+oRhNeoKyHtYO8=";
    };
    aarch64-linux = {
      url = "https://download.jetbrains.com/webide/PhpStorm-2025.3.2-aarch64.tar.gz";
      hash = "sha256-YiDHheT9ZbmE75WLd0+/VLa1d+WHzXCcGDkWM0LOj/g=";
    };
    x86_64-darwin = {
      url = "https://download.jetbrains.com/webide/PhpStorm-2025.3.2.dmg";
      hash = "sha256-sNfPhCnJXS3IYPuDMLjptvm05zzHFdsJkLBbht7oiXg=";
    };
    aarch64-darwin = {
      url = "https://download.jetbrains.com/webide/PhpStorm-2025.3.2-aarch64.dmg";
      hash = "sha256-1zNcdCtb6BwtFMaDoZLVwXaS1xD8HXbBa2Jd5wSMsI4=";
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
  version = "2025.3.2";
  buildNumber = "253.30387.85";
  # update-script-end: version

  src = fetchurl (urls.${system} or (throw "Unsupported system: ${system}"));

  buildInputs = [
    musl
  ];

  # NOTE: meta attrs are used for the Linux desktop entries and may cause rebuilds when changed
  meta = {
    homepage = "https://www.jetbrains.com/phpstorm/";
    description = "PHP IDE from JetBrains";
    longDescription = "PhpStorm provides an editor for PHP, HTML and JavaScript with on-the-fly code analysis, error prevention and automated refactorings for PHP and JavaScript code.";
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
