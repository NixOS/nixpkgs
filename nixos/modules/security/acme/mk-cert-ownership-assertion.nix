lib:

{ cert, groups, services }:
let
  catSep = builtins.concatStringsSep;

  svcGroups = svc:
    (lib.optional (svc.serviceConfig ? Group) svc.serviceConfig.Group)
    ++ (svc.serviceConfig.SupplementaryGroups or [ ]);
in
{
  assertion = builtins.all (svc:
    svc.serviceConfig.User or "root" == "root"
    || builtins.elem svc.serviceConfig.User groups.${cert.group}.members
    || builtins.elem cert.group (svcGroups svc)
  ) services;

  message = "Certificate ${cert.domain} (group=${cert.group}) must be readable by service(s) ${
    catSep ", " (map (svc: "${svc.name} (user=${svc.serviceConfig.User} groups=${catSep " " (svcGroups svc)})") services)
  }";
}
