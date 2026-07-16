{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "shaarli";
  version = "0.16.3";

  src = fetchurl {
    url = "https://github.com/shaarli/Shaarli/releases/download/v${finalAttrs.version}/shaarli-v${finalAttrs.version}-full.zip";
    sha256 = "sha256-qGZ/11NiQLp1Kj2ybDpmnM9YuwMsJbA8r2Juhys2JLQ=";
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [ unzip ];

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
