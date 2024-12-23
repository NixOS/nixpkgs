lib:

{ cert, groups, services }:
let
  catSep = builtins.concatStringsSep;

  svcUser = svc: svc.serviceConfig.User or "root";
  svcGroups = svc:
    (lib.optional (svc.serviceConfig ? Group) svc.serviceConfig.Group)
    ++ lib.toList (svc.serviceConfig.SupplementaryGroups or [ ]);
in
{
  assertion = builtins.all (svc:
    svcUser svc == "root"
    || builtins.elem (svcUser svc) groups.${cert.group}.members
    || builtins.elem cert.group (svcGroups svc)
  ) services;

  message = "Certificate ${cert.domain} (group=${cert.group}) must be readable by service(s) ${
    catSep ", " (map (svc: "${svc.name} (user=${svcUser svc} groups=${catSep "," (svcGroups svc)})") services)
  }";
}
