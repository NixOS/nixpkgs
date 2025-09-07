{
  makeBinaryWrapper,
  buildNpmPackage,
  nodejs,
  fetchFromGitHub,
  lib,
}:
buildNpmPackage (finalAttrs: {
  pname = "sillytavern";
  version = "1.13.2";

  src = fetchFromGitHub {
    owner = "SillyTavern";
    repo = "SillyTavern";
    tag = finalAttrs.version;
    hash = "sha256-tTBpSXkXzQjp3TW9hksqUpA3sagR2GSY42bHLHEd9oI=";
  };
  npmDepsHash = "sha256-hayhsEZN857V6bsWPXupLeqxcOr1sgKs0uWN2pSQD+k=";

  nativeBuildInputs = [ makeBinaryWrapper ];

  dontNpmBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,opt}
    cp -r . $out/opt/sillytavern
    makeWrapper ${lib.getExe nodejs} $out/bin/sillytavern \
      --add-flags $out/opt/sillytavern/server.js \
      --set-default NODE_ENV production

    runHook postInstall
  '';

  meta = {
    description = "LLM Frontend for Power Users";
    longDescription = ''
      SillyTavern is a user interface you can install on your computer (and Android phones) that allows you to interact with
      text generation AIs and chat/roleplay with characters you or the community create.
    '';
    downloadPage = "https://github.com/SillyTavern/SillyTavern/releases";
    homepage = "https://docs.sillytavern.app/";
    mainProgram = "sillytavern";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.wrvsrx ];
  };
})
