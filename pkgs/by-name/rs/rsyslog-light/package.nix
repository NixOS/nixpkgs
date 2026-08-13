{
  rsyslog,
}:

rsyslog.override {
  withKrb5 = false;
  withSystemd = false;
  withJemalloc = false;
  withMysql = false;
  withPostgres = false;
  withDbi = false;
  withNetSnmp = false;
  withUuid = false;
  withCurl = false;
  withGnutls = false;
  withGcrypt = false;
  withLognorm = false;
  withMaxminddb = false;
  withOpenssl = false;
  withRelp = false;
  withKsi = false;
  withLogging = false;
  withNet = false;
  withHadoop = false;
  withRdkafka = false;
  withMongo = false;
  withCzmq = false;
  withRabbitmq = false;
  withHiredis = false;
}
