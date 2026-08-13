{
  lib,
  fetchzip,
  stdenv,
  php,
  phpCfg ? null,
  withMariaDB ? false,
  withPostgreSQL ? true,
}:

assert lib.assertMsg (
  withPostgreSQL || withMariaDB
) "At least one Flyspray database driver required";

# The src tarball has the dependencies vendored. Considering that there is
# no composer.lock, the easier option is using stdenv.mkDerivation over
# php.buildComposerProject2 + building from source.
stdenv.mkDerivation (finalAttrs: {
  pname = "flyspray";
  version = "1.0-rc11";

  src = fetchzip {
    url = "https://github.com/flyspray/flyspray/releases/download/v${finalAttrs.version}/flyspray-${finalAttrs.version}.tgz";
    hash = "sha256-VNukYtHqf1OqWoyR+GXxgoX2GjTD4RfJ0SaGoDyHLJ4=";
  };

  php =
    php.buildEnv {
      # https://www.flyspray.org/docs/requirements/
      extensions = (
        { all, enabled }:
        enabled
        ++ [
          all.gd
          all.pdo
          all.xml
        ]
        ++ lib.optionals withPostgreSQL [
          all.pdo_pgsql
          all.pgsql
        ]
        ++ lib.optionals withMariaDB [
          all.mysqli
          all.mysqlnd
          all.pdo_mysql
        ]
      );
    }
    // lib.optionalAttrs (phpCfg != null) {
      extraConfig = phpCfg;
    };

  postInstall = ''
    DIR="$out/share/php/flyspray"
    mkdir -p "$DIR"
    cp -Tr "$src" "$DIR"
  '';

  meta = {
    description = "Lightweight, web-based bug tracking system written in PHP for assisting with software development and project managements";
    homepage = "https://www.flyspray.org";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ toastal ];
  };
})
