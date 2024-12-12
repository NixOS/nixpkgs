{
  stdenv,
  fetchurl,
  lib,
  libX11,
  libXext,
  alsa-lib,
  freetype,
  brand,
  type,
  version,
  homepage,
  url,
  sha256,
  ...
}:
stdenv.mkDerivation rec {
  pname = "${lib.toLower type}-edit";
  inherit version;

  src = fetchurl {
    inherit url;
    inherit sha256;
  };

  sourceRoot = ".";
  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out/bin
    cp ${type}-Edit $out/bin/${pname}
  '';
  preFixup =
    let
      # we prepare our library path in the let clause to avoid it become part of the input of mkDerivation
      libPath = lib.makeLibraryPath [
        libX11 # libX11.so.6
        libXext # libXext.so.6
        alsa-lib # libasound.so.2
        freetype # libfreetype.so.6
        (lib.getLib stdenv.cc.cc) # libstdc++.so.6
      ];
    in
    ''
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${libPath}" \
        $out/bin/${pname}
    '';

  meta = with lib; {
    inherit homepage;
    description = "Editor for the ${brand} ${type} digital mixer";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ maintainers.magnetophon ];
  };
}
