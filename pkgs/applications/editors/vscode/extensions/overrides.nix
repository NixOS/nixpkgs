{ lib
, asciidoctor
, vscode-utils
, jq
, moreutils
, nixpkgs-fmt
, clojure-lsp
, callPackage
, racket-minimal
, alejandra
, python3Packages
, jdk
, shellcheck
, fetchurl
, llvmPackages_8
, protobuf
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
  daohong-emilio.yash.meta.maintainers = with maintainers; [ kamadorueda ];
  davidanson.vscode-markdownlint.meta.maintainers = with maintainers; [ datafoo ];
  davidlday.languagetool-linter.meta.maintainers = with maintainers; [ ebbertd ];
  denoland.vscode-deno.meta.maintainers = with maintainers; [ ratsclub ];
  disneystreaming.smithy.meta.license = licenses.asl20;
  divyanshuagrawal.competitive-programming-helper.meta.maintainers = with maintainers; [ arcticlimer ];
  dotjoshjohnson.xml.meta.license = licenses.mit;
  eamodio.gitlens.meta = {
    license = licenses.mit;
    maintainers = with maintainers; [ ratsclub ];
  };
  editorconfig.editorconfig.meta.maintainers = with maintainers; [ dbirks ];
  edonet.vscode-command-runner.meta.license = licenses.mit;
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
  jkillian.custom-local-formatters.meta.maintainers = with maintainers; [ kamadorueda ];
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
  kamadorueda.alejandra = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "alejandra";
      publisher = "kamadorueda";
      version = "1.0.0";
      sha256 = "sha256-COlEjKhm8tK5XfOjrpVUDQ7x3JaOLiYoZ4MdwTL8ktk=";
    };
    nativeBuildInputs = [ jq moreutils ];
    postInstall = ''
      cd "$out/$installPrefix"

      jq -e '
        .contributes.configuration.properties."alejandra.program".default =
          "${alejandra}/bin/alejandra" |
        .contributes.configurationDefaults."alejandra.program" =
          "${alejandra}/bin/alejandra"
      ' \
      < package.json \
      | sponge package.json
    '';
    meta = with lib; {
      description = "The Uncompromising Nix Code Formatter";
      homepage = "https://github.com/kamadorueda/alejandra";
      license = licenses.unlicense;
      maintainers = with maintainers; [ kamadorueda ];
    };
  };
  kddejong.vscode-cfn-lint =
    let
      inherit (python3Packages) cfn-lint;
    in
    buildVscodeMarketplaceExtension {
      mktplcRef = {
        name = "vscode-cfn-lint";
        publisher = "kddejong";
        version = "0.21.0";
        sha256 = "sha256-IueXiN+077tiecAsVCzgYksWYTs00mZv6XJVMtRJ/PQ=";
      };

      nativeBuildInputs = [ jq moreutils ];

      buildInputs = [ cfn-lint ];

      postInstall = ''
        cd "$out/$installPrefix"
        jq '.contributes.configuration.properties."cfnLint.path".default = "${cfn-lint}/bin/cfn-lint"' package.json | sponge package.json
      '';

      meta = with lib; {
        description = "CloudFormation Linter IDE integration, autocompletion, and documentation";
        homepage = "https://github.com/aws-cloudformation/cfn-lint-visual-studio-code";
        license = licenses.asl20;
        maintainers = with maintainers; [ wolfangaukang ];
      };
    };
  lokalise.i18n-ally.meta.license = licenses.mit;
  mads-hartmann.bash-ide-vscode.meta.maintainers = with maintainers; [ kamadorueda ];
  mattn.lisp.meta.maintainers = with maintainers; [ kamadorueda ];
  mhutchie.git-graph.meta.license = licenses.mit;
  mishkinf.goto-next-previous-member.meta.license = licenses.mit;
  mskelton.one-dark-theme.meta.license = licenses.mit;
  ms-azuretools.vscode-docker.meta.license = licenses.mit;
  ms-ceintl = callPackage ./language-packs.nix { }; # non-English language packs
  ms-dotnettools.csharp = callPackage ./ms-dotnettools-csharp { };
  ms-vscode.cpptools = callPackage ./cpptools { };
  ms-vscode-remote.remote-ssh = callPackage ./remote-ssh { };
  ms-vscode.theme-tomorrowkit.meta = {
    license = licenses.mit;
    maintainers = with maintainers; [ ratsclub ];
  };
  ms-pyright.pyright.meta.maintainers = with maintainers; [ ratsclub ];
  ms-python.python = callPackage ./python {
    extractNuGet = callPackage ./python/extract-nuget.nix { };
  };
  msjsdiag.debugger-for-chrome.meta.license = licenses.mit;
  ms-toolsai.jupyter = callPackage ./ms-toolsai-jupyter { };
  ms-vscode.anycode.meta.license = licenses.mit;
  # Search for "latest" doesn't seem to work for this extension.
  naumovs.color-highlight = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "color-highlight";
      publisher = "naumovs";
      version = "2.5.0";
      sha256 = "sha256-dYMDV84LEGXUjt/fbsSy3BVM5SsBHcPaDDll8KjPIWY=";
    };
    meta = with lib; {
      changelog = "https://marketplace.visualstudio.com/items/naumovs.color-highlight/changelog";
      description = "Highlight web colors in your editor";
      downloadPage = "https://marketplace.visualstudio.com/items?itemName=naumovs.color-highlight";
      homepage = "https://github.com/enyancc/vscode-ext-color-highlight";
      license = licenses.gpl3Only;
      maintainers = with maintainers; [ datafoo ];
    };
  };
  njpwerner.autodocstring.meta = {
    license = licenses.mit;
    maintainers = with maintainers; [ kamadorueda ];
  };
  octref.vetur.meta.license = licenses.mit;
  oderwat.indent-rainbow.meta.maintainers = with maintainers; [ imgabe ];
  phoenixframework.phoenix.meta.maintainers = with maintainers; [ superherointj ];
  redhat.java = {
    buildInputs = [ jdk ];
    meta = {
      license = licenses.epl20;
      broken = lib.versionOlder jdk.version "11";
    };
  };
  rust-lang.rust-analyzer = callPackage ./rust-analyzer { };
  ocamllabs.ocaml-platform.meta.maintainers = with maintainers; [ ratsclub ];
  pkief.material-icon-theme.meta.license = licenses.mit;
  pkief.material-product-icons.meta.license = licenses.mit;
  prisma.prisma.meta.maintainers = with maintainers; [ superherointj ];
  ryu1kn.partial-diff.meta.license = licenses.mit;
  scala-lang.scala.meta.license = licenses.mit;
  serayuzgur.crates.meta.license = licenses.mit;
  shardulm94.trailing-spaces.meta.maintainers = with maintainers; [ kamadorueda ];
  silvenon.mdx.meta.license = licenses.mit;
  skellock.just.meta.maintainers = with maintainers; [ maximsmol ];
  skyapps.fish-vscode.meta.license = licenses.mit;
  slevesque.vscode-multiclip.meta.license = licenses.mit;
  stefanjarina.vscode-eex-snippets.meta.maintainers = with maintainers; [ superherointj ];
  stephlin.vscode-tmux-keybinding.meta = {
    license = licenses.mit;
    maintainers = with maintainers; [ dbirks ];
  };
  stkb.rewrap.meta = {
    license = licenses.asl20;
    maintainers = with maintainers; [ datafoo ];
  };
  streetsidesoftware.code-spell-checker.meta.maintainers = with maintainers; [ datafoo ];
  svsool.markdown-memo.meta.maintainers = with maintainers; [ ratsclub ];
  tabnine.tabnine-vscode.meta.license = licenses.mit;
  tamasfe.even-better-toml.meta.license = licenses.mit;
  theangryepicbanana.language-pascal.meta.maintainers = with maintainers; [ superherointj ];
  timonwong.shellcheck = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "shellcheck";
      publisher = "timonwong";
      version = "0.19.3";
      sha256 = "0l8fbim19jgcdgxxgidnhdczxvhls920vrffwrac8k1y34lgfl3v";
    };
    nativeBuildInputs = [ jq moreutils ];
    postInstall = ''
      cd "$out/$installPrefix"
      jq '.contributes.configuration.properties."shellcheck.executablePath".default = "${shellcheck}/bin/shellcheck"' package.json | sponge package.json
    '';
    meta = {
      license = licenses.mit;
    };
  };
  tobiasalthoff.atom-material-theme.meta.license = licenses.mit;
  tomoki1207.pdf.meta.license = licenses.mit;
  usernamehw.errorlens.meta.maintainers = with maintainers; [ imgabe ];
  vadimcn.vscode-lldb = callPackage ./vscode-lldb { };
  valentjn.vscode-ltex = vscode-utils.buildVscodeMarketplaceExtension rec {
    mktplcRef = {
      name = "vscode-ltex";
      publisher = "valentjn";
      version = "13.1.0";
    };

    vsix = fetchurl {
      name = "${mktplcRef.publisher}-${mktplcRef.name}.zip";
      url = "https://github.com/valentjn/vscode-ltex/releases/download/${mktplcRef.version}/vscode-ltex-${mktplcRef.version}-offline-linux-x64.vsix";
      sha256 = "1nlrijjwc35n1xgb5lgnr4yvlgfcxd0vdj93ip8lv2xi8x1ni5f6";
    };

    nativeBuildInputs = [ jq moreutils ];

    buildInputs = [ jdk ];

    postInstall = ''
      cd "$out/$installPrefix"
      jq '.contributes.configuration.properties."ltex.java.path".default = "${jdk}"' package.json | sponge package.json
    '';

    meta = with lib; {
      license = licenses.mpl20;
      maintainers = [ maintainers._0xbe7a ];
    };
  };
  viktorqvarfordt.vscode-pitch-black-theme.meta = {
    license = licenses.mit;
    maintainers = with maintainers; [ wolfangaukang ];
  };
  ms-vsliveshare.vsliveshare = callPackage ./ms-vsliveshare-vsliveshare { };
  vspacecode.vspacecode.meta.license = licenses.mit;
  vspacecode.whichkey.meta.license = lib.licenses.mit;
  xaver.clang-format.meta.maintainers = [ maintainers.zeratax ];
  xyz.local-history.meta.license = lib.licenses.mit;
  llvm-org.lldb-vscode = llvmPackages_8.lldb;
  WakaTime.vscode-wakatime = callPackage ./wakatime { };
  zxh404.vscode-proto3 = buildVscodeMarketplaceExtension {
    mktplcRef = {
      name = "vscode-proto3";
      publisher = "zxh404";
      version = "0.5.4";
      sha256 = "08dfl5h1k6s542qw5qx2czm1wb37ck9w2vpjz44kp2az352nmksb";
    };
    nativeBuildInputs = [ jq moreutils ];
    postInstall = ''
      cd "$out/$installPrefix"
      jq '.contributes.configuration.properties.protoc.properties.path.default = "${protobuf}/bin/protoc"' package.json | sponge package.json
    '';
    meta = {
      license = lib.licenses.mit;
    };
  };
}
