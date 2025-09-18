{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "haylxon";
  version = "1.0.0";

  src = fetchCrate {
    inherit version;
    pname = "hxn";
    hash = "sha256-zAqYaPtbXqC1YFzCL8EwE1HhuSqVl5lAfnAftwBvnoE=";
  };

  cargoHash = "sha256-cKYHC8qz81P4xtehGQIvNH/g/pa90IJQbKz0RM9tjws=";

  meta = {
    description = "Save screenshots of urls and webpages from terminal";
    homepage = "https://github.com/pwnwriter/haylxon";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ scientiac ];
    mainProgram = "hxn";
  };
}
