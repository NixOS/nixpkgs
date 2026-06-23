{ lib, appimageTools, fetchurl }:

appimageTools.wrapType2 {
  pname = "zennotes";
  version = "2.5.0";

  src = fetchurl {
    url = "https://github.com/ZenNotes/zennotes/releases/download/v2.5.0/ZenNotes-2.5.0-linux-x86_64.AppImage";
    hash = "sha256-ikXfCxLtz2zicmJeie3Jp6X6hVsE2b9PHc3Rjv3o+0k=";
  };

  meta = with lib; {
    description = "ZenNotes markdown note-taking application";
    homepage = "https://zennotes.org";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "zennotes";
  };
}
