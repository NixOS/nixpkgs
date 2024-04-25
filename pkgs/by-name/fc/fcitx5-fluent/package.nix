{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation {
  pname = "fcitx5-fluent";
  version = "0.4.0-unstable-2024-03-30";

  src = fetchFromGitHub {
    owner = "Reverier-Xu";
    repo = "Fluent-fcitx5";
    rev = "dc98bc13e8eadabed7530a68706f0a2a0a07340e";
    hash = "sha256-d1Y0MUOofBxwyeoXxUzQHrngL1qnL3TMa5DhDki7Pk8=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/common

    function identical() {
        res=$(diff $1 $2 || echo "different")
        echo $([[ $res -ne "different" ]])
    }

    cp -r FluentDark/{arrow.png,back.png,radio.png} $out/common

    if [[ $(identical FluentDark/arrow.png FluentDark/next.png) -eq 0 ]]; then
        ln -s $out/common/arrow.png $out/common/next.png
    else
        cp -r FluentDark/next.png $out/share/fcitx5/themes/common
    fi

    for variant in FluentDark FluentDark-solid FluentLight FluentLight-solid ; do
        mkdir -p $out/share/fcitx5/themes/$variant
        cp -r $variant/{theme.conf,panel.png} $out/share/fcitx5/themes/$variant

        for asset in arrow.png next.png back.png radio.png ; do
            if [[ $(identical $variant/$asset $out/common/$asset) -eq 0 ]]; then
                ln -s $out/common/$asset $out/share/fcitx5/themes/$variant/$asset
            else
                cp -r $variant/$asset $out/share/fcitx5/themes/$variant/$asset
            fi
        done
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "A fluent-design theme with blur effect and shadow";
    homepage = "https://github.com/Reverier-Xu/Fluent-fcitx5";
    license = licenses.mpl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ oo-infty ];
  };
}
