{
  lib,
  stdenvNoCC,
  fetchFromGitLab,
  python3Packages,
  installFonts,
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
    installFonts
  ];

  buildFlags = [ "otf" ] ++ lib.optional truetype "ttf";

  makeFlags = [ "INSTALLPATH=." ];

  postInstall = ''
    install -Dm644 -t $out/etc/fonts/conf.d *.conf
    install -Dm644 -t $out/share/doc/${pname}-${version} OFL.txt FONTLOG.md
  '';

  meta = {
    homepage = "https://smc.org.in/fonts/manjari";
    description = "Manjari Malayalam Typeface";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
