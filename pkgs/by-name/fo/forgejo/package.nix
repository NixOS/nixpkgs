import ./generic.nix {
  version = "17.0.1";
  hash = "sha256-O12795/ydtEequagQfHfOhKTEp8QlmzsJe+RtlHC60A=";
  npmDepsHash = "sha256-5TrydMO82d30L/EaWg3GI+yaBwG6tZS4IVs+dydpKRY=";
  vendorHash = "sha256-vXjsZ08eez3oiLL2Um+uFX9YbrRnbq8q5Pj/P3mZTeY=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
