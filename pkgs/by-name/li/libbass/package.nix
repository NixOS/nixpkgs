{
  lib,
  stdenv,
  unzip,
  fetchurl,
}:

let
  soMapping = {
    "i686-linux" = "libs/x86/libbass.so";
    "x86_64-linux" = "libs/x86_64/libbass.so";
    "armv7l-linux" = "libs/armhf/libbass.so";
    "aarch64-linux" = "libs/aarch64/libbass.so";
  };
in
stdenv.mkDerivation rec {
  pname = "libbass";
  version = "2.4.18.3";

  src = fetchurl {
    url = "https://web.archive.org/web/20251222154947/https://www.un4seen.com/files/bass24-linux.zip";
    hash = "sha256-3iZk+9MaGn7vTbSNprjChICMXhk8Pu4hWHIR3peGkXI=";
  };

  nativeBuildInputs = [ unzip ];
  dontBuild = true;

  unpackCmd = ''
    mkdir out
    ${unzip}/bin/unzip $curSrc -d out
  '';

  installPhase =
    let
      system = stdenv.hostPlatform.system;
      soFile =
        if soMapping ? ${system} then
          soMapping.${system}
        else
          throw "${pname} not packaged for ${system} (yet).";
    in
    ''
      mkdir -p $out/{lib,include}
      install -m644 -t $out/lib/ ${soFile}
      install -m644 -t $out/include/ c/bass.h
    '';

  meta = {
    description = "Shareware audio library";
    homepage = "https://www.un4seen.com/";
    license = lib.licenses.unfreeRedistributable;
    platforms = builtins.attrNames soMapping;
    maintainers = with lib.maintainers; [ poz ];
  };
}
