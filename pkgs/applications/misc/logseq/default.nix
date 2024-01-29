{ lib
, stdenv
, callPackage
}:

let
  pname = "logseq";
  version = "0.10.5";
  meta = with lib; {
    description = "A local-first, non-linear, outliner notebook for organizing and sharing your personal knowledge base";
    homepage = "https://github.com/logseq/logseq";
    changelog = "https://github.com/logseq/logseq/releases/tag/${version}";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
  };
in
if stdenv.isDarwin then callPackage ./darwin.nix { inherit pname version meta; }
else callPackage ./linux.nix { inherit pname version meta; }
