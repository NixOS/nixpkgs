{ stdenv
, callPackage
, lib}:

let
  pname = "zotero";
  version = "7.0.5";
  meta = with lib; {
    homepage = "https://www.zotero.org";
    description = "Collect, organize, cite, and share your research sources";
    mainProgram = "zotero";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.agpl3Only;
    platforms = [ "x86_64-linux" "aarch64-darwin" ];
    maintainers = with maintainers; [ atila justanotherariel ];
  };
in
  if stdenv.isDarwin then callPackage ./darwin.nix { inherit pname version; }
  else callPackage ./linux.nix { inherit pname version meta; }
