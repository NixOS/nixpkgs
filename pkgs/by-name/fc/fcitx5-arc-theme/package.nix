{
    stdenvNoCC,
    fetchFromGitHub,
    lib,
}:

stdenvNoCC.mkDerivation {
    pname = "fcitx5-arc-theme";
    version = "0-unstable-2025-11-07";

    src = fetchFromGitHub {
        owner = "Kienyew";
        repo = "fcitx5-arc-theme";
        rev = "78a54e89a8d3717ab149976c26d6b4b2fde13f11";
        hash = "sha256-Fb5nP099D/hvw+WrJ2VxvwiNqaG4SzrLNhsPUe1j/6Q=";
    };

    installPhase = ''
        runHook preInstall
        mkdir -pv $out/share/fcitx5/themes/
        cp -rv Arc* $out/share/fcitx5/themes
        runHook postInstall
    '';

    meta = with lib; {
        description = "Fcitx5 theme based on Arc theme";
        homepage = "https://github.com/Kienyew/fcitx5-arc-theme";
        license = licenses.mit;
        maintainers = with maintainers; [ Che-0129 ];
        platforms = platforms.all;
    };
}
