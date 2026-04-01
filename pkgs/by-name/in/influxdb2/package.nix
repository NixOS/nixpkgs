# For backwards compatibility with older versions of influxdb2,
# which bundled the server and CLI into the same derivation. Will be
# removed in a few releases.
# - David Anderson 2021-12-16 in 84bc3a02807fd
{
  buildEnv,
  influxdb2-server,
  influxdb2-cli,
}:
buildEnv {
  name = "influxdb2";
  paths = [
    influxdb2-server
    influxdb2-cli
  ];
}
