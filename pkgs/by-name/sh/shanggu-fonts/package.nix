{
  lib,
  stdenvNoCC,
  fetchurl,
  p7zip,
}:
let
  version = "1.027";

  source =
    with lib.attrsets;
    mapAttrs'
      (
        name: hash:
        nameValuePair (lib.strings.toLower name) (fetchurl {
          url = "https://github.com/GuiWonder/Shanggu/releases/download/${version}/Shanggu${name}TTCs.7z";
          inherit hash;
        })
      )
      {
        Mono = "sha256-Q1vFGfnVbZgpuk/dHNGIhQ8eZTMOChGjG2x7H/a/z9c=";
        Round = "sha256-DtrXQsBPZM+LFZUBwlRni0oCTU30h+dF5pL1Bkb/y6A=";
        Sans = "sha256-3vDFtygo3lNznhI/WDEvvYi1mz19zGi0yq6DzrTSgFs=";
        Serif = "sha256-4xVMHgUXBjroehu01G3IP7gSlkjkx9SR7PwDwoVKWoo=";
      };

  extraOutputs = builtins.attrNames source;
in
stdenvNoCC.mkDerivation {
  pname = "shanggu-fonts";
  inherit version;

  outputs = [ "out" ] ++ extraOutputs;

  nativeBuildInputs = [ p7zip ];

  unpackPhase = ''
    runHook preUnpack
  ''
  + lib.strings.concatLines (
    lib.attrsets.mapAttrsToList (name: value: ''
      7z x ${value} -o${name}
    '') source
  )
  + ''
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/truetype
  ''
  + lib.strings.concatLines (
    lib.lists.forEach extraOutputs (name: ''
      install -Dm444 ${name}/*.ttc -t ${placeholder name}/share/fonts/truetype
      ln -s "${placeholder name}" /share/fonts/truetype/*.ttc $out/share/fonts/truetype
    '')
  )
  + ''
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/GuiWonder/Shanggu";
    description = "Heritage glyph (old glyph) font based on Siyuan";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ Cryolitia ];
  };
}
