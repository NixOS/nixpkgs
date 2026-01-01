{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  rename,
  unstableGitUpdater,
}:
stdenvNoCC.mkDerivation {
  pname = "material-symbols";
<<<<<<< HEAD
  version = "4.0.0-unstable-2025-09-18";
=======
  version = "4.0.0-unstable-2025-04-11";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "google";
    repo = "material-design-icons";
<<<<<<< HEAD
    rev = "bb04090f930e272697f2a1f0d7b352d92dfeee43";
    hash = "sha256-aFKG8U4OBqh2hoHYm1n/L4bK7wWPs6o0rYVhNC7QEpI=";
=======
    rev = "941fa95d7f6084a599a54ca71bc565f48e7c6d9e";
    hash = "sha256-5bcEh7Oetd2JmFEPCcoweDrLGQTpcuaCU8hCjz8ls3M=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    sparseCheckout = [ "variablefont" ];
  };

  nativeBuildInputs = [ rename ];

  installPhase = ''
    runHook preInstall

    rename 's/\[FILL,GRAD,opsz,wght\]//g' variablefont/*
    install -Dm755 variablefont/*.ttf -t $out/share/fonts/TTF
    install -Dm755 variablefont/*.woff2 -t $out/share/fonts/woff2

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Material Symbols icons by Google";
    homepage = "https://fonts.google.com/icons";
    downloadPage = "https://github.com/google/material-design-icons";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      fufexan
      luftmensch-luftmensch
<<<<<<< HEAD
      alexphanna
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ];
    platforms = lib.platforms.all;
  };
}
