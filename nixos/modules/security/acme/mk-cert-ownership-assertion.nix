{
  cert,
  group,
  groups,
  user,
}:
{
  assertion = cert.group == group || builtins.any (u: u == user) groups.${cert.group}.members;
  message = "Group for certificate ${cert.domain} must be ${group}, or user ${user} must be a member of group ${cert.group}";
}
