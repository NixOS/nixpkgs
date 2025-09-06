{
  xkeyboard_config,
  ed,
  fetchFromGitHub,
  lib,
}:
xkeyboard_config.overrideAttrs (old: {
  neolightSrc = fetchFromGitHub {
    owner = "mihi314";
    repo = "neolight";
    tag = "v1.4.0";
    hash = "sha256-m1beegjPPiyQpmiqp5NvCCjBvpebH79A0R7PNjc0Xd8=";
  };

  postInstall = ''
    cd $out/share/X11/xkb
    cp $neolightSrc/linux/neolight_symbols symbols/neolight
    cp $neolightSrc/linux/neolight_types types/neolight

    ${ed}/bin/ed -v rules/evdev.xml <<EOF
    /<layoutList>/
    a
    <!-- BEGIN neolight -->
        <layout>
          <configItem>
            <name>neolight</name>
            <shortDescription>de</shortDescription>
            <description>German (Neolight)</description>
            <countryList>
              <iso3166Id>DE</iso3166Id>
            </countryList>
            <languageList>
              <iso639Id>deu</iso639Id>
            </languageList>
          </configItem>
          <variantList>
            <variant>
              <configItem>
                <name>de_escape_keys</name>
                <description>German (Neolight + escape keys)</description>
              </configItem>
            </variant>
          </variantList>
        </layout>
    <!-- END neolight -->
    .
    /<optionList>/
    a
    <!-- BEGIN neolight -->
        <group allowMultipleSelection="false">
          <configItem>
            <name>neolight</name>
            <description>Neolight</description>
          </configItem>
          <option>
            <configItem>
              <name>neolight</name>
              <description>Add the neolight layers to the first layout</description>
            </configItem>
          </option>
          <option>
            <configItem>
              <name>neolight:escape_keys</name>
              <description>Add the neolight layers and additional escape keys to the first layout</description>
            </configItem>
          </option>
        </group>
    <!-- END neolight -->
    .
    w
    EOF

    ${ed}/bin/ed -v types/complete <<EOF
    /};/
    i
    include "neolight"
    .
    w
    EOF

    ${ed}/bin/ed -v rules/evdev <<EOF
    a
    // BEGIN NEOLIGHT
    ! option   = symbols
      neolight = +neolight(layers)
      neolight:escape_keys = +neolight(layers)+neolight(escape_keys)
      neolight:jp = +neolight(jp)
    // END NEOLIGHT
    .
    w
    EOF
  '';

  meta = {
    maintainers = with lib.maintainers; [ drafolin ];
    homepage = "https://github.com/mihi314/neolight";
    description = "Neolight is a fork of the XKB layout for programming based on Neo";
    license = lib.licenses.gpl3Plus;
  };
})
