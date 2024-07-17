{
  lib,
  stdenvNoCC,
  fetchurl,
  p7zip,
}:
let
  version = "1.020";

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
        Mono = "sha256-PcP4zJk8pptuX9tchr4qOorqAvj8YMRBcVrtCbp/1Zo=";
        Round = "sha256-3wqMdnpdn4xpw7wO+QmIpl5/vZjQGgcfTMdtewK28B8=";
        Sans = "sha256-isRqIVcH24knPqPI+a+9CpxEKd+PG642giUS9+VbC60=";
        Serif = "sha256-k0I0NXStE1hcdOaOykuESy6sYqBHHaMaDxxr3tJUSYU=";
      };
in
stdenvNoCC.mkDerivation {
  pname = "shanggu-fonts";
  inherit version;

  outputs = [ "out" ] ++ builtins.attrNames source;

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
      lib.lists.forEach (builtins.attrNames source) (
        name:
        (
          ''install -Dm444 ${name}/*.ttc -t $''
          + name
          + ''
            /share/fonts/truetype
                      ln -s $''
          + name
          + ''
            /share/fonts/truetype/*.ttc $out/share/fonts/truetype
          ''
        )
      )
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
