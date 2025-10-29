{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "ia-writer-quattro";
  version = "0-unstable-2023-06-16";

  src = fetchFromGitHub {
    owner = "iaolo";
    rev = "f32c04c3058a75d7ce28919ce70fe8800817491b";
    repo = "iA-fonts";
    hash = "sha256-2T165nFfCzO65/PIHauJA//S+zug5nUwPcg8NUEydfc=";
  };

  dontConfigure = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp -R $src/iA\ Writer\ Quattro/Static/*.ttf $out/share/fonts/truetype
    cp -R $src/iA\ Writer\ Quattro/Variable/*.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "iA Writer Quattro Typeface";
    homepage = "https://github.com/iaolo/iA-Fonts";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.x0ba ];
  };
}
