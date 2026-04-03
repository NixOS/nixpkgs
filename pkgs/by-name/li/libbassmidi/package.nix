{
  lib,
  stdenv,
  unzip,
  fetchurl,
}:

let
  soMapping = {
    "i686-linux" = "libs/x86/libbassmidi.so";
    "x86_64-linux" = "libs/x86_64/libbassmidi.so";
    "armv7l-linux" = "libs/armhf/libbassmidi.so";
    "aarch64-linux" = "libs/aarch64/libbassmidi.so";
  };
in
stdenv.mkDerivation rec {
  pname = "libbassmidi";
  version = "2.4.15.3";

  src = fetchurl {
    url = "https://web.archive.org/web/20240501180447/http://www.un4seen.com/files/bassmidi24-linux.zip";
    hash = "sha256-HrF1chhGk32bKN3jwal44Tz/ENGe/zORsrLPeGAv1OE=";
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
      install -m644 -t $out/include/ bassmidi.h
    '';

  meta = {
    description = "Shareware audio library (bassmidi)";
    homepage = "https://www.un4seen.com/";
    license = lib.licenses.unfreeRedistributable;
    platforms = builtins.attrNames soMapping;
    maintainers = with lib.maintainers; [ poz ];
  };
}
