{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation {
  pname = "babelstone-han";
  version = "13.0.3";

  src = fetchzip {
    # upstream download links are unversioned, so hash changes
    url = "https://web.archive.org/web/20200210125314/https://www.babelstone.co.uk/Fonts/Download/BabelStoneHan.zip";
    hash = "sha256-LLhNtHu2hh5DY2XVSrLuVzzR6OtMdSSHetyA0k1IFs0=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "Unicode CJK font with over 36000 Han characters";
    homepage = "https://www.babelstone.co.uk/Fonts/Han.html";

    license = licenses.arphicpl;
    platforms = platforms.all;
    maintainers = with maintainers; [ emily ];
  };
}
