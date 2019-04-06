{ lib }:

with lib;

cfg: let
  bcfg = cfg.builds;
  dcfg = cfg.dispatch;
  gcfg = cfg.git;
  hcfg = cfg.hg;
  lcfg = cfg.lists;
  macfg = cfg.man;
  mecfg = cfg.meta;
  tcfg = cfg.todo;

  hasBuilds = elem "builds" cfg.services;
  hasDispatch = elem "dispatch" cfg.services;
  hasGit = elem "git" cfg.services;
  hasHg = elem "hg" cfg.services;
  hasLists = elem "lists" cfg.services;
  hasMan = elem "man" cfg.services;
  hasMeta = elem "meta" cfg.services;
  hasTodo = elem "todo" cfg.services;

  inherit (import ./helpers.nix { inherit lib; }) generateRedisURL generateConnectionString;

  generateBaseServiceConfig = serviceConfig: ''
    origin=${cfg.server.protocol}://${serviceConfig.domain}
    debug-host=${serviceConfig.debug.host}
    debug-port=${toString serviceConfig.debug.port}
    connection-string=${generateConnectionString serviceConfig.database}
    ${optionalString (builtins.hasAttr "migrateOnUpgrade" serviceConfig) ''
      migrate-on-upgrade=${serviceConfig.migrateOnUpgrade}
    ''}

    ${optionalString (builtins.hasAttr "oauth" serviceConfig) ''
      oauth-client-id=${toString serviceConfig.oauth.clientId}
      oauth-client-secret=${serviceConfig.oauth.clientSecret}
    ''}

    ${serviceConfig.extraConfig}
  '';
in ''
  [sr.ht]
  site-name=${cfg.site.name}
  site-info=${cfg.site.info}
  site-blurb=${cfg.site.blurb}
  owner-name=${cfg.owner.name}
  owner-email=${cfg.owner.email}
  source-url=${cfg.source}
  secret-key=${cfg.secretKey}

  ${cfg.extraConfig}

  [mail]
  smtp-host=${cfg.mail.host}
  smtp-port=${toString cfg.mail.port}
  smtp-user=${cfg.mail.user}
  smtp-password=${cfg.mail.password}
  smtp-from=${cfg.mail.from}

  error-to=${cfg.mail.error.to}
  error-from=${cfg.mail.error.from}

  pgp-privkey=${cfg.mail.pgp.privateKey}
  pgp-pubkey=${cfg.mail.pgp.publicKey}
  pgp-key-id=${cfg.mail.pgp.keyId}

  ${optionalString hasBuilds ''
    [builds.sr.ht]
    ${generateBaseServiceConfig bcfg}

    redis=${generateRedisURL bcfg.redis}

    ${optionalString (bcfg.worker.user != null) ''
      [builds.sr.ht::worker]
      runner=${bcfg.worker.name}
      buildlogs=${bcfg.worker.buildLogs}
      images=${bcfg.worker.images}
      controlcmd=${bcfg.worker.controlCommand}
      timeout=${bcfg.worker.timeout}

      ${bcfg.worker.extraConfig}
    ''}
  ''}

  ${optionalString hasDispatch ''
    [dispatch.sr.ht]
    ${generateBaseServiceConfig dcfg}

    [dispatch.sr.ht::github]
    oauth-client-id=${toString dcfg.github.oauth.clientId}
    oauth-client-secret=${dcfg.github.oauth.clientSecret}

    ${dcfg.github.extraConfig}
  ''}

  ${optionalString hasGit ''
    [git.sr.ht]
    ${generateBaseServiceConfig gcfg}

    shell=${gcfg.shell}
    post-update-script=${gcfg.postUpdateScript}
    redis=${generateRedisURL gcfg.redis}
    repos=${gcfg.repos.path}

    [git.sr.ht::dispatch]
    ${concatStringsSep "\n" gcfg.dispatch}
  ''}

  ${optionalString hasHg ''
    [hg.sr.ht]
    ${generateBaseServiceConfig hcfg}

    changegroup-script=${hcfg.changeGroupScript}
    post-update-script=${hcfg.postUpdateScript}
    repos=${hcfg.repos.path}

    [hg.sr.ht::dispatch]
    ${concatStringsSep "\n" hcfg.dispatch}
  ''}

  ${optionalString hasLists ''
    [lists.sr.ht]
    ${generateBaseServiceConfig lcfg}

    redis=${generateRedisURL lcfg.redis}
    posting-domain=${lcfg.postingDomain}

    [lists.sr.ht::worker]
    sock=${lcfg.worker.socket.path}
    sock-group=${lcfg.worker.socket.group}
    permit-mimetypes=${concatStringsSep "," lcfg.worker.mimeTypes.permit}
    reject-mimetypes=${concatStringsSep "," lcfg.worker.mimeTypes.reject}
    reject-url=${lcfg.worker.rejectUrl}

    ${lcfg.worker.extraConfig}
  ''}

  ${optionalString hasMan ''
    [man.sr.ht]
    ${generateBaseServiceConfig macfg}

    git-user=${macfg.repos.user}:${macfg.repos.user}
    repo-path=${macfg.repos.path}
  ''}

  ${optionalString hasMeta ''
    [meta.sr.ht]
    ${generateBaseServiceConfig mecfg}

    [meta.sr.ht::settings]
    registration=${mecfg.settings.registration}
    onboarding-redirect=${mecfg.settings.onboardingRedirect}
    user-invites=${toString mecfg.settings.userInvites}

    ${mecfg.settings.extraConfig}

    [meta.sr.ht::aliases]
    ${concatMapStringsSep "\n" (attr: "${attr}=${toString mecfg.aliases."${attr}"}") (builtins.attrNames mecfg.aliases)}

    [meta.sr.ht::billing]
    enabled=${mecfg.billing.enable}
    stripe-public-key=${mecfg.billing.stripePubKey}
    stripe-secret-key=${mecfg.billing.stripeSecretKey}

    ${mecfg.billing.extraConfig}
  ''}

  ${optionalString hasTodo ''
    [todo.sr.ht]
    ${generateBaseServiceConfig tcfg}

    notify-from=${tcfg.notifyFrom}
  ''}
''
