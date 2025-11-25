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
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "postfixadmin";
    repo = "postfixadmin";
    tag = "postfixadmin-${finalAttrs.version}";
    hash = "sha256-mr5FBURTGP2J3JMlcexXjz4GFJNqPR4rZyqHVN7+6iM=";
  };

  vendorHash = "sha256-gv6QYuHGo2r2WgtLPLco/PmKxYSijDkpWoF/vIR5y5s=";

  # Upstream does not ship a lock file, we have to maintain our own for now.
  # https://github.com/postfixadmin/postfixadmin/issues/948
  composerLock = ./composer.lock;

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
