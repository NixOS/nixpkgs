{
  lib,
  stdenvNoCC,
  fetchurl,
  p7zip,
}:
let
  version = "1.021";

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
        Mono = "sha256-3WwknXSMH12Lu/HA/f647AyhDg2O9Eg5ZGDBrFp4SbE=";
        Round = "sha256-vRL2YQkcp5vDSbLaMDEYd7HJVohZFYKlBfxAdY2l3mA=";
        Sans = "sha256-x5z6GYsfQ+8a8W0djJTY8iutuLNYvaemIpdYh94krk0=";
        Serif = "sha256-3WK7vty3zZFNKkwViEsozU3qa+5hymYwXk6ta9AxmNM=";
      };

  extraOutputs = builtins.attrNames source;
in
stdenvNoCC.mkDerivation {
  pname = "shanggu-fonts";
  inherit version;

  outputs = [ "out" ] ++ extraOutputs;

  nativeBuildInputs = [ p7zip ];

  unpackPhase =
    ''
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

  installPhase =
    ''
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

  meta = with lib; {
    homepage = "https://github.com/GuiWonder/Shanggu";
    description = "Heritage glyph (old glyph) font based on Siyuan";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ Cryolitia ];
  };
}
