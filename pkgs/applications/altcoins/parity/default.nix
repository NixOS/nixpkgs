let
  version     = "1.11.10";
  sha256      = "15sk6dvc8h1bdm6v7xlq517km0bakb9f13h1n7ixj311vahnmk15";
  cargoSha256 = "0p2idd36cyzp2ax81k533bdma4hz0ws2981qj2s7jnhvmj4941l8";
  patches     = [ ./patches/vendored-sources-1.11.patch ];
in
  import ./parity.nix { inherit version sha256 cargoSha256 patches; }
