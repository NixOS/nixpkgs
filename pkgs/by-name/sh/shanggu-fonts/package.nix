{
  lib,
  stdenvNoCC,
  fetchurl,
  p7zip,
}:
let
  version = "1.022";

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
        Mono = "sha256-kRUnhNXTcU6DCgM0yDVZTzr+2SooANoSkj5bJ1zK+YI=";
        Round = "sha256-5VJsgTSOGNW87ybKtu55rn+1wp7aUBBC3IPwZopcb9o=";
        Sans = "sha256-Bss244+gG00tnWUt6hri3BO11tBMWB3+VUEuWqHqr6Y=";
        Serif = "sha256-PYuqBGxU/T6dlVpa5gqaxe5BShiaIlVisRGtPamlykE=";
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

  meta = with lib; {
    homepage = "https://github.com/GuiWonder/Shanggu";
    description = "Heritage glyph (old glyph) font based on Siyuan";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ Cryolitia ];
  };
}
