{ icinga2 }:
icinga2.override {
  nameSuffix = "-agent";
  withMysql = false;
  withNotification = false;
  withIcingadb = false;
  withPerfdata = false;
}
