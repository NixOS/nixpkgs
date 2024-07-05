{ lib
, stdenvNoCC
, fetchFromGitHub
, sunwait
, wallutils
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sunpaper";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "hexive";
    repo = "sunpaper";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8s7SS79wCS0nRR7IpkshP5QWJqqKEeBu6EtFPDM+2cM=";
  };

  buildInputs = [
    sunwait
    wallutils
  ];

  postPatch = ''
    substituteInPlace sunpaper.sh \
      --replace "sunwait" "${lib.getExe sunwait}" \
      --replace "setwallpaper" "${lib.getExe' wallutils "setwallpaper"}" \
      --replace '$HOME/sunpaper/images/' "$out/share/sunpaper/images/"
  '';

  installPhase = ''
    runHook preInstall

    install -Dm555 sunpaper.sh $out/bin/sunpaper
    mkdir -p "$out/share/sunpaper/images"
    cp -R images $out/share/sunpaper/

    runHook postInstall
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    $out/bin/sunpaper --help > /dev/null
  '';

  meta = {
    description = "Utility to change wallpaper based on local weather, sunrise and sunset times";
    homepage = "https://github.com/hexive/sunpaper";
    license = lib.licenses.asl20;
    mainProgram = "sunpaper";
    maintainers = with lib.maintainers; [ eclairevoyant jevy ];
    platforms = lib.platforms.linux;
  };
})
