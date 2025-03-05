{ lib, stdenvNoCC, fetchFromGitLab, python3Packages, gnumake, truetype ? false }:

stdenvNoCC.mkDerivation rec {
  pname = "chilanka";
  version = "1.7";

  src = fetchFromGitLab {
    group = "smc";
    owner = "fonts";
    repo = "chilanka";
    rev = "Version${version}";
    hash = "sha256-VvotRUQks8vUqJOcYHqy6cuwaAKYg4OqtiAjaBIdBRk=";
  };

  nativeBuildInputs = [ gnumake python3Packages.fontmake ];

  buildFlags = [ "otf" ] ++ lib.optional truetype "ttf";

  installPhase = ''
    runHook preInstall

    install -Dm444 -t $out/share/fonts/opentype build/*.otf
    ${lib.optionalString truetype "install -Dm444 -t $out/share/fonts/truetype build/*.ttf"}

    install -Dm444 -t $out/etc/fonts/conf.d *.conf

    install -Dm644 -t $out/share/doc/${pname}-${version} OFL.txt FONTLOG.md

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://smc.org.in/fonts/chilanka";
    description = "Chilanka Malayalam Typeface";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ adtya ];
  };
}
