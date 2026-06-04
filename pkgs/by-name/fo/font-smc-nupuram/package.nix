{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "font-smc-nupuram";
  version = "20241013";

  srcs = [
    (fetchzip {
      name = "Nupuram-Arrows-Color";
      url = "https://smc.org.in/downloads/fonts/nupuram/Nupuram-Arrows-Color.zip";
      hash = "sha256-tqDnDCvqE7TF0Yp4wdBfQRJKDfixftCzaXdOLQL9NLQ=";
      stripRoot = false;
    })
    (fetchzip {
      name = "Nupuram-Calligraphy";
      url = "https://smc.org.in/downloads/fonts/nupuram/Nupuram-Calligraphy.zip";
      hash = "sha256-Cc4A4qvbAUC2+e7HmMdRJtk8lR60UU4qcXbQIPhNCR0=";
      stripRoot = false;
    })
    (fetchzip {
      name = "Nupuram-Color";
      url = "https://smc.org.in/downloads/fonts/nupuram/Nupuram-Color.zip";
      hash = "sha256-vH+HQ38jgYVJ5c6jp7jXPjNNIjRFJ0MDGs62+rdUd5U=";
      stripRoot = false;
    })
    (fetchzip {
      name = "Nupuram-Dots";
      url = "https://smc.org.in/downloads/fonts/nupuram/Nupuram-Dots.zip";
      hash = "sha256-nlBAJUJru9q0F+nXJowAhCssN2DnunPei0ZhED2A2qA=";
      stripRoot = false;
    })
  ];

  sourceRoot = ".";
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    find . -name "*.otf" -exec install -Dm644 {} -t "$out/share/fonts/opentype" \;
    find . -name "*.ttf" -exec install -Dm644 {} -t "$out/share/fonts/truetype" \;

    runHook postInstall
  '';

  meta = {
    description = "Nupuram is a Malayalam variable typeface inspired by the early Malayalam movie title designs of the 1960s–70s, particularly the work of title designer S. Appukkuttan Nair. This is a superfamily of related typefaces. Designed by Santhosh Thottingal. Maintained by SMC";
    homepage = "https://smc.org.in/fonts/nupuram";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ aashiks ];
  };
})
