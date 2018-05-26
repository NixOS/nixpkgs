{ libreoffice, runCommand, dbus, bash }:
let
  jdk = libreoffice.jdk;
in
(runCommand "${libreoffice.name}" {
  inherit dbus libreoffice jdk bash;
} ''
  mkdir -p "$out/bin"
  ln -s "${libreoffice}/share" "$out/share"
  substituteAll "${./wrapper.sh}" "$out/bin/soffice"
  chmod a+x "$out/bin/soffice"

  for i in $(ls "${libreoffice}/bin/"); do
    test "$i" = "soffice" || ln -s soffice "$out/bin/$(basename "$i")"
  done
'') // { inherit libreoffice dbus; }
