{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre_headless,
  gnused,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ktlint";
  version = "1.8.0";

  src = fetchurl {
    url = "https://github.com/pinterest/ktlint/releases/download/${finalAttrs.version}/ktlint";
    sha256 = "sha256-o/1iAgfVxA2myniblef4I8VOhUt/ref2E+kQlqNwbXU=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    install -Dm755 $src $out/bin/ktlint
  '';

  postFixup = ''
    wrapProgram $out/bin/ktlint --prefix PATH : "${
      lib.makeBinPath [
        jre_headless
        gnused
      ]
    }"
  '';

  meta = {
    description = "Anti-bikeshedding Kotlin linter with built-in formatter";
    homepage = "https://ktlint.github.io/";
    license = lib.licenses.mit;
    platforms = jre_headless.meta.platforms;
    changelog = "https://github.com/pinterest/ktlint/blob/master/CHANGELOG.md";
    maintainers = with lib.maintainers; [
      tadfisher
      SubhrajyotiSen
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    mainProgram = "ktlint";
  };
})
