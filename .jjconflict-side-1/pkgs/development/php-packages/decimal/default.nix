{
  buildPecl,
  lib,
  mpdecimal,
  php,
}:
let
  version = "1.5.0";
in
buildPecl {
  pname = "decimal";

  version = version;
  hash = "sha256-it8w8hOLYwtCZoDYhaP5k5TD/pQLtj37K2lSESF80ok=";

  buildInputs = [ mpdecimal ];
  configureFlags = [ "--with-libmpdec-path=${mpdecimal}" ];

  meta = {
    description = "Arbitrary-precision decimal arithmetic for PHP";
    homepage = "https://php-decimal.github.io";
    changelog = "https://pecl.php.net/package-changelog.php?package=decimal&release=${version}";
    license = lib.licenses.mit;
    teams = [ lib.teams.php ];
  };
}
