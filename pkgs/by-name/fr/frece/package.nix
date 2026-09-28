{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "frece";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "YodaEmbedding";
    repo = "frece";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-CAiIqT5KuzrqbV9FVK3nZUe8MDs2KDdsKplJMI7rN9w=";
  };

  cargoHash = "sha256-4d1bgkwzC0jFD21Yb8mbnLXTqXTRsJPsMPidSRY4GVw=";

  meta = {
    description = "Maintain a database sorted by frecency (frequency + recency)";
    mainProgram = "frece";
    homepage = "https://github.com/YodaEmbedding/frece";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
