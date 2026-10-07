{ runCommand, testers }:
let
  sitePkg = runCommand "site" { } ''
    dist=$out/dist
    mkdir -p $dist
    echo "<html><body><a href=\"https://example.com/foo.html\">foo</a><a href=\"https://nixos.org/this-is-ignored.html\">bar</a></body></html>" > $dist/index.html
    echo "<html><body><a href=\".\">index</a></body></html>" > $dist/foo.html
    echo "<html><body><a href=\"/index.html\">home</a></body></html>" > $dist/root-relative.html
  '';
in
testers.lycheeLinkCheck rec {
  site = sitePkg + "/dist";
  relocatable = false;
  remap = {
    "https://example.com" = site;
  };
}
