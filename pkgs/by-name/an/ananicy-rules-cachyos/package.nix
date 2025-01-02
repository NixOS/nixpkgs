{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "ananicy-rules-cachyos";
  version = "0-unstable-2024-12-27";

  src = fetchFromGitHub {
    owner = "CachyOS";
    repo = "ananicy-rules";
    rev = "8e8452c210f005e409f6b1eddbb2907e8db0a6d3";
    hash = "sha256-73MltJrKlTvj+ijjhbNQsxGl05KGx+jioSrFGA6IdxE=";
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
