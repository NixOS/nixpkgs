{ lib, stdenvNoCC }:

lib.extendMkDerivation {
  constructDrv = stdenvNoCC.mkDerivation;
  excludeDrvArgNames = [
    "installWebfonts"
    "noUnpackFonts"
  ];
  extendDrvArgs =
    finalAttrs:
    {
      noUnpackFonts ? false,
      installWebfonts ? false,
      ...
    }@args:
    {
      strictDeps = true;
      __structuredAttrs = true;

      sourceRoot = args.sourceRoot or lib.optionalString (noUnpackFonts || lib.hasAttr "srcs" args) ".";

      unpackCmd = args.unpackCmd or lib.optionalString noUnpackFonts ''
        filename="$(basename "$(stripHash "$curSrc")")"
        cp "$curSrc" "./$filename"
      '';

      outputs = args.outputs or [ "out" ] ++ lib.optionals installWebfonts [ "webfont" ];

      installPhase =
        args.installPhase or ''
          runHook preInstall

          # these come up in some source trees, but are never useful to us
          find -iname __MACOSX -type d -print0 | xargs -0 rm -rf

          find -iname '*.ttf' -print0 | xargs -0 -r install -m644 -D -t $out/share/fonts/truetype
          find -iname '*.ttc' -print0 | xargs -0 -r install -m644 -D -t $out/share/fonts/truetype
          find -iname '*.otf' -print0 | xargs -0 -r install -m644 -D -t $out/share/fonts/opentype
          find -iname '*.svg' -print0 | xargs -0 -r install -m644 -D -t $out/share/fonts/svg
          find -iname '*.bdf' -print0 | xargs -0 -r install -m644 -D -t $out/share/fonts/misc
          find -iname '*.otb' -print0 | xargs -0 -r install -m644 -D -t $out/share/fonts/misc
          find -iname '*.psf' -print0 | xargs -0 -r install -m644 -D -t $out/share/consolefonts

          ${lib.optionalString installWebfonts ''
            find -iname '*.woff' -print0 | xargs -0 -r install -m644 -D -t $webfont/share/fonts/woff
            find -iname '*.woff2' -print0 | xargs -0 -r install -m644 -D -t $webfont/share/fonts/woff2
          ''}

          runHook postInstall
        '';
    };
}
