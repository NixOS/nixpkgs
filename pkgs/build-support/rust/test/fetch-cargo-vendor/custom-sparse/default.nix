{ rustPlatform, python3 }:

# Exercises fetchCargoVendor against self-hosted sparse registries, served
# locally from ./registry over http://127.0.0.1:18080 while the vendored-deps
# staging derivation performs the fetches. Covers fetching the registry
# config.json to derive download URLs, the `{crate}@{version}` and `{prefix}`
# download URL templates, and storing tarballs of the same crate from
# different registries in separate directories.

rustPlatform.buildRustPackage {
  pname = "custom-sparse";
  version = "0.1.0";

  src = ./package;

  cargoHash = "sha256-8R94RKR1YWlrVWpmZ7pPUJcA/uXrqVKB79fUl+EZLDA=";

  depsExtraArgs = {
    nativeBuildInputs = [ python3 ];
    preBuild = ''
      python3 -m http.server 18080 --directory ${./registry} >/dev/null 2>&1 &
      server_pid=$!
      trap 'kill $server_pid 2>/dev/null || true' EXIT
    '';
    postBuild = ''
      kill $server_pid 2>/dev/null || true
    '';
  };

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/custom-sparse
  '';
}
