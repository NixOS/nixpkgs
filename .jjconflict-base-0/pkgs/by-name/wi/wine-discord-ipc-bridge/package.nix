{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wine-discord-ipc-bridge";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "0e4ef622";
    repo = "wine-discord-ipc-bridge";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-jzsbOKMakNQ6RNMlioX088fGzFBDxOP45Atlsfm2RKg=";
  };

  postPatch = ''
    patchShebangs winediscordipcbridge-steam.sh
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp winediscordipcbridge.exe $out/bin
    cp winediscordipcbridge-steam.sh $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    description = "Enable games running under wine to use Discord Rich Presence";
    homepage = "https://github.com/0e4ef622/wine-discord-ipc-bridge";
    license = licenses.mit;
    maintainers = [ maintainers.uku3lig ];
    mainProgram = "winediscordipcbridge";
    platforms = [ "i686-windows" ];
  };
})
