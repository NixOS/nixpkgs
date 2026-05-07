{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdbook-open-on-gh";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = "mdbook-open-on-gh";
    rev = finalAttrs.version;
    hash = "sha256-I1n/RJq6mcg+DTocKlYoZi5G7yijsruU8PwICZ2/JMQ=";
  };

  cargoHash = "sha256-jbBwXYUIkrDyf9qC2cL5czbXCM2/JrbBUmKJZb+VEAk=";

  meta = {
    description = "mdbook preprocessor to add a open-on-github link on every page";
    mainProgram = "mdbook-open-on-gh";
    homepage = "https://github.com/badboy/mdbook-open-on-gh";
    license = [ lib.licenses.mpl20 ];
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
})
