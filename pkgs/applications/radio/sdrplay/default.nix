{ stdenv, lib, fetchurl, autoPatchelfHook, udev }:
let
  arch = if stdenv.isx86_64  then "x86_64"
    else if stdenv.isi686    then "i686"
    else throw "unsupported architecture";
in stdenv.mkDerivation rec {
  pname = "sdrplay";
  version = "3.07.1";

  src = fetchurl {
    url = "https://www.sdrplay.com/software/SDRplay_RSP_API-Linux-${version}.run";
    sha256 = "1a25c7rsdkcjxr7ffvx2lwj7fxdbslg9qhr8ghaq1r53rcrqgzmf";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [ udev stdenv.cc.cc.lib ];

  unpackPhase = ''
    sh "$src" --noexec --target source
  '';

  sourceRoot = "source";

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/{bin,lib,include,lib/udev/rules.d}
    majorVersion="${lib.concatStringsSep "." (lib.take 1 (builtins.splitVersion version))}"
    majorMinorVersion="${lib.concatStringsSep "." (lib.take 2 (builtins.splitVersion version))}"
    libName="libsdrplay_api"
    cp "${arch}/$libName.so.$majorMinorVersion" $out/lib/
    ln -s "$out/lib/$libName.so.$majorMinorVersion" "$out/lib/$libName.so.$majorVersion"
    ln -s "$out/lib/$libName.so.$majorVersion" "$out/lib/$libName.so"
    cp "${arch}/sdrplay_apiService" $out/bin/
    cp -r inc/* $out/include/
    cp 66-mirics.rules $out/lib/udev/rules.d/
  '';

  meta = with lib; {
    description = "SDRplay API";
    longDescription = ''
      Proprietary library and api service for working with SDRplay devices. For documentation and licensing details see
      https://www.sdrplay.com/docs/SDRplay_API_Specification_v${lib.concatStringsSep "." (lib.take 2 (builtins.splitVersion version))}.pdf
    '';
    homepage = "https://www.sdrplay.com/downloads/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = [ maintainers.pmenke ];
    platforms = platforms.linux;
  };
}
