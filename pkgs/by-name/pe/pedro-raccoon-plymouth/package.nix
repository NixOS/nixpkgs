{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "pedro-raccoon-plymouth";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "FilaCo";
    repo = "pedro-raccoon-plymouth";
    rev = "01ff1f44d5cac1a2fe961a67b70dd6af1cf7fa8a";
    hash = "sha256-L+jfH2edHN6kqqjpAesRr317ih3r4peGklRwvziksHE=";
  };

  postPatch = ''
    # Remove not needed files
    rm README.md LICENSE
  '';

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plymouth/themes/pedro-raccoon
    cp pedro-raccoon/* $out/share/plymouth/themes/pedro-raccoon
    substituteInPlace $out/share/plymouth/themes/pedro-raccoon/pedro-raccoon.plymouth \
      --replace-fail "/usr/" "$out/"
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Simple Pedro racoon meme Plymouth theme.";
    longDescription = ''
      Simple Pedro racoon meme Plymouth theme.
    '';
    homepage = "https://github.com/FilaCo/pedro-raccoon-plymouth";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ wrocket ];
  };
}
