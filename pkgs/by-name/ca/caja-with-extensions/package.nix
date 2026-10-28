{
  stdenv,
  lib,
  glib,
  wrapGAppsHook3,
  lndir,
  atril,
  caja,
  caja-extensions,
  engrampa,
  extensions ? [ ],
  useDefaultExtensions ? true,
}:

let
  selectedExtensions =
    extensions
    ++ (lib.optionals useDefaultExtensions [
      atril
      caja-extensions
      engrampa
    ]);
in
stdenv.mkDerivation {
  pname = "${caja.pname}-with-extensions";
  inherit (caja) version outputs;

  src = null;

  nativeBuildInputs = [
    glib
    wrapGAppsHook3
    lndir
  ];

  buildInputs =
    lib.concatMap (x: x.buildInputs) selectedExtensions
    ++ selectedExtensions
    ++ [ caja ]
    ++ caja.buildInputs;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  preferLocalBuild = true;
  allowSubstitutes = false;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    lndir -silent ${caja.out} $out
    lndir -silent ${caja.man} $out

    dbus_service_path="share/dbus-1/services/org.mate.freedesktop.FileManager1.service"
    rm -f $out/share/applications/* "$out/$dbus_service_path"
    for file in ${caja}/share/applications/*; do
      substitute "$file" "$out/share/applications/$(basename $file)" \
        --replace-fail "${caja}" "$out"
    done
    substitute "${caja}/$dbus_service_path" "$out/$dbus_service_path" \
      --replace-fail "${caja}" "$out"

    runHook postInstall
  '';

  preFixup = lib.optionalString (selectedExtensions != [ ]) ''
    gappsWrapperArgs+=(
      --set CAJA_EXTENSION_DIRS ${
        lib.concatMapStringsSep ":" (x: "${x.outPath}/lib/caja/extensions-2.0") selectedExtensions
      }
    )
  '';

  inherit (caja) meta;
}
