{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  makeWrapper,
  perl,
  perlPackages,
  flac,
  lame,
}:

let
  runtimeDeps = [
    flac
    lame
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "flac2mp3";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "robinbowes";
    repo = "flac2mp3";
    tag = finalAttrs.version;
    hash = "sha256-mzZAlCMQYcKEkeJ0464zE1+F5KwA9IjvAbx6aZVCaxI=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/sktt/flac2mp3/commit/c81cb6f300445f2383562991b35d8622197635d7.patch";
      hash = "sha256-vLXo+PfRQ97cNQnMoBrxA7K35C1EdedXXSL8wmWpPOs=";
    })
  ];

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ perl ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib
    cp -r lib/* $out/lib/
    install -Dm755 flac2mp3.pl $out/bin/flac2mp3

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/flac2mp3 \
      --prefix PERL5LIB : "$out/lib" \
      --prefix PATH : ${lib.makeBinPath finalAttrs.passthru.runtimeDeps}
  '';

  passthru = {
    inherit runtimeDeps;
  };

  meta = {
    mainProgram = "flac2mp3";
    description = "Tool to convert audio files from flac to mp3 format including the copying of tags";
    homepage = "https://github.com/robinbowes/flac2mp3";
    changelog = "https://github.com/robinbowes/flac2mp3/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ lilahummel ];
  };
})
