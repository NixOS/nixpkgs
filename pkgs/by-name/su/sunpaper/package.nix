{ lib
, stdenvNoCC
, fetchFromGitHub
, sunwait
, wallutils
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sunpaper";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "hexive";
    repo = "sunpaper";
    rev = "v${finalAttrs.version}";
    hash = "sha256-koCK0ntzRf8OXoUj5DJdPWsFDD8EAMjnGdM1B5oeBBc=";
  };

  buildInputs = [
    sunwait
    wallutils
  ];

  postPatch = ''
    substituteInPlace sunpaper.sh \
      --replace-fail "sunwait" "${lib.getExe sunwait}" \
      --replace-fail "setwallpaper" "${lib.getExe' wallutils "setwallpaper"}" \
      --replace-fail '$HOME/sunpaper/images/' "$out/share/sunpaper/images/" \
      --replace-fail '/usr/share' '/etc'
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
    maintainers = with lib.maintainers; [ jevy ];
    platforms = lib.platforms.linux;
  };
})
