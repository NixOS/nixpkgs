{ lib
, asciidoctor
, vscode-utils
, jq
, moreutils
, nixpkgs-fmt
, clojure-lsp
, callPackage
, racket-minimal
}:

let inherit (lib) maintainers licenses;
  inherit (vscode-utils) fetchVsixFromVscodeMarketplace buildVscodeMarketplaceExtension;

in
# note: this doesn't seem to work well with aliases, gonna need help on that
self: super: {
  _4ops.terraform.meta.maintainers = with maintainers; [ kamadorueda ];
  angular.ng-template.meta.maintainers = with maintainers; [ ratsclub ];
  antyos.openscad.meta.license = licenses.gpl3;
  apollographql.vscode-apollo.meta.maintainers = with maintainers; [ datafoo ];
  arcticicestudio.nord-visual-studio-code.meta.maintainers = with maintainers; [ imgabe ];
  arjun.swagger-viewer.meta.license = licenses.mit;
  asciidoctor.asciidoctor-vscode = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "asciidoctor-vscode";
      publisher = "asciidoctor";
      version = "2.8.9";
      sha256 = "1xkxx5i3nhd0dzqhhdmx0li5jifsgfhv0p5h7xwsscz3gzgsdcyb";
    };

    postPatch = ''
      substituteInPlace dist/src/text-parser.js \
        --replace "get('asciidoctor_command', 'asciidoctor')" \
                  "get('asciidoctor_command', '${asciidoctor}/bin/asciidoctor')"
      substituteInPlace dist/src/commands/exportAsPDF.js \
        --replace "get('asciidoctorpdf_command', 'asciidoctor-pdf')" \
                  "get('asciidoctorpdf_command', '${asciidoctor}/bin/asciidoctor-pdf')"
    '';

    meta = with lib; {
      license = licenses.mit;
    };
  };

  asvetliakov.vscode-neovim.meta.license = licenses.mit;
  attilabuti.brainfuck-syntax.meta.maintainers = with maintainers; [ superherointj ];
  ms-python.vscode-pylance.meta.license = licenses.unfree;
  b4dm4n.nixpkgs-fmt = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "nixpkgs-fmt";
      publisher = "B4dM4n";
      version = "0.0.1";
      sha256 = "sha256-vz2kU36B1xkLci2QwLpl/SBEhfSWltIDJ1r7SorHcr8=";
    };
    nativeBuildInputs = [ jq moreutils ];
    postInstall = ''
      cd "$out/$installPrefix"
      jq '.contributes.configuration.properties."nixpkgs-fmt.path".default = "${nixpkgs-fmt}/bin/nixpkgs-fmt"' package.json | sponge package.json
    '';
    meta = with lib; {
      license = licenses.mit;
    };
  };
  baccata.scaladex-search.meta.license = licenses.asl20;
  badochov.ocaml-formatter.meta.maintainers = with maintainers; [ superherointj ];
  bbenoist.nix.meta.license = licenses.mit;
  betterthantomorrow.calva = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "calva";
      publisher = "betterthantomorrow";
      version = "2.0.205";
      sha256 = "sha256-umnG1uLB42fUNKjANaKcABjVmqbdOQakd/6TPsEpF9c";
    };
    nativeBuildInputs = [ jq moreutils ];
    postInstall = ''
      cd "$out/$installPrefix"
      jq '.contributes.configuration[0].properties."calva.clojureLspPath".default = "${clojure-lsp}/bin/clojure-lsp"' package.json | sponge package.json
    '';
    meta = with lib; {
      license = licenses.mit;
    };
  };
  bodil.file-browser.license = licenses.lgpl3Plus;
  bungcip.better-toml.maintainers = with maintainers; [ datafoo ];
  chenglou92.rescript-vscode = callPackage ./rescript { };
  christian-kohler.path-intellisense.meta = {
    license = licenses.mit;
    maintainers = with maintainers; [ imgabe ];
  };
  cmschuetz12.wal.meta.license = licenses.mit;
  coenraads.bracket-pair-colorizer.meta.license = licenses.mit;
  coenraads.bracket-pair-colorizer-2.meta.license = licenses.mit;
  coolbear.systemd-unit-file.meta.maintainers = with maintainers; [ kamadorueda ];
  cweijan.vscode-database-client2.meta.license = licenses.mit;
  daohong-emilio.yash.meta.maintainers = with lib.maintainers; [ kamadorueda ];
  davidanson.vscode-markdownlint.meta.maintainers = with maintainers; [ datafoo ];
  davidlday.languagetool-linter.meta.maintainers = with maintainers; [ ebbertd ];
  denoland.vscode-deno.meta.maintainers = with maintainers; [ ratsclub ];
  disneystreaming.smithy.meta.license = lib.licenses.asl20;
  divyanshuagrawal.competitive-programming-helper.meta.maintainers = with maintainers; [ arcticlimer ];
  dotjoshjohnson.xml.meta.license = licenses.mit;
  eamodio.gitlens.meta = {
    license = licenses.mit;
    maintainers = with maintainers; [ ratsclub ];
  };
  editorconfig.editorconfig.meta.maintainers = with maintainers; [ dbirks ];
  edonet.vscode-command-runner.meta.license = lib.licenses.mit;
  elmtooling.elm-ls-vscode.meta.maintainers = with maintainers; [ mcwitt ];
  esbenp.prettier-vscode.meta.maintainers = with maintainers; [ datafoo ];
  eugleo.magic-racket = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "magic-racket";
      publisher = "evzen-wybitul";
      version = "0.5.7";
      sha256 = "sha256-34/H0WgM73yzuOGU2w6Ipq7KuEBuN1bykcLGuvzY3mU=";
    };
    nativeBuildInputs = [ jq moreutils ];
    postInstall = ''
      cd "$out/$installPrefix"
      jq '.contributes.configuration.properties."magic-racket.general.racketPath".default = "${racket-minimal}/bin/racket"' package.json | sponge package.json
    '';
    meta = with lib; {
      changelog = "https://marketplace.visualstudio.com/items/evzen-wybitul.magic-racket/changelog";
      description = "The best coding experience for Racket in VS Code ";
      downloadPage = "https://marketplace.visualstudio.com/items?itemName=evzen-wybitul.magic-racket";
      homepage = "https://github.com/Eugleo/magic-racket";
      license = licenses.agpl3Only;
    };
  };
  faustinoaq.lex-flex-yacc-bison.meta.maintainers = with maintainers; [ emilytrau ];
  foam.foam-vscode.meta.maintainers = with maintainers; [ ratsclub ];
  foxundermoon.shell-format.meta = {
    license = licenses.mit;
    maintainers = with maintainers; [ dbirks ];
  };
  gencer.html-slim-scss-css-class-completion.meta = {
    license = licenses.mit;
    maintainers = with maintainers; [ superherointj ];
  };
  gitlab.gitlab-workflow.meta.maintainers = with maintainers; [ superherointj ];
  grapecity.gc-excelviewer.meta = {
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
  jkillian.custom-local-formatters.meta.maintainers = with lib.maintainers; [ kamadorueda ];
  github.copilot.meta.license = licenses.unfree;
  github.github-vscode-theme.meta.maintainers = with maintainers; [ hugolgst ];
  hashicorp.terraform = callPackage ./terraform { };
  iciclesoft.workspacesort.meta.maintainers = with maintainers; [ dbirks ];
  ionide.ionide-fsharp.meta.maintainers = with maintainers; [ ratsclub ];
  irongeek.vscode-env.meta.maintainers = with maintainers; [ superherointj ];
  jakebecker.elixir-ls.meta.maintainers = with maintainers; [ datafoo ];
  jdinhlife.gruvbox.meta.maintainers = with maintainers; [ imgabe ];
  jnoortheen.nix-ide.meta.maintainers = with maintainers; [ SuperSandro2000 ];
  johnpapa.vscode-peacock.meta.license = licenses.mit;
}
