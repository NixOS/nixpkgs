{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:
buildNpmPackage (finalAttrs: {
  pname = "sillytavern";
  version = "1.13.3";

  src = fetchFromGitHub {
    owner = "SillyTavern";
    repo = "SillyTavern";
    tag = finalAttrs.version;
    hash = "sha256-IR2lR6kkjHXIHqCZJ+KK7abxK+oyJzWyEya86e3cEn8=";
  };
  npmDepsHash = "sha256-cAfFRJY2cVBSu3gp2zGlHe84L7c9PahZDyO7iREjHWs=";

  dontNpmBuild = true;

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
