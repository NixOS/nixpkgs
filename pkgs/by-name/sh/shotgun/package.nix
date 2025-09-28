{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "shotgun";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "neXromancers";
    repo = "shotgun";
    rev = "v${version}";
    sha256 = "sha256-sBstFz7cYfwVQpDZeC3wPjzbKU5zQzmnhiWNqiCda1k=";
  };

  cargoHash = "sha256-Hv/lQhxRJvvMB5LC5K7k9SmuUCfaVZJynWIz8QOeL9A=";

  meta = with lib; {
    description = "Minimal X screenshot utility";
    homepage = "https://github.com/neXromancers/shotgun";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [
      figsoda
      lumi
    ];
    platforms = platforms.linux;
    mainProgram = "shotgun";
  };
}
