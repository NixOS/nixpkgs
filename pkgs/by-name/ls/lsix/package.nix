{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  imagemagick,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lsix";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "hackerb9";
    repo = "lsix";
    rev = finalAttrs.version;
    sha256 = "sha256-msTG7otjzksg/2XyPDy31LEb7uGXSgB8fzfHvad9nPA=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm755 lsix -t $out/bin

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/lsix \
      --prefix PATH : ${lib.makeBinPath [ (imagemagick.override { ghostscriptSupport = true; }) ]}
  '';

<<<<<<< HEAD
  meta = {
    description = "Shows thumbnails in terminal using sixel graphics";
    homepage = "https://github.com/hackerb9/lsix";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Shows thumbnails in terminal using sixel graphics";
    homepage = "https://github.com/hackerb9/lsix";
    license = licenses.gpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      justinlime
      kidonng
    ];
    mainProgram = "lsix";
  };
})
