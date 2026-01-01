{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "circle-flags";
<<<<<<< HEAD
  version = "2.8.0";
=======
  version = "2.7.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "HatScripts";
    repo = "circle-flags";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-Wa59G8ov/S89BABtpey/ueplztiYIUXrSDg72wG74jQ=";
=======
    hash = "sha256-/+f5MDRW+tRH+jMtl3XuVPBShgy2PlD3NY+74mJa2Qk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share
    mv flags $out/share/circle-flags-svg

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/HatScripts/circle-flags";
    description = "Collection of 400+ minimal circular SVG country and state flags";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bobby285271 ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    homepage = "https://github.com/HatScripts/circle-flags";
    description = "Collection of 400+ minimal circular SVG country and state flags";
    license = licenses.mit;
    maintainers = with maintainers; [ bobby285271 ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
