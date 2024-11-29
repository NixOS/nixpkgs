{ metaFetch, coq, lib, glib, adwaita-icon-theme, wrapGAppsHook3,
  version ? null }:

let ocamlPackages = coq.ocamlPackages;
    defaultVersion = with lib.versions; lib.switch coq.coq-version [
      { case = range "8.18" "8.20"; out = "2.1.7"; }
      { case = range "8.18" "8.19"; out = "2.1.2"; }
      { case = isEq "8.18"; out = "2.0.3+coq8.18"; }
    ] null;
    location = { domain = "github.com"; owner = "coq-community"; repo = "vscoq"; };
    fetch = metaFetch ({
      release."2.0.3+coq8.18".sha256 = "sha256-VXhHCP6Ni5/OcsgoI1EbJfYCpXzwkuR8kbbKrl6dfjU=";
      release."2.0.3+coq8.18".rev = "v2.0.3+coq8.18";
      release."2.1.2".rev = "v2.1.2";
      release."2.1.2".sha256 = "sha256-GloY68fLmIv3oiEGNWwmgKv1CMAReBuXzMTUsKOs328=";
      release."2.1.4".rev = "v2.1.4";
      release."2.1.4".sha256 = "sha256-Vwve1sCg5OsGmhDLlOyGCwP6A8g618IzD79vLPw/JtQ=";
      release."2.1.7".rev = "v2.1.7";
      release."2.1.7".sha256 = "sha256-HsLv2ziPIUK6Q5/xz8ZvaGWggUCK1AKv47U5M7SCcKU=";
      inherit location; });
    fetched = fetch (if version != null then version else defaultVersion);
in
ocamlPackages.buildDunePackage {
  pname = "vscoq-language-server";
  inherit (fetched) version;
  src = "${fetched.src}/language-server";
  nativeBuildInputs = [ coq ];
  buildInputs =
    [ coq glib adwaita-icon-theme wrapGAppsHook3 ] ++
    (with ocamlPackages; [ findlib
      lablgtk3-sourceview3 yojson zarith ppx_inline_test
      ppx_assert ppx_sexp_conv ppx_deriving ppx_import sexplib
      ppx_yojson_conv lsp sel ppx_optcomp ]);

  meta = with lib; {
    description = "Language server for the vscoq vscode/codium extension";
    homepage = "https://github.com/coq-community/vscoq";
    maintainers = with maintainers; [ cohencyril ];
    license = licenses.mit;
  } // optionalAttrs (fetched.broken or false) { coqFilter = true; broken = true; };
}
