{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  autoPatchelfHook,
}:

stdenv.mkDerivation rec {
  pname = "mblock-mlink";
  version = "1.2.0";

  src = fetchurl {
    url = "https://dl.makeblock.com/mblock5/linux/mLink-${version}-amd64.deb";
    sha256 = "sha256-vwIzotvplkE8gjQe25bEqTF/3N3WK7weqGmbK/HAyVA=";
  };

  unpackPhase = ''
    ${dpkg}/bin/dpkg -x $src $out
  '';

  buildInputs = [
    (lib.getLib stdenv.cc.cc)
  ];

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  installPhase = ''
    mv $out/usr/local/makeblock $out/usr/makeblock
    rmdir $out/usr/local
    mkdir -p $out/bin
    echo $out/usr/makeblock/mLink/mnode $out/usr/makeblock/mLink/app.js > $out/bin/mlink
    chmod +x $out/bin/mlink
  '';

  meta = {
    description = "Driver for mBlock web version";
    homepage = "https://mblock.makeblock.com/en-us/download/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = [ lib.maintainers.mausch ];
  };
}
