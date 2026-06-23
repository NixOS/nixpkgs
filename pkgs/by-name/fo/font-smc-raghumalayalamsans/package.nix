{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "font-smc-raghumalayalamsans";
  version = "20241013";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchzip {
    url = "https://smc.org.in/downloads/fonts/raghumalayalamsans/raghumalayalamsans.zip";
    hash = "sha256-rSM77MiFqRzs67mme8xkJZkw13esB9eG13j8OzytCaA=";
    stripRoot = false;
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    find . -name "*.otf" -exec install -Dm644 {} -t "$out/share/fonts/opentype" \;
    find . -name "*.ttf" -exec install -Dm644 {} -t "$out/share/fonts/truetype" \;

    runHook postInstall
  '';

  meta = {
    description = "A collaborative effort of Hussain K H, Prof. R. K. Joshi (TypeFont Design Director), Mr. Rajith Kumar K. M. (TypeFont Designer), assisted by Mr. Nirmal Biswas, Ms. Jui Mhatre and Ms. Supriya Kharkar at C-DAC Mumbai. This is the last version maintained by SMC";
    homepage = "https://smc.org.in/fonts/raghumalayalamsans";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ aashiks ];
  };
})
