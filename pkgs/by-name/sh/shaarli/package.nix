{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "shaarli";
  version = "0.16.0";

  src = fetchurl {
    url = "https://github.com/shaarli/Shaarli/releases/download/v${finalAttrs.version}/shaarli-v${finalAttrs.version}-full.tar.gz";
    sha256 = "sha256-e/iZ+SPMt6HphEbLY2hM7pnvXHxsCOYZoXyGpA5FMtg=";
  };

  outputs = [
    "out"
    "doc"
  ];

  patchPhase = ''
    substituteInPlace index.php \
      --replace "new ConfigManager();" "new ConfigManager(getenv('SHAARLI_CONFIG'));"
  '';

  #    Point $SHAARLI_CONFIG to your configuration file, see https://github.com/shaarli/Shaarli/wiki/Shaarli-configuration.
  #    For example:
  #      <?php /*
  #      {
  #          "credentials": {
  #              "login": "user",
  #              "hash": "(password hash)",
  #              "salt": "(password salt)"
  #          },
  #          "resource": {
  #              "data_dir": "\/var\/lib\/shaarli",
  #              "config": "\/var\/lib\/shaarli\/config.json.php",
  #              "datastore": "\/var\/lib\/shaarli\/datastore.php",
  #              "ban_file": "\/var\/lib\/shaarli\/ipbans.php",
  #              "updates": "\/var\/lib\/shaarli\/updates.txt",
  #              "log": "\/var\/lib\/shaarli\/log.txt",
  #              "update_check": "\/var\/lib\/shaarli\/lastupdatecheck.txt",
  #              "raintpl_tmp": "\/var\/lib\/shaarli\/tmp",
  #              "thumbnails_cache": "\/var\/lib\/shaarli\/cache",
  #              "page_cache": "\/var\/lib\/shaarli\/pagecache"
  #          },
  #          "updates": {
  #              "check_updates": false
  #          }
  #      }
  #      */ ?>

  installPhase = ''
    rm -r {cache,pagecache,tmp,data}/
    mkdir -p $doc/share/doc
    mv doc/ $doc/share/doc/shaarli
    mkdir $out/
    cp -R ./* $out
  '';

  meta = {
    description = "Personal, minimalist, super-fast, database free, bookmarking service";
    license = lib.licenses.gpl3Plus;
    homepage = "https://github.com/shaarli/Shaarli";
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
