{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
}:
let
  version = "1.028";

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
        Mono = "sha256-QQgEUQbWOr3sOIT2yQpkY9cL2sHFO/Z/hrhV5YqA3Zk=";
        Round = "sha256-izPntZyAfeL/DuhDvZ+FWKq71Uj4WuHWC4d7Z3qEsvc=";
        Sans = "sha256-a05MO8vq+PqDlYtuDstN6hlx/IkNY0JCwcmlYYK3Xcw=";
        Serif = "sha256-A1/KygN+OC1e3p8T6OAN8jCAi8HuswkE/xjo65GVweY=";
      };

  extraOutputs = builtins.attrNames source;
in
stdenvNoCC.mkDerivation {
  pname = "shanggu-fonts";
  inherit version;

  outputs = [ "out" ] ++ extraOutputs;

  nativeBuildInputs = [
    _7zz
  ];

  unpackPhase = ''
    runHook preUnpack
  ''
  + lib.strings.concatLines (
    lib.attrsets.mapAttrsToList (name: value: ''
      7zz x ${value} -o${name}
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
