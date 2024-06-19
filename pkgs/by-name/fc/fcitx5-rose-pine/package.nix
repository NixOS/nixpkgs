{ stdenvNoCC
, fetchFromGitHub
, lib
}:

stdenvNoCC.mkDerivation {
  pname = "fcitx5-rose-pine";
  version = "0-unstable-2024-03-01";

  src = fetchFromGitHub {
    owner = "rose-pine";
    repo = "fcitx5";
    rev = "148de09929c2e2f948376bb23bc25d72006403bc";
    hash = "sha256-SpQ5ylHSDF5KCwKttAlXgrte3GA1cCCy/0OKNT1a3D8=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -pv $out/share/fcitx5/themes/
    cp -rv rose-pine* $out/share/fcitx5/themes/

    runHook postInstall
  '';


  meta = {
    description = "Fcitx5 themes based on Rosé Pine";
    homepage = "https://github.com/rose-pine/fcitx5";
    maintainers = with lib.maintainers; [ rosehobgoblin ];
    platforms = lib.platforms.all;
    license = lib.licenses.unfree;
  };
}
