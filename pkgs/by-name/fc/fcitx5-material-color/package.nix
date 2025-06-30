{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "fcitx5-material-color";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "hosxy";
    repo = "Fcitx5-Material-Color";
    rev = finalAttrs.version;
    hash = "sha256-i9JHIJ+cHLTBZUNzj9Ujl3LIdkCllTWpO1Ta4OT1LTc=";
  };

  installPhase = ''
    runHook preInstall

    # https://gitlab.archlinux.org/archlinux/packaging/packages/fcitx5-material-color/-/blob/main/PKGBUILD?ref_type=heads#L16
    install -Dm644 arrow.png radio.png -t $out/share/fcitx5-material-color/
    for _variant in black blue brown deepPurple indigo orange pink red sakuraPink teal; do
      _variant_name=Material-Color-$_variant
      install -dm755 $_variant_name $out/share/fcitx5/themes/$_variant_name
      ln -sv ../../../$pname/arrow.png $out/share/fcitx5/themes/$_variant_name/
      ln -sv ../../../$pname/radio.png $out/share/fcitx5/themes/$_variant_name/
      install -Dm644 theme-$_variant.conf $out/share/fcitx5/themes/$_variant_name/theme.conf
      sed -i "s/^Name=.*/Name=$_variant_name/" $out/share/fcitx5/themes/$_variant_name/theme.conf
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "Fcitx5 themes based on Material color";
    homepage = "https://github.com/hosxy/Fcitx5-Material-Color";
    license = licenses.asl20;
    maintainers = with maintainers; [
      Cryolitia
      h7x4
    ];
    platforms = platforms.all;
  };
})
