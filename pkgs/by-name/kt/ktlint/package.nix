{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre_headless,
  gnused,
}:

stdenv.mkDerivation rec {
  pname = "ktlint";
<<<<<<< HEAD
  version = "1.8.0";

  src = fetchurl {
    url = "https://github.com/pinterest/ktlint/releases/download/${version}/ktlint";
    sha256 = "sha256-o/1iAgfVxA2myniblef4I8VOhUt/ref2E+kQlqNwbXU=";
=======
  version = "1.7.1";

  src = fetchurl {
    url = "https://github.com/pinterest/ktlint/releases/download/${version}/ktlint";
    sha256 = "sha256-tZagXwk2ThmXtkQVJoOvEv71iUTzrPq994Bx9aSQ65g=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
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
=======
  meta = with lib; {
    description = "Anti-bikeshedding Kotlin linter with built-in formatter";
    homepage = "https://ktlint.github.io/";
    license = licenses.mit;
    platforms = jre_headless.meta.platforms;
    changelog = "https://github.com/pinterest/ktlint/blob/master/CHANGELOG.md";
    maintainers = with maintainers; [
      tadfisher
      SubhrajyotiSen
    ];
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "ktlint";
  };
}
