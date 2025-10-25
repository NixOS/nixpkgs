{
  lib,
  stdenvNoCC,
  fetchzip,
}:
let
  fonts = lib.importTOML ./fonts.toml;
  inherit (fonts) baseUrl;

  meta = {
    description = "Innovative superfamily of fonts for code";
    longDescription = ''
      Since the earliest days of the teletype machine, code has been set in
      monospaced type — letters, on a grid. Monaspace is a new type system that
      advances the state of the art for the display of code on screen.

      Every advancement in the technology of computing has been accompanied by
      advancements to the display and editing of code. CRTs made screen editors
      possible. The advent of graphical user interfaces gave rise to integrated
      development environments.

      Even today, we still have limited options when we want to layer additional
      meaning on top of code. Syntax highlighting was invented in 1982 to help
      children to code in BASIC. But beyond colors, most editors must
      communicate with developers through their interfaces — hovers, underlines,
      and other graphical decorations.

      Monaspace offers a more expressive palette for code and the tools we use
      to work with it.
    '';
    homepage = "https://monaspace.githubnext.com/";
    license = lib.licenses.ofl;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
  makeFont =
    font:
    stdenvNoCC.mkDerivation {
      inherit (font) pname;
      inherit (fonts) version;
      src = fetchzip {
        url = "${baseUrl}/v${fonts.version}/${font.pname}-v${fonts.version}.zip";
        stripRoot = false;
        inherit (font) hash;
      };

      installPhase = ''
        runHook preInstall

        # The result of unzipping the file is a folder containing a folder containing the font file/-s
        install -Dm644 **/**/*.* -t $out/share/fonts/${font.destination}

        runHook postInstall
      '';
      inherit meta;
    };
  makePackages = lib.pipe fonts.fonts [
    (builtins.map (font: {
      inherit (font) name;
      value = makeFont font;
    }))
    lib.listToAttrs
  ];
in
makePackages.static.overrideAttrs (old: {
  passthru = makePackages;
})
