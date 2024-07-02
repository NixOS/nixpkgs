{
  lib,
  makeWrapper,
  symlinkJoin,
  nautilus,
  nautilusExtensions,
}:

symlinkJoin {
  name = "nautilus-with-extensions-${nautilus.version}";

  paths = [ nautilus ] ++ nautilusExtensions;

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram "$out/bin/nautilus" \
      --set "NAUTILUS_4_EXTENSION_DIR" "$out/lib/nautilus/extensions-4"

    # Point to wrapped binary in all service files
    for file in \
      "share/dbus-1/services/org.freedesktop.FileManager1.service" \
      "share/dbus-1/services/org.gnome.Nautilus.service"
    do
      rm -f "$out/$file"
      substitute "${nautilus}/$file" "$out/$file" \
        --replace-fail "${nautilus}" "$out"
    done
  '';

  meta = nautilus.meta // {
    description =
      nautilus.meta.description
      +
        lib.optionalString (nautilusExtensions != [])
          " (with extensions: ${lib.concatStringsSep ", " (map (x: x.pname) nautilusExtensions)})";
  };
}
