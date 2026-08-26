{ buildOpenRAEngine, dotnetCorePackages }:

buildOpenRAEngine {
  build = "bleed";
  version = "20250531";
  rev = "9c8470d18e3d850583e64a5defc5d3492ba5055b";
  hash = "sha256-LQSHMmjwNAdnoq16MNjjXyvuFy9o87eXrsdRFqmoV24=";
  deps = ./deps.json;
  dotnet-sdk = dotnetCorePackages.sdk_8_0-bin;
}
