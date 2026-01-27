{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "enola";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "TheYahya";
    repo = "enola";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vXc/Ak4IUIzZwH67jEZrsrWk9DPbJvGuXpqIdauIOZ0=";
  };

  vendorHash = "sha256-8xwvnwpK/jExB3U7EA3Xa5kpUbqN27qvUrIwCAwWbE4=";

  meta = {
    description = "CLI to find social media accounts by username, similar to Sherlock";
    homepage = "https://github.com/TheYahya/enola";
    mainProgram = "enola";
    maintainers = with lib.maintainers; [
      nicknb
    ];
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
