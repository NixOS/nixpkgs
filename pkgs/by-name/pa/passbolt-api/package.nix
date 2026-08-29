{
  lib,
  fetchFromGitHub,
  php84,
  runtimeShell,
  dataDir ? "/var/lib/passbolt",
}:

let
  php = php84.withExtensions (
    { enabled, all }:
    enabled
    ++ [
      all.gnupg
    ]
  );
in
php.buildComposerProject2 (finalAttrs: {
  pname = "passbolt-api";
  version = "5.11.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "passbolt";
    repo = "passbolt_api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UztKY1lEZiZ1xHUUWNQKYhmCvbTRuZqDDdDANRgXqmo=";
  };

  composerNoPlugins = false;
  composerStrictValidation = false;
  vendorHash = "sha256-wcCy7biYuzEMKWRuVDBUZazPa3oGqaQADDx25SCTvA8=";

  postInstall = ''
    chmod -R u+w $out/share
    mv $out/share/php/passbolt-api/* $out
    cp $out/config/app.default.php $out/config/app.php
    substituteInPlace $out/config/bootstrap.php \
      --replace-fail "use Cake\Log\Log;" $'use Cake\Http\ServerRequest;\nuse Cake\Log\Log;'

    printf '%s\n' \
      "" \
      "ServerRequest::addDetector('ssl', static function (ServerRequest \$request): bool {" \
      "    return env('HTTPS') === 'on'" \
      "        || env('HTTPS') === '1'" \
      "        || env('HTTP_X_FORWARDED_PROTO') === 'https'" \
      "        || env('REQUEST_SCHEME') === 'https'" \
      "        || env('SERVER_PORT') === '443';" \
      "});" \
      >> $out/config/bootstrap.php
    cp -r $out/config/Migrations $out/config/Migrations.dist
    rm -r $out/config/Migrations
    rm -r $out/config/gpg $out/config/jwt
    ln -s ${dataDir}/config/passbolt.php $out/config/passbolt.php
    ln -s ${dataDir}/config/Migrations $out/config/Migrations
    ln -s ${dataDir}/config/gpg $out/config/gpg
    ln -s ${dataDir}/config/jwt $out/config/jwt
    substituteInPlace $out/bin/cake \
      --replace-fail "#!/usr/bin/env sh" "#!${runtimeShell}" \
      --replace-fail "for TESTEXEC in php php-cli /usr/local/bin/php" "for TESTEXEC in ${php}/bin/php"
    rm -r $out/share $out/tmp
    ln -s ${dataDir}/tmp $out/tmp
    ln -s ${dataDir}/logs $out/logs
  '';

  passthru.phpPackage = php;

  meta = {
    description = "Open source password manager for teams";
    homepage = "https://www.passbolt.com/";
    changelog = "https://github.com/passbolt/passbolt_api/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
  };
})
