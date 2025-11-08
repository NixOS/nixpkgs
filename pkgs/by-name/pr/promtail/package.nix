{ grafana-loki }:

grafana-loki.overrideAttrs (previousAttrs: {
  pname = "promtail";
  subPackages = [ "clients/cmd/promtail" ];
  env = previousAttrs.env or { } // {
    CGO_ENABLED = 1;
  };
})
