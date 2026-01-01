{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
  udevCheckHook,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "nitrokey-udev-rules";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nitrokey-udev-rules";
    rev = "v${finalAttrs.version}";
    hash = "sha256-LKpd6O9suAc2+FFgpuyTClEgL/JiZiokH3DV8P3C7Aw=";
  };

  nativeBuildInputs = [
    python3
    udevCheckHook
  ];

  doInstallCheck = true;

  buildPhase = ''
    runHook preBuild

    make generate

    runHook postBuild
  '';

  installPhase = ''
    install -D 41-nitrokey.rules -t $out/etc/udev/rules.d
  '';

<<<<<<< HEAD
  meta = {
    description = "udev rules for Nitrokey devices";
    homepage = "https://github.com/Nitrokey/nitrokey-udev-rules";
    license = [ lib.licenses.cc0 ];
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "udev rules for Nitrokey devices";
    homepage = "https://github.com/Nitrokey/nitrokey-udev-rules";
    license = [ licenses.cc0 ];
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      frogamic
      robinkrahl
    ];
  };
})
