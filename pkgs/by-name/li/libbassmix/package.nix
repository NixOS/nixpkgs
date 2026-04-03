{
  lib,
  stdenv,
  unzip,
  fetchurl,
}:

let
  soMapping = {
    "i686-linux" = "libs/x86/libbassmix.so";
    "x86_64-linux" = "libs/x86_64/libbassmix.so";
    "armv7l-linux" = "libs/armhf/libbassmix.so";
    "aarch64-linux" = "libs/aarch64/libbassmix.so";
  };
in
stdenv.mkDerivation rec {
  pname = "libbassmix";
  version = "2.4.12";

  src = fetchurl {
    url = "https://web.archive.org/web/20240930183631/https://www.un4seen.com/files/bassmix24-linux.zip";
    hash = "sha256-oxxBhsjeLvUodg2SOMDH4wUy5na3nxLTqYkB+iXbOgA=";
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
      install -m644 -t $out/include/ bassmix.h
    '';

  meta = {
    description = "Shareware audio library (bassmix)";
    homepage = "https://www.un4seen.com/";
    license = lib.licenses.unfreeRedistributable;
    platforms = builtins.attrNames soMapping;
    maintainers = with lib.maintainers; [ poz ];
  };
}
