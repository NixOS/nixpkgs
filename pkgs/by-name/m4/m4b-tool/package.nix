{
  lib,
  fetchFromGitHub,
  php,
  ffmpeg-headless,
  mp4v2,
  fdk-aac-encoder,
  withFdkAac ? false,
  makeWrapper,
  testers,
  nix-update-script,
}:

php.buildComposerProject (finalAttrs: {
  pname = "m4b-tool";
  version = "0.5.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sandreas";
    repo = "m4b-tool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g/qNKdrcZCPOsUn1bW0ow+35AG+rYAmqG/Kca96C86w=";
  };

  composerStrictValidation = false;

  vendorHash = "sha256-6jkKVS1VwuD8uHxHA7KkLa+TQEL1ZuhSv7y2PYP9eFQ=";

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace bin/m4b-tool.php \
      --replace-fail '@package_version@' '${finalAttrs.version}'
  '';

  postInstall = ''
    find "$out/share/php/${finalAttrs.pname}" -mindepth 1 -maxdepth 1 \
      ! -name bin \
      ! -name src \
      ! -name vendor \
      ! -name composer.json \
      ! -name composer.lock \
      ! -name LICENSE \
      -exec rm -rf {} +

    rm -rf $out/bin
    mkdir -p $out/bin

    makeWrapper ${lib.getExe php} $out/bin/m4b-tool \
      --add-flags "$out/share/php/${finalAttrs.pname}/bin/m4b-tool.php" \
      --prefix PATH : ${
        lib.makeBinPath (
          [
            ffmpeg-headless
            mp4v2
          ]
          ++ (lib.optional withFdkAac fdk-aac-encoder)
        )
      } \
      --set M4B_TOOL_DISABLE_TONE true
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A command line utility to merge, split and chapterize audiobook files such as mp3, ogg, flac, m4a or m4b";
    homepage = "https://github.com/sandreas/m4b-tool";
    changelog = "https://github.com/sandreas/m4b-tool/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [ mit ] ++ lib.optional withFdkAac fraunhofer-fdk;
    maintainers = with lib.maintainers; [ lnk3 ];
    mainProgram = "m4b-tool";
    platforms = php.meta.platforms;
  };
})
