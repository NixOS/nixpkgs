{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "shotgun";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "neXromancers";
    repo = "shotgun";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-sBstFz7cYfwVQpDZeC3wPjzbKU5zQzmnhiWNqiCda1k=";
  };

  cargoHash = "sha256-Hv/lQhxRJvvMB5LC5K7k9SmuUCfaVZJynWIz8QOeL9A=";

  meta = {
    description = "Minimal X screenshot utility";
    homepage = "https://github.com/neXromancers/shotgun";
    license = with lib.licenses; [ mpl20 ];
    maintainers = with lib.maintainers; [
      lumi
    ];
    platforms = lib.platforms.linux;
    mainProgram = "shotgun";
  };
})
