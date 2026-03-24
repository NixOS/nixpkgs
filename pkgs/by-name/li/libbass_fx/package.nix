{
  lib,
  stdenv,
  unzip,
  fetchurl,
}:

let
  soMapping = {
    "i686-linux" = "libs/x86/libbass_fx.so";
    "x86_64-linux" = "libs/x86_64/libbass_fx.so";
    "armv7l-linux" = "libs/armhf/libbass_fx.so";
    "aarch64-linux" = "libs/aarch64/libbass_fx.so";
  };
in
stdenv.mkDerivation rec {
  pname = "libbass_fx";
  version = "2.4.12.6";

  src = fetchurl {
    url = "https://web.archive.org/web/20250627192213/https://www.un4seen.com/files/z/0/bass_fx24-linux.zip";
    hash = "sha256-Hul2ELwnaDV8TDRMDXoFisle31GATDkf3PdkR2K9QTs=";
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
      install -m644 -t $out/include/ C/bass_fx.h
    '';

  meta = {
    description = "Shareware audio library (bass_fx)";
    homepage = "https://www.un4seen.com/";
    license = lib.licenses.unfreeRedistributable;
    platforms = builtins.attrNames soMapping;
    maintainers = with lib.maintainers; [ poz ];
  };
}
