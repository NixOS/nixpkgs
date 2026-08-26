{
  lib,
  ags,
  astal,
  dart-sass,
  fzf,
  gjs,
  gnused,
  gobject-introspection,
  gtk3,
  gtk4-layer-shell,
  stdenvNoCC,
  wrapGAppsHook3,
  wrapGAppsHook4,
}:
{
  entry ? "app.ts",
  dependencies ? [ ],
  enableGtk4 ? false,
  ...
}@attrs:
stdenvNoCC.mkDerivation (
  finalAttrs:
  attrs
  // {
    nativeBuildInputs = (attrs.nativeBuildInputs or [ ]) ++ [
      (ags.override { extraPackages = dependencies; })
      gnused
      gobject-introspection
      (if enableGtk4 then wrapGAppsHook4 else wrapGAppsHook3)
    ];

    buildInputs =
      (attrs.buildInputs or [ ])
      ++ dependencies
      ++ [
        gjs
        astal.astal4
        astal.astal3
        astal.io
      ];

    preFixup = ''
      gappsWrapperArgs+=(
        --prefix PATH : ${
          lib.makeBinPath (
            dependencies
            ++ [
              dart-sass
              fzf
              gtk3
            ]
          )
        }
      )
    ''
    + lib.optionalString enableGtk4 ''
      gappsWrapperArgs+=(
        --set LD_PRELOAD "${gtk4-layer-shell}/lib/libgtk4-layer-shell.so"
      )
    ''
    + (attrs.preFixup or "");

    installPhase =
      let
        outBin = "$out/bin/${finalAttrs.pname}";
      in
      # bash
      ''
        runHook preInstall

        mkdir -p "$out/bin" "$out/share"
        cp -r ./* "$out/share"
        ags bundle "${entry}" "${outBin}" -d "SRC='$out/share'"

        chmod +x "${outBin}"

        if ! head -n 1 "${outBin}" | grep -q "^#!"; then
          sed -i '1i #!${gjs}/bin/gjs -m' "${outBin}"
        fi

        runHook postInstall
      '';
  }
)
