{
  fetchFromGitHub,
  lib,
  php84,
}:

let
  php = php84;
in
php.buildComposerProject2 (finalAttrs: {
  pname = "postfixadmin";
  version = "4.0.7";

  src = fetchFromGitHub {
    owner = "postfixadmin";
    repo = "postfixadmin";
    tag = "postfixadmin-${finalAttrs.version}";
    hash = "sha256-DOdWRVlGIoSp6OoWxksFOSfdvYcE0TBTelT4fZlvWEI=";
  };

  # Upstream does not ship a lock file, we have to maintain our own for now.
  # https://github.com/postfixadmin/postfixadmin/issues/948
  composerLock = ./composer.lock;
  vendorHash = "sha256-r0iw687ymJHxGhxuZmUef747sB9pFc6FUDv0CjmOJ8Y=";

  postInstall = ''
    out_dir="$out"/share/php/postfixadmin/

    ln -sf /etc/postfixadmin/config.local.php "$out_dir"
    ln -sf /var/cache/postfixadmin/templates_c "$out_dir"
  '';

  passthru.phpPackage = php;

  meta = {
    changelog = "https://github.com/postfixadmin/postfixadmin/releases/tag/${finalAttrs.src.tag}";
    description = "Web based virtual user administration interface for Postfix mail servers";
    homepage = "https://postfixadmin.sourceforge.io/";
    maintainers = with lib.maintainers; [ yayayayaka ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
})
