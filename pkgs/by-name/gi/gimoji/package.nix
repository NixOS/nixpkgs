{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gimoji";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "zeenix";
    repo = "gimoji";
    rev = finalAttrs.version;
    hash = "sha256-YfKMawhoLyWXy37/qegpR4EuyrKPIEBxUmnIPtuJnxU=";
  };

  cargoHash = "sha256-6RJj1DwZzRVQgExg5E4izrUeHtUdRAXcNQJPAAv3ya0=";

  meta = {
    description = "Easily add emojis to your git commit messages";
    homepage = "https://github.com/zeenix/gimoji";
    license = lib.licenses.mit;
    mainProgram = "gimoji";
    maintainers = with lib.maintainers; [ a-kenji ];
  };
})
