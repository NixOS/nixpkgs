{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
  python3Packages,
  gnumake,
  truetype ? false,
}:

stdenvNoCC.mkDerivation rec {
  pname = "smc-manjari";
  version = "2.200";

  src = fetchFromGitLab {
    group = "smc";
    owner = "fonts";
    repo = "manjari";
    rev = "Version${version}";
    hash = "sha256-B3EI6rrZyhc3xJuVIDVIjLrjJmFoFzHIwVV/4EBQv1s=";
  };

  nativeBuildInputs = [
    gnumake
    python3Packages.fontmake
  ];

  buildFlags = [ "otf" ] ++ lib.optional truetype "ttf";

  installPhase = ''
    runHook preInstall

    install -Dm444 -t $out/share/fonts/opentype build/*.otf
    ${lib.optionalString truetype "install -Dm444 -t $out/share/fonts/truetype build/*.ttf"}

    install -Dm644 -t $out/etc/fonts/conf.d *.conf

    install -Dm644 -t $out/share/doc/${pname}-${version} OFL.txt FONTLOG.md

    runHook postInstall
  '';

  meta = {
    homepage = "https://smc.org.in/fonts/manjari";
    description = "Manjari Malayalam Typeface";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ adtya ];
  };
}
