{ stdenvNoCC
, fetchFromGitHub
, lib
}:

stdenvNoCC.mkDerivation {
  pname = "fcitx5-nord";
  version = "unstable-2021-07-27";

  src = fetchFromGitHub {
    owner = "tonyfettes";
    repo = "fcitx5-nord";
    rev = "bdaa8fb723b8d0b22f237c9a60195c5f9c9d74d1";
    hash = "sha256-qVo/0ivZ5gfUP17G29CAW0MrRFUO0KN1ADl1I/rvchE=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -pv $out/share/fcitx5/themes/
    cp -rv Nord* $out/share/fcitx5/themes/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Fcitx5 theme based on Nord color";
    homepage = "https://github.com/tonyfettes/fcitx5-nord";
    license = licenses.mit;
    maintainers = with maintainers; [ Cryolitia ];
    platforms = platforms.all;
  };
}
