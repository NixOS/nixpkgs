{
  lib,
  rustPlatform,
  fetchCrate,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "mdbook-rss-feed";
  version = "1.3.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-zeI5O4qdQEhh3qmOhT4s3Jdw2GLuWsNjwimchEM1wCU=";
  };

  cargoHash = "sha256-0+Fe/NJZby0ygSRJLz1WWoG9B5dZmluoXVqzQPtBXSc=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    description = "mdBook preprocessor that generates RSS, Atom, and JSON feeds with rich HTML previews, optional full-content entries, and pagination support";
    mainProgram = "mdbook-rss-feed";
    homepage = "https://crates.io/crates/mdbook-rss-feed";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.saylesss88 ];
  };
}
