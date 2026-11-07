{
  php,
  fetchFromGitHub,
  lib,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "lam";
  version = "9.5.1";

  src = fetchFromGitHub {
    owner = "LDAPAccountManager";
    repo = "lam";
    tag = finalAttrs.version;
    hash = "sha256-oovZCbZhpMpkX9FH5/CpDarXQam2cm0S660HpFBolhw=";
  };

  sourceRoot = "${finalAttrs.src.name}/lam";

  php = php.buildEnv {
    extensions = (
      { enabled, all }:
      enabled
      ++ (with all; [
        gd
        gettext
        gmp
        iconv
        imagick
        ldap
        mbstring
        openssl
        zip
      ])
    );
  };

  composerLock = ./composer.lock;
  vendorHash = "sha256-S3ecBwdZ82SfR8vR5KRG5hP3/kEpvqQHTstY99620NE=";

  composerNoPlugins = false;
  composerStrictValidation = false;

  postInstall = ''
    chmod -R u+w $out/share
    mkdir -p $out/share/lam
    cp -a $out/share/php/lam/. $out/share/lam/
    rm -rf $out/share/php
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Web frontend for managing entries stored in an LDAP directory";
    homepage = "https://www.ldap-account-manager.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ znaniye ];
  };
})
