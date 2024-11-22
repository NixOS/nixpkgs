{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation rec {
  pname = "lora";
  version = "v3.005";

  src = fetchFromGitHub {
    owner = "cyrealtype";
    repo = "lora";
    rev = version;
    hash = "sha256-EHa8DUPFRvdYBdCY41gfjKGtTHwGIXCwD9Qc+Npmt1s=";
  };

  dontConfigure = true;
  dontBuild = true;

  passthru.updateScript = nix-update-script { };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
    cp -R $src/fonts/ttf/*.ttf $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "Lora is a well-balanced contemporary serif with roots in calligraphy";
    homepage = "https://github.com/cyrealtype/lora";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ ofalvai ];
  };
}
