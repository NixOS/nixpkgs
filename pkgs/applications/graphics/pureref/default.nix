{ lib, appimageTools, requireFile }:

appimageTools.wrapType1 rec {
  pname = "pureref";
  version = "1.11.1";

  src = requireFile {
    name = "PureRef-${version}_x64.Appimage";
    sha256 = "05naywdgykqrsgc3xybskr418cyvbx7vqs994yv9w8zf98gxvbvm";
    url = "https://www.pureref.com/download.php";
  };

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}
  '';

  meta = with lib; {
    description = "Reference Image Viewer";
    homepage = "https://www.pureref.com";
    license = licenses.unfree;
    maintainers = with maintainers; [ elnudev ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
