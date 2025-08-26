{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "monaspace";
  version = "1.301";

  src = fetchFromGitHub {
    owner = "githubnext";
    repo = "monaspace";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8tPwm92ZtaXL9qeDL+ay9PdXLUBBsspdk7/0U8VO0Tg=";
  };

  outputs = [
    "out"
    "woff"
  ];

  installPhase = ''
    runHook preInstall

    pushd fonts

    find "Frozen Fonts" -type f -name '*.ttf' \
      -exec install -Dm644 {} -t $out/share/fonts/truetype \;
    find "Static Fonts" -type f -name '*.otf' \
      -exec install -Dm644 {} -t $out/share/fonts/opentype \;
    find "Variable Fonts" -type f -name '*.ttf' \
      -exec install -Dm644 {} -t $out/share/fonts/truetype \;

    pushd "Web Fonts"

    find "Static Web Fonts" -type f -name '*.woff' \
      -exec install -Dm644 {} -t $woff/share/fonts/woff \;
    find "Variable Web Fonts" -type f -name '*.woff' \
      -exec install -Dm644 {} -t $woff/share/fonts/woff \;

    popd
    popd

    runHook postInstall
  '';

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
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.all;
  };
})
