{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "qwerty-fr";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "qwerty-fr";
    repo = "qwerty-fr";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TD67wKdaPaXzJzjKFCfRZl3WflUfdnUSQl/fnjr9TF8=";
  };

  installPhase = ''
    mkdir -p $out/share/X11/xkb/symbols
    cp $src/linux/us_qwerty-fr $out/share/X11/xkb/symbols
  '';

  meta = with lib; {
    description = "Qwerty keyboard layout with French accents";
    changelog = "https://github.com/qwerty-fr/qwerty-fr/blob/v${finalAttrs.version}/linux/debian/changelog";
    homepage = "https://github.com/qwerty-fr/qwerty-fr";
    license = licenses.mit;
    maintainers = with maintainers; [ potb ];
  };
})
