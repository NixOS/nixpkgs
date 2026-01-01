{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "ananicy-rules-cachyos";
<<<<<<< HEAD
  version = "0-unstable-2025-12-25";
=======
  version = "0-unstable-2025-11-23";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "CachyOS";
    repo = "ananicy-rules";
<<<<<<< HEAD
    rev = "410a04d9af9ac9b6bfefa06cf53ae9b91f1294bd";
    hash = "sha256-vEwpJ5AQS4Xwdyvm6/jOtG3V32C50qr3W8hkEbq/IJk=";
=======
    rev = "f40a84ed2a104e46fc48ed9820f91b0542328732";
    hash = "sha256-yU4rKkynKILsEgxJbNGAXIzp5U8J4WILQzJ3WJ2Q2dg=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/etc/ananicy.d
    rm README.md LICENSE
    cp -r * $out/etc/ananicy.d
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = {
    homepage = "https://github.com/CachyOS/ananicy-rules";
    description = "CachyOS' ananicy-rules meant to be used with ananicy-cpp";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      artturin
      johnrtitor
    ];
  };
}
