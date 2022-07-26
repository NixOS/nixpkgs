{ lib, runCommand
, libreoffice, dbus, bash, substituteAll
, dolphinTemplates ? true
}:
runCommand libreoffice.name {
  inherit (libreoffice) jdk meta;
  inherit dbus libreoffice bash;
} (''
  mkdir -p "$out/bin"
  substituteAll "${./wrapper.sh}" "$out/bin/soffice"
  chmod a+x "$out/bin/soffice"

  for i in $(ls "${libreoffice}/bin/"); do
    test "$i" = "soffice" || ln -s soffice "$out/bin/$(basename "$i")"
  done

  mkdir -p "$out/share"
  ln -s "${libreoffice}/share"/* $out/share
'' + lib.optionalString dolphinTemplates ''
  # Add templates to dolphin "Create new" menu - taken from debian

  # We need to unpack the core source since the necessary files aren't available in the libreoffice output
  unpackFile "${libreoffice.src}"

  install -D "${libreoffice.name}"/extras/source/shellnew/soffice.* --target-directory="$out/share/templates/.source"

  cp ${substituteAll {src = ./soffice-template.desktop; app="Writer";  ext="odt"; type="text";        }} $out/share/templates/soffice.odt.desktop
  cp ${substituteAll {src = ./soffice-template.desktop; app="Calc";    ext="ods"; type="spreadsheet"; }} $out/share/templates/soffice.ods.desktop
  cp ${substituteAll {src = ./soffice-template.desktop; app="Impress"; ext="odp"; type="presentation";}} $out/share/templates/soffice.odp.desktop
  cp ${substituteAll {src = ./soffice-template.desktop; app="Draw";    ext="odg"; type="drawing";     }} $out/share/templates/soffice.odg.desktop
'')

