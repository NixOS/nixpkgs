{ config, pkgs, lib, serverInfo, ... }:
let
  inherit (pkgs) foswiki;
  inherit (serverInfo.serverConfig) user group;
  inherit (config) vardir;
in
{
  options.vardir = lib.mkOption {
    type = lib.types.path;
    default = "/var/www/foswiki";
    description = "The directory where variable foswiki data will be stored and served from.";
  };

  # TODO: this will probably need to be better customizable
  extraConfig =
    let httpd-conf = pkgs.runCommand "foswiki-httpd.conf"
      { preferLocalBuild = true; }
      ''
        substitute '${foswiki}/foswiki_httpd_conf.txt' "$out" \
          --replace /var/www/foswiki/ "${vardir}/"
      '';
    in
      ''
        RewriteEngine on
        RewriteRule /foswiki/(.*) ${vardir}/$1

        <Directory "${vardir}">
          Require all granted
        </Directory>

        Include ${httpd-conf}
        <Directory "${vardir}/pub">
          Options FollowSymlinks
        </Directory>
      '';

  /** This handles initial setup and updates.
      It will probably need some tweaking, maybe per-site.  */
  startupScript = pkgs.writeScript "foswiki_startup.sh" (
    let storeLink = "${vardir}/package"; in
    ''
      [ -e '${storeLink}' ] || needs_setup=1
      mkdir -p '${vardir}'
      cd '${vardir}'
      ln -sf -T '${foswiki}' '${storeLink}'

      if [ -n "$needs_setup" ]; then # do initial setup
        mkdir -p bin lib
        # setup most of data/ as copies only
        cp -r '${foswiki}'/data '${vardir}/'
        rm -r '${vardir}'/data/{System,mime.types}
        ln -sr -t '${vardir}/data/' '${storeLink}'/data/{System,mime.types}

        ln -sr '${storeLink}/locale' .

        mkdir pub
        ln -sr '${storeLink}/pub/System' pub/

        mkdir templates
        ln -sr '${storeLink}'/templates/* templates/

        ln -sr '${storeLink}/tools' .

        mkdir -p '${vardir}'/working/{logs,tmp}
        ln -sr '${storeLink}/working/README' working/ # used to check dir validity

        chown -R '${user}:${group}' .
        chmod +w -R .
      fi

      # bin/* and lib/* shall always be overwritten, in case files are added
      ln -srf '${storeLink}'/bin/* '${vardir}/bin/'
      ln -srf '${storeLink}'/lib/* '${vardir}/lib/'
    ''
    /* Symlinking bin/ one-by-one ensures that ${vardir}/lib/LocalSite.cfg
        is used instead of ${foswiki}/... */
  );
}
