{ stdenv, fetchurl, lib, libX11, libXext, alsaLib, freetype, brand, type, version, homepage, sha256, ... }:
stdenv.mkDerivation rec {
  inherit type;
  baseName = "${type}-Edit";
  name = "${lib.toLower baseName}-${version}";

  src = fetchurl {
    url = "http://downloads.music-group.com/software/behringer/${type}/${type}-Edit_LINUX_64bit_${version}.tar.gz";
    inherit sha256;
  };

  sourceRoot = ".";
  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out/bin
    cp ${baseName} $out/bin
  '';
  preFixup = let
    # we prepare our library path in the let clause to avoid it become part of the input of mkDerivation
    libPath = lib.makeLibraryPath [
      libX11           # libX11.so.6
      libXext          # libXext.so.6
      alsaLib          # libasound.so.2
      freetype         # libfreetype.so.6
      stdenv.cc.cc.lib # libstdc++.so.6
    ];
  in ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      $out/bin/${baseName}
  '';

  meta = with stdenv.lib; {
    inherit homepage;
    description = "Editor for the ${brand} ${type} digital mixer";
    license = licenses.unfree;
    platforms = platforms.linux;
    maintainers = [ maintainers.magnetophon ];
  };
}
