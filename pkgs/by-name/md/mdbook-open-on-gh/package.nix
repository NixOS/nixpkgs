{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-open-on-gh";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "badboy";
    repo = "mdbook-open-on-gh";
    rev = version;
    hash = "sha256-I1n/RJq6mcg+DTocKlYoZi5G7yijsruU8PwICZ2/JMQ=";
  };

  cargoHash = "sha256-jbBwXYUIkrDyf9qC2cL5czbXCM2/JrbBUmKJZb+VEAk=";

  meta = with lib; {
    description = "mdbook preprocessor to add a open-on-github link on every page";
    mainProgram = "mdbook-open-on-gh";
    homepage = "https://github.com/badboy/mdbook-open-on-gh";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
