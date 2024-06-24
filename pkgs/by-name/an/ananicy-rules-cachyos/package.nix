{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "ananicy-rules-cachyos";
  version = "0-unstable-2024-06-19";

  src = fetchFromGitHub {
    owner = "CachyOS";
    repo = "ananicy-rules";
    rev = "167915d1c6e4f46932a9857b1a4aeb3e813a8538";
    hash = "sha256-hIrjc80DuuENLbD5MxAku6aY05kdfXWLPSCSssadmr8=";
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
      diniamo
      johnrtitor
    ];
  };
}
