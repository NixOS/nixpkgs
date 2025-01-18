{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.nghttpx;

  # renderHost :: Either ServerOptions Path -> String
  renderHost =
    server:
    if builtins.isString server then
      "unix://${server}"
    else
      "${server.host},${builtins.toString server.port}";

  # Filter out submodule parameters whose value is null or false or is
  # the key _module.
  #
  # filterParams :: ParamsSubmodule -> ParamsSubmodule
  filterParams =
    p:
    lib.filterAttrs (n: v: ("_module" != n) && (null != v) && (false != v)) (
      lib.optionalAttrs (null != p) p
    );

  # renderBackend :: BackendSubmodule -> String
  renderBackend =
    backend:
    let
      host = renderHost backend.server;
      patterns = lib.concatStringsSep ":" backend.patterns;

      # Render a set of backend parameters, this is somewhat
      # complicated because nghttpx backend patterns can be entirely
      # omitted and the params may be given as a mixed collection of
      # 'key=val' pairs or atoms (e.g: 'proto=h2;tls')
      params = lib.mapAttrsToList (
        n: v:
        if builtins.isBool v then
          n
        else if builtins.isString v then
          "${n}=${v}"
        else
          "${n}=${builtins.toString v}"
      ) (filterParams backend.params);

      # NB: params are delimited by a ";" which is the same delimiter
      # to separate the host;[pattern];[params] sections of a backend
      sections = builtins.filter (e: "" != e) (
        [
          host
          patterns
        ]
        ++ params
      );
      formattedSections = lib.concatStringsSep ";" sections;
    in
    "backend=${formattedSections}";

  # renderFrontend :: FrontendSubmodule -> String
  renderFrontend =
    frontend:
    let
      host = renderHost frontend.server;
      params0 = lib.mapAttrsToList (n: v: if builtins.isBool v then n else v) (
        filterParams frontend.params
      );

      # NB: nghttpx doesn't accept "tls", you must omit "no-tls" for
      # the default behavior of turning on TLS.
      params1 = lib.remove "tls" params0;

      sections = [ host ] ++ params1;
      formattedSections = lib.concatStringsSep ";" sections;
    in
    "frontend=${formattedSections}";

  configurationFile = pkgs.writeText "nghttpx.conf" ''
    ${lib.optionalString (null != cfg.tls) ("private-key-file=" + cfg.tls.key)}
    ${lib.optionalString (null != cfg.tls) ("certificate-file=" + cfg.tls.crt)}

    user=nghttpx

    ${lib.concatMapStringsSep "\n" renderFrontend cfg.frontends}
    ${lib.concatMapStringsSep "\n" renderBackend cfg.backends}

    backlog=${builtins.toString cfg.backlog}
    backend-address-family=${cfg.backend-address-family}

    workers=${builtins.toString cfg.workers}
    rlimit-nofile=${builtins.toString cfg.rlimit-nofile}

    ${lib.optionalString cfg.single-thread "single-thread=yes"}
    ${lib.optionalString cfg.single-process "single-process=yes"}

    ${cfg.extraConfig}
  '';
in
{
  imports = [
    ./nghttpx-options.nix
  ];

  config = lib.mkIf cfg.enable {

    users.groups.nghttpx = { };
    users.users.nghttpx = {
      group = config.users.groups.nghttpx.name;
      isSystemUser = true;
    };

    systemd.services = {
      nghttpx = {
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        script = ''
          ${pkgs.nghttp2}/bin/nghttpx --conf=${configurationFile}
        '';

        serviceConfig = {
          Restart = "on-failure";
          RestartSec = 60;
        };
      };
    };
  };
}
