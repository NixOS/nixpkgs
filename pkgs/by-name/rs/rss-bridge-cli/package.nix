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
    version = rss-bridge.version;

<<<<<<< HEAD
    meta = {
      description = "Command-line interface for RSS-Bridge";
      homepage = "https://github.com/RSS-Bridge/rss-bridge";
      license = lib.licenses.unlicense;
      maintainers = with lib.maintainers; [ ymeister ];
=======
    meta = with lib; {
      description = "Command-line interface for RSS-Bridge";
      homepage = "https://github.com/RSS-Bridge/rss-bridge";
      license = licenses.unlicense;
      maintainers = with maintainers; [ ymeister ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      mainProgram = "rss-bridge-cli";
    };
  })
