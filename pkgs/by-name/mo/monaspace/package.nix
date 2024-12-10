{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "monaspace";
  version = "1.101";

  src = fetchzip {
    url = "https://github.com/githubnext/monaspace/releases/download/v${finalAttrs.version}/monaspace-v${finalAttrs.version}.zip";
    stripRoot = false;
    hash = "sha256-o5s4XBuwqA4sJ5KhEn5oYttBj4ojekr/LO6Ww9oQRGw=";
  };

  outputs = [
    "out"
    "woff"
  ];

  installPhase = ''
    runHook preInstall

    pushd monaspace-v${finalAttrs.version}/fonts/
    install -Dm644 otf/*.otf -t $out/share/fonts/opentype
    install -Dm644 variable/*.ttf -t $out/share/fonts/truetype
    install -Dm644 webfonts/*.woff -t $woff/share/fonts/woff
    popd

    runHook postInstall
  '';

  meta = {
    description = "An innovative superfamily of fonts for code";
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
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.all;
  };
})
