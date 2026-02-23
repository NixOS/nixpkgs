{
  buildNpmPackage,
  fetchFromGitHub,
  nodejs_22,
  lib,
}:
buildNpmPackage (finalAttrs: {
  pname = "sillytavern";
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "SillyTavern";
    repo = "SillyTavern";
    tag = finalAttrs.version;
    hash = "sha256-v2OAyaKBczo7BdTyA3WUlcIko484YgcgvYmwUk60AeI=";
  };
  npmDepsHash = "sha256-fzKZnJbVXaPFn4l7VGiYBqJUT299fiVuKqfTZd2p53c=";

  dontNpmBuild = true;

  # https://github.com/NixOS/nixpkgs/issues/474535
  nodejs = nodejs_22;

  # These dirs are not installed automatically.
  # And if they were not in place, the app would try to create them at runtime, which is of course impossible to achieve.
  postInstall = ''
    mkdir $out/lib/node_modules/sillytavern/{backups,public/scripts/extensions/third-party}
  '';

  meta = {
    description = "LLM Frontend for Power Users";
    longDescription = ''
      SillyTavern is a user interface you can install on your computer (and Android phones) that allows you to interact with
      text generation AIs and chat/roleplay with characters you or the community create.

      This package makes a global installation, instead of a standalone installation according to the official tutorial.
      See [the official documentation](https://docs.sillytavern.app/installation/#global--standalone-mode) for the context.
    '';
    downloadPage = "https://github.com/SillyTavern/SillyTavern/releases";
    homepage = "https://docs.sillytavern.app/";
    mainProgram = "sillytavern";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.wrvsrx ];
  };
})
