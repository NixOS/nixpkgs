{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

let
  pname = "gluesql";
  version = "0.14.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "gluesql";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-z2fpyPJfyPtO13Ly7XRmMW3rp6G3jNLsMMFz83Wmr0E=";
  };

  cargoHash = "sha256-xInwN/wZpHD3/vKcA+oYL9tmSD7P7/L8ZZOXZq0gkac=";

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "GlueSQL is quite sticky. It attaches to anywhere";
    homepage = "https://github.com/gluesql/gluesql";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
    platforms = platforms.all;
  };
}
