{
  stdenv,
  lib,
  fetchzip,
  dpkg,
  autoPatchelfHook,
  cups,
}:
let
  debPlatform =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      "amd64"
    else if stdenv.hostPlatform.system == "i686-linux" then
      "i386"
    else
      throw "Unsupported system: ${stdenv.hostPlatform.system}";
in
stdenv.mkDerivation rec {
  pname = "fxlinuxprint";
  version = "1.1.2-1";

  # https://support-fb.fujifilm.com/driver_downloads/fxlinuxpdf112119031.zip is gone
  src = fetchzip {
    url = "https://github.com/NixOS/nixpkgs/files/12232817/fxlinuxpdf112119031.zip";
    sha256 = "1mv07ch6ysk9bknfmjqsgxb803sj6vfin29s9knaqv17jvgyh0n3";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];
  buildInputs = [ cups ];

  sourceRoot = ".";
  unpackCmd = "dpkg-deb -x $curSrc/fxlinuxprint_${version}_${debPlatform}.deb .";

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out
    mv etc $out
    mv usr/lib $out

    mkdir -p $out/share/cups/model
    mv usr/share/ppd/FujiXerox/* $out/share/cups/model
  '';

  meta = with lib; {
    description = "Fuji Xerox Linux Printer Driver";
    longDescription = ''
      DocuPrint P365/368 d
      DocuPrint CM315/318 z
      DocuPrint CP315/318 dw
      ApeosPort-VI C2271/C3370/C3371/C4471/C5571/C6671/C7771
      DocuCentre-VI C2271/C3370/C3371/C4471/C5571/C6671/C7771
      DocuPrint 3205 d/3208 d/3505 d/3508 d/4405 d/4408 d
    '';
    homepage = "https://onlinesupport.fujixerox.com";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
