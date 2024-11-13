{
  buildNpmPackage,
  fetchFromGitLab,
  importNpmLock,
  lib,
  libsodium,
  makeWrapper,
  nodePackages,
  ocaml-ng,
}:

let
  ocamlPackages = ocaml-ng.ocamlPackages_4_14;
in

ocamlPackages.buildDunePackage rec {
  pname = "belenios";
  version = "3.0";

  # solves warnings 'patchelf: wrong ELF type'
  dontFixup = true;

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "belenios";
    repo = "belenios";
    rev = version;
    hash = "sha256-paTkzWB2QiBfFnGfiMkTIHdKeg37PTGbMu25JLJc38U=";
  };

  nativeBuildInputs =
    [
      libsodium
      nodePackages.nodejs
    ]
    ++ (with ocamlPackages; [
      atdgen
      js_of_ocaml
      menhir
      ocaml_gettext
    ]);

  buildInputs =
    [ makeWrapper ]
    ++ (with ocamlPackages; [
      atdgen
      calendar
      cmdliner
      csv
      cohttp-lwt-unix
      cryptokit
      eliom
      gettext-camomile
      hex
      js_of_ocaml
      js_of_ocaml-lwt
      js_of_ocaml-ppx
      js_of_ocaml-tyxml
      ocamlnet
      ocsipersist-sqlite-config
      sodium
      xml-light
      yojson
    ]);

  frontend = buildNpmPackage {
    pname = "belenios-frontend";
    inherit version;
    src = "${src}/frontend";
    npmFlags = [ "--include=dev" ];
    npmDeps = importNpmLock {
      npmRoot = "${src}/frontend";
      packageLock = lib.importJSON ./package-lock.json;
    };
    inherit (importNpmLock) npmConfigHook;
    dontBuild = true;
  };

  buildPhase = ''
    dune build --release
    pushd frontend
    ln -s ${frontend}/lib/node_modules/belenios-responsive-booth/node_modules .
    (cd booth && npx webpack --config webpack.config.js --mode production)
    export NODE_PATH="$PWD/node_modules"
    node ./bundle-css.js ../src/web/static/responsive_site.css > site.bundle.css
    node ./bundle-css.js booth/app.css > booth/app.bundle.css
    popd
  '';

  installPhase = ''
    dune install --prefix $out
    pushd frontend
    DEST=$out/share/belenios-server
    mkdir -p $DEST/static/frontend/{booth,translations}
    cp *.bundle.css "$DEST/static"
    cp -r booth/dist/bundle.js booth/app.bundle.css "$DEST/static/frontend/booth/"
    cp -r booth/vote.html "$DEST/apps/"
    cp -r translations/* "$DEST/static/frontend/translations/"
    popd
  '';

  meta = {
    description = "Verifiable online voting system";
    homepage = "https://www.belenios.org/";
    changelog = "https://gitlab.inria.fr/belenios/belenios/-/blob/${src.rev}/CHANGES.md";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ kiara ];
    mainProgram = "belenios";
  };
}
