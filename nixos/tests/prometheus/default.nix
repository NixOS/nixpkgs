{ runTest }:

{
  alertmanager = runTest ./alertmanager.nix;
  alertmanager-ntfy = runTest ./alertmanager-ntfy.nix;
  config-reload = runTest ./config-reload.nix;
  federation = runTest ./federation.nix;
  prometheus-pair = runTest ./prometheus-pair.nix;
  pushgateway = runTest ./pushgateway.nix;
  remote-write = runTest ./remote-write.nix;
  ui = runTest ./ui.nix;
}
