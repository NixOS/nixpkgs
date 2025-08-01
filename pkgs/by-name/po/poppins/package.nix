{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unzip,
}:
stdenvNoCC.mkDerivation rec {
  pname = "poppins";
  version = "4.003";

  src = fetchFromGitHub {
    owner = "itfoundry";
    repo = "poppins";
    rev = "v${version}";
    hash = "sha256-7+RQHYxNFqOw2EeS2hgrbK/VbUAiPorUtkyRb5MFh5w=";
  };

  nativeBuildInputs = [ unzip ];

  installPhase = ''
    runHook preInstall
    unzip products/Poppins-4.003-GoogleFonts-TTF.zip
    unzip products/PoppinsLatin-5.001-Latin-TTF.zip
    install -Dm644 *.ttf -t $out/share/fonts/truetype
    runHook postInstall
  '';

  meta = {
    description = "Devanagari + Latin family for Google Fonts";
    homepage = "https://github.com/itfoundry/Poppins/";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ nyawox ];
    platforms = lib.platforms.all;
  };
}
