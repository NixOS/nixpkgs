{
  lib,
  stdenv,
  fetchFromGitHub,
  writeText,
  nixosTests,
  fetchpatch,
  dokuwiki,
}:

stdenv.mkDerivation rec {
  pname = "dokuwiki";
  version = "2024-02-06b";

  src = fetchFromGitHub {
    owner = "dokuwiki";
    repo = pname;
    rev = "release-${version}";
    sha256 = "sha256-jrxsVBStvRxHCAOGVUkqtzE75wRBiVR+KxSCNuI2vnk=";
  };

  patches = [
    (fetchpatch {
      # Backported from dokuwiki 2025-05-14b release
      # Since the exact same (vulnerable) code is also present in 2024-02-06b, but there is no
      # updated 2024-02-06* available.
      name = "backport-xss-fix-in-search.patch";
      url = "https://github.com/dokuwiki-translate/dokuwiki/commit/03fdedf74fd0e882fc06c06cd90a2bb608fe374b.patch";
      hash = "sha256-h6qscrZ0VNguelWyrAxQVze9H2Y5oXH2tCEpEdRqr2I=";
    })
  ];

  preload = writeText "preload.php" ''
    <?php

      $config_cascade = array(
        'acl' => array(
          'default'   => getenv('DOKUWIKI_ACL_AUTH_CONFIG'),
        ),
        'plainauth.users' => array(
          'default'   => getenv('DOKUWIKI_USERS_AUTH_CONFIG'),
          'protected' => "" // not used by default
        ),
      );
  '';

  phpLocalConfig = writeText "local.php" ''
    <?php
      return require(getenv('DOKUWIKI_LOCAL_CONFIG'));
    ?>
  '';

  phpPluginsLocalConfig = writeText "plugins.local.php" ''
    <?php
      return require(getenv('DOKUWIKI_PLUGINS_LOCAL_CONFIG'));
    ?>
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/dokuwiki
    cp -r * $out/share/dokuwiki
    cp ${preload} $out/share/dokuwiki/inc/preload.php
    cp ${phpLocalConfig} $out/share/dokuwiki/conf/local.php
    cp ${phpPluginsLocalConfig} $out/share/dokuwiki/conf/plugins.local.php

    runHook postInstall
  '';

  passthru = {
    combine =
      {
        basePackage ? dokuwiki,
        plugins ? [ ],
        templates ? [ ],
        localConfig ? null,
        pluginsConfig ? null,
        aclConfig ? null,
        pname ? (p: "${p.pname}-combined"),
      }:
      let
        isNotEmpty =
          x:
          lib.optionalString (
            !builtins.elem x [
              null
              ""
            ]
          );
      in
      basePackage.overrideAttrs (prev: {
        pname = if builtins.isFunction pname then pname prev else pname;

        postInstall = prev.postInstall or "" + ''
          ${lib.concatMapStringsSep "\n" (
            tpl: "cp -r ${toString tpl} $out/share/dokuwiki/lib/tpl/${tpl.name}"
          ) templates}
          ${lib.concatMapStringsSep "\n" (
            plugin: "cp -r ${toString plugin} $out/share/dokuwiki/lib/plugins/${plugin.name}"
          ) plugins}
          ${isNotEmpty localConfig "ln -sf ${localConfig} $out/share/dokuwiki/conf/local.php"}
          ${isNotEmpty pluginsConfig "ln -sf ${pluginsConfig} $out/share/dokuwiki/conf/plugins.local.php"}
          ${isNotEmpty aclConfig "ln -sf ${aclConfig} $out/share/dokuwiki/acl.auth.php"}
        '';
      });
    tests = {
      inherit (nixosTests) dokuwiki;
    };
  };

  meta = with lib; {
    description = "Simple to use and highly versatile Open Source wiki software that doesn't require a database";
    license = licenses.gpl2Only;
    homepage = "https://www.dokuwiki.org";
    platforms = platforms.all;
    maintainers = with maintainers; [
      _1000101
      e1mo
    ];
  };
}
