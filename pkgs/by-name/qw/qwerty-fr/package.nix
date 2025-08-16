{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
  writeText,
}:

let
  # for issue: https://github.com/qwerty-fr/qwerty-fr/issues/49
  rules_lst = writeText "evdev.lst" ''
    ! layout
      us_qwerty-fr	English (US, qwerty-fr)
  '';

  rules_xml = writeText "evdev.xml" ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE xkbConfigRegistry SYSTEM "xkb.dtd">
    <xkbConfigRegistry version="1.1">
      <layoutList>
        <layout>
          <configItem>
            <name>us_qwerty-fr</name>
            <shortDescription>qwerty-fr</shortDescription>
            <description>English (US, qwerty-fr)</description>
          </configItem>
        </layout>
      </layoutList>
    </xkbConfigRegistry>
  '';
in
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
    runHook preInstall

    mkdir -p $out/share/X11/xkb/symbols
    cp $src/linux/us_qwerty-fr $out/share/X11/xkb/symbols

    mkdir -p $out/share/X11/xkb/rules
    cp ${rules_lst} $out/share/X11/xkb/rules/evdev.lst
    cp ${rules_xml} $out/share/X11/xkb/rules/evdev.xml
    ln -sr $out/share/X11/xkb/rules/{evdev,base}.lst
    ln -sr $out/share/X11/xkb/rules/{evdev,base}.xml

    runHook postInstall
  '';

  meta = with lib; {
    description = "Qwerty keyboard layout with French accents";
    changelog = "https://github.com/qwerty-fr/qwerty-fr/blob/v${finalAttrs.version}/linux/debian/changelog";
    homepage = "https://github.com/qwerty-fr/qwerty-fr";
    license = licenses.mit;
    maintainers = with maintainers; [ potb ];
  };
})
