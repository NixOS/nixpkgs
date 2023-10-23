{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation rec {
  pname = "fcitx5-material-color";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "hosxy";
    repo = "fcitx5-material-color";
    rev = version;
    hash = "sha256-i9JHIJ+cHLTBZUNzj9Ujl3LIdkCllTWpO1Ta4OT1LTc=";
  };

  installPhase = ''
    runHook preInstall

    find . -type f -name 'theme-*.conf' -exec install -m444 -Dt $out/share/fcitx5/themes/Material-Color/ {} \;
    find . -type f -name '*.png' -exec install -m444 -Dt $out/share/fcitx5/themes/Material-Color/ {} \;

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Fcitx5 theme using material colors";
    homepage = "https://github.com/hosxy/fcitx5-material-color";
    license = licenses.asl20;
    maintainers = with maintainers; [ h7x4 ];
    platforms = platforms.all;
  };
}
