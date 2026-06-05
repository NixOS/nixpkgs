{
  lib,
  writeShellScriptBin,
  rss-bridge,
  php,
}:

let
  phpWithExts = (
    php.withExtensions (
      { all, ... }:
      with all;
      [
        curl
        filter
        iconv
        mbstring
        openssl
        simplexml
        sqlite3
      ]
    )
  );
  phpBin = "${phpWithExts}/bin/php";
in
(writeShellScriptBin "rss-bridge-cli" ''
  ${phpBin} ${rss-bridge}/index.php "$@"
'').overrideAttrs
  (oldAttrs: {
    pname = "rss-bridge-cli";

    version = rss-bridge.version;

    meta = {
      description = "Command-line interface for RSS-Bridge";
      homepage = "https://github.com/RSS-Bridge/rss-bridge";
      license = lib.licenses.unlicense;
      maintainers = with lib.maintainers; [ ymeister ];
      mainProgram = "rss-bridge-cli";
    };
  })
