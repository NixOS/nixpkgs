{ runTest }:
{
  service-endpoints = runTest ./service-endpoints.nix;
  otlp-ingestion = runTest ./otlp-ingestion.nix;
}
