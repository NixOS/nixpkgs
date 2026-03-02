{ runTest }:

{
  file-sink = runTest ./file-sink.nix;
  api = runTest ./api.nix;
  caddy-clickhouse = runTest ./caddy-clickhouse.nix;
  dnstap = runTest ./dnstap.nix;
  journald-clickhouse = runTest ./journald-clickhouse.nix;
  nginx-clickhouse = runTest ./nginx-clickhouse.nix;
  syslog-quickwit = runTest ./syslog-quickwit.nix;
}
