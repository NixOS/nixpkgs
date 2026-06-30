{
  icinga2,
  ...
}@args:

(icinga2.override (
  {
    withMysql = false;
    withNotification = false;
    withIcingadb = false;
    withPerfdata = false;
  }
  // removeAttrs args [ "icinga2" ]
)).overrideAttrs
  (old: {
    pname = "icinga2-agent";
  })
