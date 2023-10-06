{ config
, lib
, fetchurl
, callPackage
, vscode-utils
, asciidoctor
, nodePackages
, python3Packages
, jdk
, llvmPackages_8
, llvmPackages_14
, nixpkgs-fmt
, protobuf
, jq
, shellcheck
, moreutils
, racket
, clojure-lsp
, alejandra
, millet
, shfmt
, typst-lsp
, autoPatchelfHook
, zlib
, stdenv
}:

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;

  #
  # Unless there is a good reason not to, we attempt to use the lowercase
  # version of the extension's unique identifier. The unique identifier can be
  # found on the marketplace extension page, and is the name under which the
  # extension is installed by VSCode under `~/.vscode`.
  #
  # This means an extension should be located at
  # ${lib.strings.toLower mktplcRef.publisher}.${lib.string.toLower mktplcRef.name}
  #
  baseExtensions = self: lib.mapAttrs (_n: lib.recurseIntoAttrs)
    {
      "1Password".op-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "1Password";
          name = "op-vscode";
          version = "1.0.4";
          sha256 = "sha256-s6acue8kgFLf5fs4A7l+IYfhibdY76cLcIwHl+54WVk=";
        };
        meta = {
          changelog = "https://github.com/1Password/op-vscode/releases";
          description = "A VSCode extension that integrates your development workflow with 1Password service";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=1Password.op-vscode";
          homepage = "https://github.com/1Password/op-vscode";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers._2gn ];
        };
      };

      "2gua".rainbow-brackets = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "2gua";
          name = "rainbow-brackets";
          version = "0.0.6";
          sha256 = "TVBvF/5KQVvWX1uHwZDlmvwGjOO5/lXbgVzB26U8rNQ=";
        };
        meta = {
          description = "A Visual Studio Code extension providing rainbow brackets";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=2gua.rainbow-brackets";
          homepage = "https://github.com/lcultx/rainbow-brackets";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.CompEng0001 ];
        };
      };

      "4ops".terraform = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "4ops";
          name = "terraform";
          version = "0.2.5";
          sha256 = "sha256-y5LljxK8V9Fir9EoG8g9N735gISrlMg3czN21qF/KjI=";
        };
        meta = {
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.kamadorueda ];
        };
      };

      a5huynh.vscode-ron = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-ron";
          publisher = "a5huynh";
          version = "0.10.0";
          sha256 = "sha256-DmyYE7RHOX/RrbIPYCq/x0l081SzmyBAd7yHSUOPkOA=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      adpyke.codesnap = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "codesnap";
          publisher = "adpyke";
          version = "1.3.4";
          sha256 = "sha256-dR6qODSTK377OJpmUqG9R85l1sf9fvJJACjrYhSRWgQ=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      alanz.vscode-hie-server = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-hie-server";
          publisher = "alanz";
          version = "0.0.27"; # see the note above
          sha256 = "1mz0h5zd295i73hbji9ivla8hx02i4yhqcv6l4r23w3f07ql3i8h";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      alefragnani.bookmarks = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "bookmarks";
          publisher = "alefragnani";
          version = "13.3.1";
          sha256 = "sha256-CZSFprI8HMQvc8P9ZH+m0j9J6kqmSJM1/Ik24ghif2A=";
        };
        meta = {
          license = lib.licenses.gpl3;
        };
      };

      alefragnani.project-manager = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "project-manager";
          publisher = "alefragnani";
          version = "12.7.0";
          sha256 = "sha256-rBMwvm7qUI6zBrXdYntQlY8WvH2fDBhEuQ1pHDl9fQg=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      alexdima.copy-relative-path = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "copy-relative-path";
          publisher = "alexdima";
          version = "0.0.2";
          sha256 = "06g601n9d6wyyiz659w60phgm011gn9jj5fy0gf5wpi2bljk3vcn";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      alygin.vscode-tlaplus = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-tlaplus";
          publisher = "alygin";
          version = "1.5.4";
          sha256 = "0mf98244z6wzb0vj6qdm3idgr2sr5086x7ss2khaxlrziif395dx";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      angular.ng-template = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "ng-template";
          publisher = "Angular";
          version = "15.2.0";
          sha256 = "sha256-ho3DtXAAafY/mpUcea2OPhy8tpX+blJMyVxbFVUsspk=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/Angular.ng-template/changelog";
          description = "Editor services for Angular templates";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=Angular.ng-template";
          homepage = "https://github.com/angular/vscode-ng-language-service";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.ratsclub ];
        };
      };

      antfu.icons-carbon = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "icons-carbon";
          publisher = "antfu";
          version = "0.2.6";
          sha256 = "sha256-R8eHLuebfgHaKtHPKBaaYybotluuH9WrUBpgyuIVOxc=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      antfu.slidev = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "antfu";
          name = "slidev";
          version = "0.4.1";
          sha256 = "sha256-MNQMOT9LaEVZqelvikBTpUPTsSIA2z5qvLxw51aJw1w=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      antyos.openscad = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "openscad";
          publisher = "Antyos";
          version = "1.1.1";
          sha256 = "1adcw9jj3npk3l6lnlfgji2l529c4s5xp9jl748r9naiy3w3dpjv";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/Antyos.openscad/changelog";
          description = "OpenSCAD highlighting, snippets, and more for VSCode";
          homepage = "https://github.com/Antyos/vscode-openscad";
          license = lib.licenses.gpl3;
        };
      };

      apollographql.vscode-apollo = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-apollo";
          publisher = "apollographql";
          version = "1.19.11";
          sha256 = "sha256-EixefDuJiw/p5yAR/UQLK1a1RXJLXlTmOlD34qpAN+U=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/apollographql.vscode-apollo/changelog";
          description = "Rich editor support for GraphQL client and server development that seamlessly integrates with the Apollo platform";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=apollographql.vscode-apollo";
          homepage = "https://github.com/apollographql/vscode-graphql";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.datafoo ];
        };
      };

      arcticicestudio.nord-visual-studio-code = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "nord-visual-studio-code";
          publisher = "arcticicestudio";
          version = "0.19.0";
          sha256 = "sha256-awbqFv6YuYI0tzM/QbHRTUl4B2vNUdy52F4nPmv+dRU=";
        };
        meta = {
          description = "An arctic, north-bluish clean and elegant Visual Studio Code theme.";
          downloadPage =
            "https://marketplace.visualstudio.com/items?itemName=arcticicestudio.nord-visual-studio-code";
          homepage = "https://github.com/arcticicestudio/nord-visual-studio-code";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.imgabe ];
        };
      };

      arjun.swagger-viewer = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "Arjun";
          name = "swagger-viewer";
          version = "3.1.2";
          sha256 = "1cjvc99x1q5w3i2vnbxrsl5a1dr9gb3s6s9lnwn6mq5db6iz1nlm";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      arrterian.nix-env-selector = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "nix-env-selector";
          publisher = "arrterian";
          version = "1.0.9";
          sha256 = "sha256-TkxqWZ8X+PAonzeXQ+sI9WI+XlqUHll7YyM7N9uErk0=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

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

        meta = {
          license = lib.licenses.mit;
        };
      };

      asdine.cue = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "cue";
          publisher = "asdine";
          version = "0.3.2";
          sha256 = "sha256-jMXqhgjRdM3UG/9NtiwWAg61mBW8OYVAKDWgb4hzhA4=";
        };
        meta = {
          description = "Cue language support for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=asdine.cue";
          homepage = "https://github.com/asdine/vscode-cue";
          changelog = "https://marketplace.visualstudio.com/items/asdine.cue/changelog";
          license = lib.licenses.mit;
          maintainers = [lib.maintainers.matthewpi];
        };
      };

      astro-build.astro-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "astro-vscode";
          publisher = "astro-build";
          version = "2.1.1";
          sha256 = "sha256-UVZOpkOHbLiwA4VfTgXxuIU8EtJLnqRa5zUVha6xQJY=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/astro-build.astro-vscode/changelog";
          description = "Astro language support for VSCode";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=astro-build.astro-vscode";
          homepage = "https://github.com/withastro/language-tools";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.wackbyte ];
        };
      };

      asvetliakov.vscode-neovim = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-neovim";
          publisher = "asvetliakov";
          version = "0.0.97";
          sha256 = "sha256-rNGW8WB3jBSjThiB0j4/ORKMRAaxFiMiBfaa+dbGu/w=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      attilabuti.brainfuck-syntax = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "brainfuck-syntax";
          publisher = "attilabuti";
          version = "0.0.1";
          sha256 = "sha256-ZcZlHoa2aoCeruMWbUUgfFHsPqyWmd2xFY6AKxJysYE=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/attilabuti.brainfuck-syntax/changelog";
          description = "VSCode extension providing syntax highlighting support for Brainfuck";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=attilabuti.brainfuck-syntax";
          homepage = "https://github.com/attilabuti/brainfuck-syntax";
          license = lib.licenses.mit;
          maintainers = [ ];
        };
      };

      azdavis.millet = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "Millet";
          publisher = "azdavis";
          version = "0.12.5";
          sha256 = "sha256-gJIxCdoxWGThalY+qJ930UtRLFkvr34LfaSioAZH9TQ=";
        };
        nativeBuildInputs = [ jq moreutils ];
        postInstall = ''
          cd "$out/$installPrefix"
          jq '.contributes.configuration.properties."millet.server.path".default = "${millet}/bin/millet-ls"' package.json | sponge package.json
        '';
        meta = {
          description = "Standard ML support for VS Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=azdavis.millet";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.smasher164 ];
        };
      };

      b4dm4n.vscode-nixpkgs-fmt = buildVscodeMarketplaceExtension {
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
        meta = {
          license = lib.licenses.mit;
        };
      };

      baccata.scaladex-search = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "scaladex-search";
          publisher = "baccata";
          version = "0.3.3";
          sha256 = "sha256-+793uA+cSBHV6t4wAM4j4GeWggLJTl2GENkn8RFIwr0=";
        };
        meta = {
          license = lib.licenses.asl20;
        };
      };

      badochov.ocaml-formatter = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "ocaml-formatter";
          publisher = "badochov";
          version = "2.0.5";
          sha256 = "sha256-D04EJButnam/l4aAv1yNbHlTKMb3x1yrS47+9XjpCLI=";
        };
        meta = {
          description = "VSCode Extension Formatter for OCaml language";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=badochov.ocaml-formatter";
          homepage = "https://github.com/badochov/ocamlformatter-vscode";
          license = lib.licenses.mit;
          maintainers = [ ];
        };
      };

      ban.spellright = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "ban";
          name = "spellright";
          version = "3.0.112";
          sha256 = "sha256-79Yg4I0OkfG7PaDYnTA8HK8jrSxre4FGriq0Baiq7wA=";
        };
        meta = {
          description = "A Visual Studio Code extension for Spellchecker";
          changelog = "https://marketplace.visualstudio.com/items/ban.spellright/changelog";
          homepage = "https://github.com/bartosz-antosik/vscode-spellright";
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [ onedragon ];
        };
      };

      batisteo.vscode-django = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "batisteo";
          name = "vscode-django";
          version = "1.10.0";
          sha256 = "sha256-vTaE3KhG5i2jGc5o33u76RUUFYaW4s4muHvph48HeQ4=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/batisteo.vscode-django/changelog";
          description = "Django extension for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=batisteo.vscode-django";
          homepage = "https://github.com/vscode-django/vscode-django";
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [ azd325 ];
        };
      };

      bbenoist.nix = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "Nix";
          publisher = "bbenoist";
          version = "1.0.1";
          sha256 = "0zd0n9f5z1f0ckzfjr38xw2zzmcxg1gjrava7yahg5cvdcw6l35b";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      benfradet.vscode-unison = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-unison";
          publisher = "benfradet";
          version = "0.4.0";
          sha256 = "sha256-IDM9v+LWckf20xnRTj+ThAFSzVxxDVQaJkwO37UIIhs=";
        };
        meta = {
          license = lib.licenses.asl20;
        };
      };

      betterthantomorrow.calva = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "calva";
          publisher = "betterthantomorrow";
          version = "2.0.374";
          sha256 = "sha256-VwdHOkduSSIrcOvrcVf7K8DSp3N1u9fvbaCVDCxp+bk=";
        };
        nativeBuildInputs = [ jq moreutils ];
        postInstall = ''
          cd "$out/$installPrefix"
          jq '.contributes.configuration[0].properties."calva.clojureLspPath".default = "${clojure-lsp}/bin/clojure-lsp"' package.json | sponge package.json
        '';
        meta = {
          license = lib.licenses.mit;
        };
      };

       bierner.docs-view = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "docs-view";
          publisher = "bierner";
          version = "0.0.11";
          sha256 = "sha256-3njIL2SWGFp87cvQEemABJk2nXzwI1Il/WG3E0ZYZxw=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/bierner.docs-view/changelog";
          description = "A VSCode extension that displays documentation in the sidebar or panel";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=bierner.docs-view";
          homepage = "https://github.com/mattbierner/vscode-docs-view#readme";
          license = lib.licenses.mit;
        };
      };

      bierner.emojisense = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "emojisense";
          publisher = "bierner";
          version = "0.9.1";
          sha256 = "sha256-bfhImi2qMHWkgKqkoStS0NtbXTfj6GpcLkI0PSMjuvg=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      bierner.markdown-checkbox = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "markdown-checkbox";
          publisher = "bierner";
          version = "0.4.0";
          sha256 = "sha256-AoPcdN/67WOzarnF+GIx/nans38Jan8Z5D0StBWIbkk=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      bierner.markdown-emoji = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "markdown-emoji";
          publisher = "bierner";
          version = "0.3.0";
          sha256 = "sha256-rw8/HeDA8kQuiPVDpeOGw1Mscd6vn4utw1Qznsd8lVI=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      bierner.markdown-mermaid = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "markdown-mermaid";
          publisher = "bierner";
          version = "1.17.7";
          sha256 = "sha256-WKe7XxBeYyzmjf/gnPH+5xNOHNhMPAKjtLorYyvT76U=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      bmalehorn.vscode-fish = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-fish";
          publisher = "bmalehorn";
          version = "1.0.35";
          sha256 = "sha256-V51Qe6M1CMm9fLOSFEwqeZiC8tWCbVH0AzkLe7kR2vY=";
        };
        meta.license = lib.licenses.mit;
      };

      bmewburn.vscode-intelephense-client = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-intelephense-client";
          publisher = "bmewburn";
          version = "1.9.5";
          sha256 = "sha256-KqWSQ+p5KqRVULwjoWuNE+lIEYkaUVkeOwMpXUxccqw=";
        };
        meta = {
          description = "PHP code intelligence for Visual Studio Code";
          license = lib.licenses.mit;
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=bmewburn.vscode-intelephense-client";
          maintainers = [ lib.maintainers.drupol ];
        };
      };

      bodil.file-browser = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "file-browser";
          publisher = "bodil";
          version = "0.2.11";
          sha256 = "sha256-yPVhhsAUZxnlhj58fXkk+yhxop2q7YJ6X4W9dXGKJfo=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      bradlc.vscode-tailwindcss = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-tailwindcss";
          publisher = "bradlc";
          version = "0.9.9";
          sha256 = "sha256-QyB6DtKe9KH2UizLZQfP4YlHz2yF8H9Ehj+M+OdIYe4=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      brandonkirbyson.solarized-palenight = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "solarized-palenight";
          publisher = "BrandonKirbyson";
          version = "1.0.1";
          sha256 = "sha256-vVbaHSaBX6QzpnYMQlpPsJU1TQYJEBe8jq95muzwN0o=";
        };
        meta = {
          description = " A solarized-palenight theme for vscode";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=BrandonKirbyson.solarized-palenight";
          homepage = "https://github.com/BrandonKirbyson/Solarized-Palenight";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.sebtm ];
        };
      };

      brettm12345.nixfmt-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "nixfmt-vscode";
          publisher = "brettm12345";
          version = "0.0.1";
          sha256 = "07w35c69vk1l6vipnq3qfack36qcszqxn8j3v332bl0w6m02aa7k";
        };
        meta = {
          license = lib.licenses.mpl20;
        };
      };

      bungcip.better-toml = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "better-toml";
          publisher = "bungcip";
          version = "0.3.2";
          sha256 = "sha256-g+LfgjAnSuSj/nSmlPdB0t29kqTmegZB5B1cYzP8kCI=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/bungcip.better-toml/changelog";
          description = "Better TOML Language support";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=bungcip.better-toml";
          homepage = "https://github.com/bungcip/better-toml/blob/master/README.md";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.datafoo ];
        };
      };

      catppuccin = {
        catppuccin-vsc = buildVscodeMarketplaceExtension {
          mktplcRef = {
            name = "catppuccin-vsc";
            publisher = "catppuccin";
            version = "2.6.1";
            sha256 = "sha256-B56b7PeuVnkxEqvd4vL9TYO7s8fuA+LOCTbJQD9e7wY=";
          };
          meta = {
            description = "Soothing pastel theme for VSCode";
            license = lib.licenses.mit;
            downloadPage = "https://marketplace.visualstudio.com/items?itemName=Catppuccin.catppuccin-vsc";
            maintainers = [ lib.maintainers.nullx76 ];
          };
        };
        catppuccin-vsc-icons = buildVscodeMarketplaceExtension {
          mktplcRef = {
            name = "catppuccin-vsc-icons";
            publisher = "catppuccin";
            version = "0.12.0";
            sha256 = "sha256-i47tY6DSVtV8Yf6AgZ6njqfhaUFGEpgbRcBF70l2Xe0=";
          };
          meta = {
            description = "Soothing pastel icon theme for VSCode";
            license = lib.licenses.mit;
            downloadPage = "https://marketplace.visualstudio.com/items?itemName=Catppuccin.catppuccin-vsc-icons";
            maintainers = [ lib.maintainers.laurent-f1z1 ];
          };
        };
      };

      charliermarsh.ruff = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "ruff";
          publisher = "charliermarsh";
          version = "2023.38.0";
          sha256 = "sha256-Gcw+X8e8MrTflotHUwkrdP/DD/6AX/kEgtRiqvqyqRM=";
        };
        meta = {
          license = lib.licenses.mit;
          changelog = "https://github.com/astral-sh/ruff-vscode/releases";
          description = "Ruff extension for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=charliermarsh.ruff";
          homepage = "https://github.com/astral-sh/ruff-vscode/";
          maintainers = [ lib.maintainers.azd325 ];
        };
      };

      chenglou92.rescript-vscode = callPackage ./chenglou92.rescript-vscode { };

      chris-hayes.chatgpt-reborn = buildVscodeMarketplaceExtension {
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/chris-hayes.chatgpt-reborn/changelog";
          description = "A Visual Studio Code extension to support ChatGPT, GPT-3 and Codex conversations";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=chris-hayes.chatgpt-reborn";
          homepage = "https://github.com/christopher-hayes/vscode-chatgpt-reborn";
          license = lib.licenses.isc;
          maintainers = [ lib.maintainers.drupol ];
        };
        mktplcRef = {
          name = "chatgpt-reborn";
          publisher = "chris-hayes";
          version = "3.16.3";
          sha256 = "wkitG5gmYKYKXRw/zVW04HN1dePiTjbnynFOY/bwxfI=";
        };
      };

      christian-kohler.path-intellisense = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "path-intellisense";
          publisher = "christian-kohler";
          version = "2.8.4";
          sha256 = "sha256-FEBYcjJHOwmxVHhhyxqOpk/V6hvtMkhkvLVpmJCMSZw=";
        };
        meta = {
          description = "Visual Studio Code plugin that autocompletes filenames";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=christian-kohler.path-intellisense";
          homepage = "https://github.com/ChristianKohler/PathIntellisense";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.imgabe ];
        };
      };

      cmschuetz12.wal = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "wal";
          publisher = "cmschuetz12";
          version = "0.1.0";
          sha256 = "0q089jnzqzhjfnv0vlb5kf747s3mgz64r7q3zscl66zb2pz5q4zd";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      coder.coder-remote = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "coder-remote";
          publisher = "coder";
          version = "0.1.18";
          sha256 = "soNGZuyvG5+haWRcwYmYB+0OcyDAm4UQ419UnEd8waA=";
        };
        meta = {
          description = "An extension for Visual Studio Code to open any Coder workspace in VS Code with a single click.";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=coder.coder-remote";
          homepage = "https://github.com/coder/vscode-coder";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.drupol ];
        };
      };

      codezombiech.gitignore = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "gitignore";
          publisher = "codezombiech";
          version = "0.9.0";
          sha256 = "sha256-IHoF+c8Rsi6WnXoCX7x3wKyuMwLh14nbL9sNVJHogHM=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      w88975.code-translate = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "code-translate";
          publisher = "w88975";
          version = "1.0.20";
          sha256 = "sha256-blqLK7S+RmEoyr9zktS5/SNC0GeSXnNpbhltyajoAfw=";
        };
        meta = {
          description = "A Visual Studio Code extension to provide purely hover translation";
          longDescription = ''
            Code Translate is a purely hover translation extension
            - Non-intrusive display of translation results: perfectly integrated with VS Code code analysis.
            - Powerful word splitting capabilities: supports various forms of word splitting such as camel case and underscore.
            - Rich local vocabulary: includes 3.4+ million offline words, supporting various rare words.
            - Based on a rich local vocabulary: Code Translate has super-fast query speed, with each word typically queried in less than 10ms.
            - Multi-platform support: supports both the desktop version and online version of VS Code, and the plugin can be used on both versions.
          '';
          homepage = "https://github.com/w88975/code-translate-vscode";
          changelog = "https://marketplace.visualstudio.com/items/w88975.code-translate/changelog";
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [ onedragon ];
        };
      };

      colejcummins.llvm-syntax-highlighting = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "llvm-syntax-highlighting";
          publisher = "colejcummins";
          version = "0.0.3";
          sha256 = "sha256-D5zLp3ruq0F9UFT9emgOBDLr1tya2Vw52VvCc40TtV0=";
        };
        meta = {
          description = "Lightweight syntax highlighting for LLVM IR";
          homepage = "https://github.com/colejcummins/llvm-syntax-highlighting";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=colejcummins.llvm-syntax-highlighting";
          maintainers = [ lib.maintainers.inclyc ];
          license = lib.licenses.mit;
        };
      };

      contextmapper.context-mapper-vscode-extension = callPackage ./contextmapper.context-mapper-vscode-extension { };

      coolbear.systemd-unit-file = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "coolbear";
          name = "systemd-unit-file";
          version = "1.0.6";
          sha256 = "0sc0zsdnxi4wfdlmaqwb6k2qc21dgwx6ipvri36x7agk7m8m4736";
        };
        meta = {
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.kamadorueda ];
        };
      };

      cweijan.vscode-database-client2 = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-database-client2";
          publisher = "cweijan";
          version = "6.3.0";
          sha256 = "sha256-BFTY3NZQd6XTE3UNO1bWo/LiM4sHujFGOSufDLD4mzM=";
        };
        meta = {
          description = "Database Client For Visual Studio Code";
          homepage = "https://marketplace.visualstudio.com/items?itemName=cweijan.vscode-mysql-client2";
          license = lib.licenses.mit;
        };
      };

      daohong-emilio.yash = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "daohong-emilio";
          name = "yash";
          version = "0.2.9";
          sha256 = "sha256-5JX6Z7xVPoqGjD1/ySc9ObD14O1sWDpvBj9VbtGO1Cg=";
        };
        meta = {
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.kamadorueda ];
        };
      };

      dart-code.dart-code = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "dart-code";
          publisher = "dart-code";
          version = "3.61.20230324";
          sha256 = "sha256-VVQ32heyzLjM5HdeNAK5PwqB1NsSQ9iQJBwJiJXlu+g=";
        };

        meta.license = lib.licenses.mit;
      };

      dart-code.flutter = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "flutter";
          publisher = "dart-code";
          version = "3.61.20230301";
          sha256 = "sha256-t4AfFgxVCl15YOz7NTULvNUcyuiQilEP6jPK4zMAAmc=";
        };

        meta.license = lib.licenses.mit;
      };

      davidanson.vscode-markdownlint = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-markdownlint";
          publisher = "DavidAnson";
          version = "0.51.0";
          sha256 = "sha256-Xtr8cqcPrcrKpJBxQcY1j9Gl4CC6U3ZazS4bdBtdzUk=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/DavidAnson.vscode-markdownlint/changelog";
          description = "Markdown linting and style checking for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint";
          homepage = "https://github.com/DavidAnson/vscode-markdownlint";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.datafoo ];
        };
      };

      davidlday.languagetool-linter = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "languagetool-linter";
          publisher = "davidlday";
          version = "0.19.0";
          sha256 = "sha256-crq6CTXpzwHJL8FPIBneAGjDgUUNdpBt6rIaMCr1F1U=";
        };
        meta = {
          description = "LanguageTool integration for VS Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=davidlday.languagetool-linter";
          homepage = "https://github.com/davidlday/vscode-languagetool-linter";
          license = lib.licenses.asl20;
          maintainers = [ lib.maintainers.ebbertd ];
        };
      };

      dbaeumer.vscode-eslint = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-eslint";
          publisher = "dbaeumer";
          version = "2.4.2";
          sha256 = "sha256-eIjaiVQ7PNJUtOiZlM+lw6VmW07FbMWPtY7UoedWtbw=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/dbaeumer.vscode-eslint/changelog";
          description = "Integrates ESLint JavaScript into VS Code.";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=dbaeumer.vscode-eslint";
          homepage = "https://github.com/Microsoft/vscode-eslint";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.datafoo ];
        };
      };

      denoland.vscode-deno = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-deno";
          publisher = "denoland";
          version = "3.17.0";
          sha256 = "sha256-ETwpUrYbPXHSkEBq2oM1aCBwt9ItLcXMYc3YWjHLiJE=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/denoland.vscode-deno/changelog";
          description = "A language server client for Deno";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=denoland.vscode-deno";
          homepage = "https://github.com/denoland/vscode_deno";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.ratsclub ];
        };
      };

      devsense.composer-php-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "composer-php-vscode";
          publisher = "devsense";
          version = "1.36.13428";
          sha256 = "sha256-dzRuD0XBWU+xUtr86eN8zbZ6bVIq1BP0/EqgQG4JbvY=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/DEVSENSE.composer-php-vscode/changelog";
          description = "A visual studio code extension for full development integration for Composer, the PHP package manager.";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=DEVSENSE.composer-php-vscode";
          homepage = "https://github.com/DEVSENSE/phptools-docs";
          license = lib.licenses.asl20;
          maintainers = [ lib.maintainers.drupol ];
        };
      };

      devsense.phptools-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = let
          sources = {
            "x86_64-linux" = {
              arch = "linux-x64";
              sha256 = "sha256-x4Vsr/79vZuNPGQqwOVdIMi2Ba9DfnKM1AjxCZbzJms=";
            };
            "x86_64-darwin" = {
              arch = "darwin-x64";
              sha256 = "0c9jcjavkjiv92cd4wrvgcv70igghi5ha96hg7h63cgmxg7b87gk";
            };
            "aarch64-linux" = {
              arch = "linux-arm64";
              sha256 = "0b3w3ssxymf9p1h4amnqimbsjf1wpxsi55b05wgqwh2w2zfxd91l";
            };
            "aarch64-darwin" = {
              arch = "darwin-arm64";
              sha256 = "0mdqa9w1p6cmli6976v4wi0sw9r4p5prkj7lzfd1877wk11c9c73";
            };
          };
        in {
          name = "phptools-vscode";
          publisher = "devsense";
          version = "1.36.13428";
        } // sources.${stdenv.system};

        nativeBuildInputs = [
          autoPatchelfHook
        ];

        buildInputs = [
          zlib
          stdenv.cc.cc.lib
        ];

        postInstall = ''
          chmod +x $out/share/vscode/extensions/devsense.phptools-vscode/out/server/devsense.php.ls
        '';

        meta = {
          changelog = "https://marketplace.visualstudio.com/items/DEVSENSE.phptools-vscode/changelog";
          description = "A visual studio code extension for full development integration for the PHP language.";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=DEVSENSE.phptools-vscode";
          homepage = "https://github.com/DEVSENSE/phptools-docs";
          license = lib.licenses.asl20;
          maintainers = [ lib.maintainers.drupol ];
          platforms = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" "aarch64-linux" ];
        };
      };

      devsense.profiler-php-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "profiler-php-vscode";
          publisher = "devsense";
          version = "1.36.13428";
          sha256 = "sha256-/CT83LdQkEvsWrQX30bgnklgGKduYC0LqZ8gaexqu60=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/DEVSENSE.profiler-php-vscode/changelog";
          description = "A visual studio code extension for PHP and XDebug profiling and inspecting.";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=DEVSENSE.profiler-php-vscode";
          homepage = "https://github.com/DEVSENSE/phptools-docs";
          license = lib.licenses.asl20;
          maintainers = [ lib.maintainers.drupol ];
        };
      };

      dhall.dhall-lang = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "dhall-lang";
          publisher = "dhall";
          version = "0.0.4";
          sha256 = "0sa04srhqmngmw71slnrapi2xay0arj42j4gkan8i11n7bfi1xpf";
        };
        meta = { license = lib.licenses.mit; };
      };

      dhall.vscode-dhall-lsp-server = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-dhall-lsp-server";
          publisher = "dhall";
          version = "0.0.4";
          sha256 = "1zin7s827bpf9yvzpxpr5n6mv0b5rhh3civsqzmj52mdq365d2js";
        };
        meta = { license = lib.licenses.mit; };
      };

      disneystreaming.smithy = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "disneystreaming";
          name = "smithy";
          version = "0.0.8";
          sha256 = "sha256-BQPiSxiPPjdNPtIJI8L+558DVKxngPAI9sscpcJSJUI=";
        };
        meta = { license = lib.licenses.asl20; };
      };

      divyanshuagrawal.competitive-programming-helper = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "competitive-programming-helper";
          publisher = "DivyanshuAgrawal";
          version = "5.10.0";
          sha256 = "sha256-KALTldVaptKt8k2Y6PMqhJEMrayB4yn86x2CxHn6Ba0=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/DivyanshuAgrawal.competitive-programming-helper/changelog";
          description = "Makes judging, compiling, and downloading problems for competitve programming easy. Also supports auto-submit for a few sites.";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=DivyanshuAgrawal.competitive-programming-helper";
          homepage = "https://github.com/agrawal-d/cph";
          license = lib.licenses.gpl3;
          maintainers = [ lib.maintainers.arcticlimer ];
        };
      };

      donjayamanne.githistory = buildVscodeMarketplaceExtension {
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/donjayamanne.githistory/changelog";
          description = "View git log, file history, compare branches or commits";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=donjayamanne.githistory";
          homepage = "https://github.com/DonJayamanne/gitHistoryVSCode/";
          license = lib.licenses.mit;
          maintainers = [ ];
        };
        mktplcRef = {
          name = "githistory";
          publisher = "donjayamanne";
          version = "0.6.20";
          sha256 = "sha256-nEdYS9/cMS4dcbFje23a47QBZr9eDK3dvtkFWqA+OHU=";
        };
      };

      dotenv.dotenv-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "dotenv-vscode";
          publisher = "dotenv";
          version = "0.28.0";
          sha256 = "sha256-KiQgFvbfLsA/ADROoG6y6c/i0XHuTNH2AN+6mWEm0P8=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/dotenv.dotenv-vscode/changelog";
          description = "Official Dotenv extension for VSCode. Offers syntax highlighting, auto-cloaking, auto-completion, in-code secret peeking, and optionally dotenv-vault";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=dotenv.dotenv-vscode";
          homepage = "https://github.com/dotenv-org/dotenv-vscode";
          license = lib.licenses.mit;
        };
      };

      dotjoshjohnson.xml = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "xml";
          publisher = "dotjoshjohnson";
          version = "2.5.1";
          sha256 = "1v4x6yhzny1f8f4jzm4g7vqmqg5bqchyx4n25mkgvw2xp6yls037";
        };
        meta = {
          description = "XML Tools";
          homepage = "https://github.com/DotJoshJohnson/vscode-xml";
          license = lib.licenses.mit;
        };
      };

      dracula-theme.theme-dracula = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "theme-dracula";
          publisher = "dracula-theme";
          version = "2.24.2";
          sha256 = "sha256-YNqWEIvlEI29mfPxOQVdd4db9G2qNodhz8B0MCAAWK8=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/dracula-theme.theme-dracula/changelog";
          description = "Dark theme for many editors, shells, and more";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=dracula-theme.theme-dracula";
          homepage = "https://draculatheme.com/";
          license = lib.licenses.mit;
        };
      };

      eamodio.gitlens = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "gitlens";
          publisher = "eamodio";
          # Stable versions are listed on the GitHub releases page and use a
          # semver scheme, contrary to preview versions which are listed on
          # the VSCode Marketplace and use a calver scheme. We should avoid
          # using preview versions, because they expire after two weeks.
          version = "14.1.1";
          sha256 = "sha256-eSN48IudpHYzT4u+S4b2I2pyEPyOwBCSL49awT/mzEE=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/eamodio.gitlens/changelog";
          description = "GitLens supercharges the Git capabilities built into Visual Studio Code.";
          longDescription = ''
            Supercharge the Git capabilities built into Visual Studio Code — Visualize code authorship at a glance via Git
            blame annotations and code lens, seamlessly navigate and explore Git repositories, gain valuable insights via
            powerful comparison commands, and so much more
          '';
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens";
          homepage = "https://gitlens.amod.io/";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.ratsclub ];
        };
      };

      editorconfig.editorconfig = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "EditorConfig";
          publisher = "EditorConfig";
          version = "0.16.4";
          sha256 = "0fa4h9hk1xq6j3zfxvf483sbb4bd17fjl5cdm3rll7z9kaigdqwg";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/EditorConfig.EditorConfig/changelog";
          description = "EditorConfig Support for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig";
          homepage = "https://github.com/editorconfig/editorconfig-vscode";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.dbirks ];
        };
      };

      edonet.vscode-command-runner = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-command-runner";
          publisher = "edonet";
          version = "0.0.123";
          sha256 = "sha256-Fq0KgW5N6urj8hMUs6Spidy47jwIkpkmBUlpXMVnq7s=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      eg2.vscode-npm-script = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-npm-script";
          publisher = "eg2";
          version = "0.3.29";
          sha256 = "sha256-k6DtmhYBj7mg8SUU3pg+ezRzWvhiECqYQVj9LDhhV4I=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      elixir-lsp.vscode-elixir-ls = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "elixir-ls";
          publisher = "JakeBecker";
          version = "0.16.0";
          sha256 = "sha256-PZUyOZ/U6OkGid+PYY2G/pAe5R5eumUibKNel9HBI+s=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/JakeBecker.elixir-ls/changelog";
          description = "Elixir support with debugger, autocomplete, and more. Powered by ElixirLS.";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=JakeBecker.elixir-ls";
          homepage = "https://github.com/elixir-lsp/elixir-ls";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.datafoo ];
        };
      };

      elmtooling.elm-ls-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "elm-ls-vscode";
          publisher = "Elmtooling";
          version = "2.6.0";
          sha256 = "sha256-iNFc7YJFl3d4/BJE9TPJfL0iqEkUtyEyVt4v1J2bXts=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/Elmtooling.elm-ls-vscode/changelog";
          description = "Elm language server";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=Elmtooling.elm-ls-vscode";
          homepage = "https://github.com/elm-tooling/elm-language-client-vscode";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.mcwitt ];
        };
      };

      emmanuelbeziat.vscode-great-icons = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-great-icons";
          publisher = "emmanuelbeziat";
          version = "2.1.92";
          sha256 = "sha256-cywFx33oTQZxFUxL9qCpV12pV2tP0ujR4osCdtSOOTc=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      emroussel.atomize-atom-one-dark-theme = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "atomize-atom-one-dark-theme";
          publisher = "emroussel";
          version = "2.0.2";
          sha256 = "sha256-GwuFtBVj0Z2rHryst/7cegskvZIMPsrAH12+K942+JA=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/emroussel.atomize-atom-one-dark-theme/changelog";
          description = "A detailed and accurate Atom One Dark theme for VSCode";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=emroussel.atomize-atom-one-dark-theme";
          homepage = "https://github.com/emroussel/atomize/blob/main/README.md";
          license = lib.licenses.mit;
        };
      };

      enkia.tokyo-night = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "tokyo-night";
          publisher = "enkia";
          version = "1.0.0";
          sha256 = "sha256-/fM+aUDUzVJ6P38i+GrxhLv2eLJNa8OFkKsM4yPBy4c=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/enkia.tokyo-night/changelog";
          description = "A clean Visual Studio Code theme that celebrates the lights of Downtown Tokyo at night";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=enkia.tokyo-night";
          homepage = "https://github.com/enkia/tokyo-night-vscode-theme";
          license = lib.licenses.mit;
        };
      };

      equinusocio.vsc-material-theme = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vsc-material-theme";
          publisher = "Equinusocio";
          version = "33.8.0";
          sha256 = "sha256-+I4AUwsrElT62XNvmuAC2iBfHfjNYY0bmAqzQvfwUYM=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/Equinusocio.vsc-material-theme/changelog";
          description = "The most epic theme now for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=Equinusocio.vsc-material-theme";
          homepage = "https://github.com/material-theme/vsc-material-theme";
          license = lib.licenses.asl20;
          maintainers = [ lib.maintainers.stunkymonkey ];
        };
      };

      esbenp.prettier-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "prettier-vscode";
          publisher = "esbenp";
          version = "10.1.0";
          sha256 = "sha256-SQuf15Jq84MKBVqK6UviK04uo7gQw9yuw/WEBEXcQAc=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/esbenp.prettier-vscode/changelog";
          description = "Code formatter using prettier";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode";
          homepage = "https://github.com/prettier/prettier-vscode";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.datafoo ];
        };
      };

      ethansk.restore-terminals = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "restore-terminals";
          publisher = "ethansk";
          version = "1.1.8";
          sha256 = "sha256-pZK/QNomQoFRsL6LRIKvWQj8/SYo2ZdVU47Gsmb9MXo=";
        };
      };

      eugleo.magic-racket = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "magic-racket";
          publisher = "evzen-wybitul";
          version = "0.6.4";
          sha256 = "sha256-Hxa4VPm3QvJICzpDyfk94fGHu1hr+YN9szVBwDB8X4U=";
        };
        nativeBuildInputs = [ jq moreutils ];
        postInstall = ''
          cd "$out/$installPrefix"
          jq '.contributes.configuration.properties."magicRacket.general.racketPath".default = "${racket}/bin/racket"' package.json | sponge package.json
          jq '.contributes.configuration.properties."magicRacket.general.racoPath".default = "${racket}/bin/raco"' package.json | sponge package.json
        '';
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/evzen-wybitul.magic-racket/changelog";
          description = "The best coding experience for Racket in VS Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=evzen-wybitul.magic-racket";
          homepage = "https://github.com/Eugleo/magic-racket";
          license = lib.licenses.agpl3Only;
        };
      };

      ExiaHuang.dictionary = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "ExiaHuang";
          name = "dictionary";
          version = "0.0.2";
          sha256 = "sha256-caNcbDTB/F2mdlGpfIfJv13lzY5Wwj7p7r8dAte9+3A=";
        };
        meta = {
          description = "A Visual Studio Code extension of using chinese-english dictonary in right-click menu";
          homepage = "https://github.com/exiahuang/fanyi-vscode";
          changelog = "https://marketplace.visualstudio.com/items/ExiaHuang.dictionary/changelog";
          license = lib.licenses.gpl3Only;
          maintainers = with lib.maintainers; [ onedragon ];
        };
      };

      file-icons.file-icons = buildVscodeMarketplaceExtension {
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/file-icons.file-icons/changelog";
          description = "File-specific icons in VSCode for improved visual grepping.";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=file-icons.file-icons";
          homepage = "https://github.com/file-icons/vscode";
          license = lib.licenses.mit;
          maintainers = [ ];
        };
        mktplcRef = {
          name = "file-icons";
          publisher = "file-icons";
          version = "1.0.29";
          sha256 = "05x45f9yaivsz8a1ahlv5m8gy2kkz71850dhdvwmgii0vljc8jc6";
        };
      };

      firefox-devtools.vscode-firefox-debug = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-firefox-debug";
          publisher = "firefox-devtools";
          version = "2.9.8";
          sha256 = "sha256-MCL562FPgEfhUM1KH5LMl7BblbjIkQ4UEwB67RlO5Mk=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/firefox-devtools.vscode-firefox-debug/changelog";
          description = "A Visual Studio Code extension for debugging web applications and browser extensions in Firefox";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=firefox-devtools.vscode-firefox-debug";
          homepage = "https://github.com/firefox-devtools/vscode-firefox-debug";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.felschr ];
        };
      };

      foam.foam-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "foam-vscode";
          publisher = "foam";
          version = "0.21.1";
          sha256 = "sha256-Ff1g+Qu4nUGR3g5PqOwP7W6S+3jje9gz1HK8J0+B65w=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/foam.foam-vscode/changelog";
          description = "A personal knowledge management and sharing system for VSCode ";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=foam.foam-vscode";
          homepage = "https://foambubble.github.io/";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.ratsclub ];
        };
      };

      formulahendry.auto-close-tag = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "auto-close-tag";
          publisher = "formulahendry";
          version = "0.5.14";
          sha256 = "sha256-XYYHS2QTy8WYjtUYYWsIESzmH4dRQLlXQpJq78BolMw=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      formulahendry.auto-rename-tag = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "auto-rename-tag";
          publisher = "formulahendry";
          version = "0.1.10";
          sha256 = "sha256-uXqWebxnDwaUVLFG6MUh4bZ7jw5d2rTHRm5NoR2n0Vs=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      formulahendry.code-runner = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "code-runner";
          publisher = "formulahendry";
          version = "0.12.0";
          sha256 = "sha256-Q2gcuclG7NLR81HjKj/0RF0jM5Eqe2vZMbpoabp/osg=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      foxundermoon.shell-format = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "shell-format";
          publisher = "foxundermoon";
          version = "7.1.0";
          sha256 = "09z72mdr5bfdcb67xyzlv7lb9vyjlc3k9ackj4jgixfk40c68cnj";
        };

        nativeBuildInputs = [ jq moreutils ];

        postInstall = ''
          cd "$out/$installPrefix"
          jq '.contributes.configuration.properties."shellformat.path".default = "${shfmt}/bin/shfmt"' package.json | sponge package.json
        '';

        meta = {
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=foxundermoon.shell-format";
          homepage = "https://github.com/foxundermoon/vs-shell-format";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.dbirks ];
        };
      };

      freebroccolo.reasonml = buildVscodeMarketplaceExtension {
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/freebroccolo.reasonml/changelog";
          description = "Reason support for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=freebroccolo.reasonml";
          homepage = "https://github.com/reasonml-editor/vscode-reasonml";
          license = lib.licenses.asl20;
          maintainers = [ ];
        };
        mktplcRef = {
          name = "reasonml";
          publisher = "freebroccolo";
          version = "1.0.38";
          sha256 = "1nay6qs9vcxd85ra4bv93gg3aqg3r2wmcnqmcsy9n8pg1ds1vngd";
        };
      };

      funkyremi.vscode-google-translate = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "funkyremi";
          name = "vscode-google-translate";
          version = "1.4.13";
          sha256 = "sha256-9Vo6lwqD1eE3zY0Gi9ME/6lPwmwuJ3Iq9StHPvncnM4=";
        };
        meta = {
          description = "A Visual Studio Code extension using google translation to helping you quickly translate text right in your code rocket";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=funkyremi.vscode-google-translate";
          homepage = "https://github.com/funkyremi/vscode-google-translate.git";
          changelog = "https://marketplace.visualstudio.com/items/funkyremi.vscode-google-translate/changelog";
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [ onedragon ];
        };
      };

      gencer.html-slim-scss-css-class-completion = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "html-slim-scss-css-class-completion";
          publisher = "gencer";
          version = "1.7.8";
          sha256 = "18qws35qvnl0ahk5sxh4mzkw0ib788y1l97ijmpjszs0cd4bfsa6";
        };
        meta = {
          description = "VSCode extension for SCSS";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=gencer.html-slim-scss-css-class-completion";
          homepage = "https://github.com/gencer/SCSS-Everywhere";
          license = lib.licenses.mit;
          maintainers = [ ];
        };
      };

      genieai.chatgpt-vscode = buildVscodeMarketplaceExtension {
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/genieai.chatgpt-vscode/changelog";
          description = "A Visual Studio Code extension to support ChatGPT, GPT-3 and Codex conversations";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=genieai.chatgpt-vscode";
          homepage = "https://github.com/ai-genie/chatgpt-vscode";
          license = lib.licenses.isc;
          maintainers = [ lib.maintainers.drupol ];
        };
        mktplcRef = {
          name = "chatgpt-vscode";
          publisher = "genieai";
          version = "0.0.8";
          sha256 = "RKvmZkegFs4y+sEVaamPRO1F1E+k4jJyI0Q9XqKowrQ=";
        };
      };

      github.codespaces = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "github";
          name = "codespaces";
          version = "1.14.8";
          sha256 = "sha256-kCgnOODT1KDi9PMWs3CATXESWoHnDRhCIZhEUSkm14o=";
        };
        meta = { license = lib.licenses.unfree; };
      };

      github.copilot = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "github";
          name = "copilot";
          version = "1.89.156";
          sha256 = "sha256-BJnYd9D3bWrZI8UETnAua8ngVjZJ7EXB1UrZAjVnx1E=";
        };
        meta = {
          description = "GitHub Copilot uses OpenAI Codex to suggest code and entire functions in real-time right from your editor.";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=GitHub.copilot";
          homepage = "https://github.com/features/copilot";
          license = lib.licenses.unfree;
          maintainers = [ lib.maintainers.Zimmi48 ];
        };
      };

      github.copilot-chat = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "github";
          name = "copilot-chat";
          version = "0.3.2023061502";
          sha256 = "sha256-sUoKwlPDMz+iQbmIsD2JhyDwmUQzOyCHXaXCUaizQ7k=";
        };
        meta = {
          description = "GitHub Copilot Chat is a companion extension to GitHub Copilot that houses experimental chat features";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=GitHub.copilot-chat";
          homepage = "https://github.com/features/copilot";
          license = lib.licenses.unfree;
          maintainers = [ lib.maintainers.laurent-f1z1 ];
        };
      };

      github.github-vscode-theme = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "github-vscode-theme";
          publisher = "github";
          version = "6.3.4";
          sha256 = "sha256-JbI0B7jxt/2pNg/hMjAE5pBBa3LbUdi+GF0iEZUDUDM=";
        };
        meta = {
          description = "GitHub theme for VS Code";
          downloadPage =
            "https://marketplace.visualstudio.com/items?itemName=GitHub.github-vscode-theme";
          homepage = "https://github.com/primer/github-vscode-theme";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.hugolgst ];
        };
      };

      github.vscode-github-actions = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-github-actions";
          publisher = "github";
          version = "0.25.6";
          sha256 = "sha256-HRj/AQI9E6HDkZ2ok/h/+c9HHq1wVXQPAt5mb/Ij+BI=";
        };
        meta = {
          description = "A Visual Studio Code extension for GitHub Actions workflows and runs for github.com hosted repositories";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=github.vscode-github-actions";
          homepage = "https://github.com/github/vscode-github-actions";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.drupol ];
        };
      };

      github.vscode-pull-request-github = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-pull-request-github";
          publisher = "github";
          # Stable versions are listed on the GitHub releases page and use a
          # semver scheme, contrary to preview versions which are listed on
          # the VSCode Marketplace and use a calver scheme. We should avoid
          # using preview versions, because they can require insider versions
          # of VS Code
          version = "0.68.1";
          sha256 = "sha256-d60ZxWQLZa2skOB3Iv9K04aGNZA1d1A82N7zRaxAzlI=";
        };
        meta = { license = lib.licenses.mit; };
      };

      gitlab.gitlab-workflow = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "gitlab-workflow";
          publisher = "gitlab";
          version = "3.60.0";
          sha256 = "sha256-rH0+6sQfBfI8SrKY9GGtTOONdzKus6Z62E8Qv5xY7Fw=";
        };
        meta = {
          description = "GitLab extension for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=gitlab.gitlab-workflow";
          homepage = "https://gitlab.com/gitlab-org/gitlab-vscode-extension#readme";
          license = lib.licenses.mit;
          maintainers = [ ];
        };
      };

      gleam.gleam = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "gleam";
          publisher = "gleam";
          version = "2.3.0";
          sha256 = "sha256-dhRS8fLKY0plRwnrAUWT4g/LfH6IpODTNhT79g4Nm+0=";
        };
        meta = {
          description = "Support for the Gleam programming language";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=Gleam.gleam";
          homepage = "https://github.com/gleam-lang/vscode-gleam#readme";
          license = lib.licenses.asl20;
          maintainers = [ lib.maintainers.msfjarvis ];
        };
      };

      golang.go = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "Go";
          publisher = "golang";
          version = "0.38.0";
          sha256 = "sha256-wOWouVz4mE4BzmgQOLQyVWsMadMqeUkFWHnruxStU0Q=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      grapecity.gc-excelviewer = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "gc-excelviewer";
          publisher = "grapecity";
          version = "4.2.56";
          sha256 = "sha256-lrKkxaqPDouWzDP1uUE4Rgt9mI61jUOi/xZ85A0mnrk=";
        };
        meta = {
          description = "Edit Excel spreadsheets and CSV files in Visual Studio Code and VS Code for the Web";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=grapecity.gc-excelviewer";
          homepage = "https://github.com/jjuback/gc-excelviewer";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.kamadorueda ];
        };
      };

      graphql.vscode-graphql = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-graphql";
          publisher = "GraphQL";
          version = "0.8.7";
          sha256 = "sha256-u3VcpgLKiEeUr1I6w71wleKyaO6v0gmHiw5Ama6fv88=";
        };
        meta = {
          description = "GraphQL extension for VSCode built with the aim to tightly integrate the GraphQL Ecosystem with VSCode for an awesome developer experience.";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=GraphQL.vscode-graphql";
          homepage = "https://github.com/graphql/graphiql/tree/main/packages/vscode-graphql";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.Enzime ];
        };
      };

      graphql.vscode-graphql-syntax = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-graphql-syntax";
          publisher = "GraphQL";
          version = "1.1.0";
          sha256 = "sha256-qazU0UyZ9de6Huj2AYZqqBo4jVW/ZQmFJhV7XXAblxo=";
        };
        meta = {
          description = "Adds full GraphQL syntax highlighting and language support such as bracket matching.";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=GraphQL.vscode-graphql-syntax";
          homepage = "https://github.com/graphql/graphiql/tree/main/packages/vscode-graphql-syntax";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.Enzime ];
        };
      };

      gruntfuggly.todo-tree = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "todo-tree";
          publisher = "Gruntfuggly";
          version = "0.0.226";
          sha256 = "sha256-Fj9cw+VJ2jkTGUclB1TLvURhzQsaryFQs/+f2RZOLHs=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      hashicorp.terraform = callPackage ./hashicorp.terraform { };

      haskell.haskell = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "haskell";
          publisher = "haskell";
          version = "2.2.2";
          sha256 = "sha256-zWdIVdz+kZg7KZQ7LeBCB4aB9wg8dUbkWfzGlM0Fq7Q=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      hookyqr.beautify = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "beautify";
          publisher = "HookyQR";
          version = "1.5.0";
          sha256 = "1c0kfavdwgwham92xrh0gnyxkrl9qlkpv39l1yhrldn8vd10fj5i";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      humao.rest-client = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "humao";
          name = "rest-client";
          version = "0.25.1";
          sha256 = "sha256-DSzZ9wGB0IVK8gYOzLLbT03WX3xSmR/IUVZkDzcczKc=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ibm.output-colorizer = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "output-colorizer";
          publisher = "IBM";
          version = "0.1.2";
          sha256 = "0i9kpnlk3naycc7k8gmcxas3s06d67wxr3nnyv5hxmsnsx5sfvb7";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      iciclesoft.workspacesort = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "workspacesort";
          publisher = "iciclesoft";
          version = "1.6.2";
          sha256 = "sha256-ZsjBgoTr4LGQW0kn+CtbdLwpPHmlYl5LKhwXIzcPe2o=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/iciclesoft.workspacesort/changelog";
          description = "Sort workspace-folders alphabetically rather than in chronological order";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=iciclesoft.workspacesort";
          homepage = "https://github.com/iciclesoft/workspacesort-for-VSCode";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.dbirks ];
        };
      };

      influxdata.flux = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "influxdata";
          name = "flux";
          version = "1.0.4";
          sha256 = "sha256-KIKROyfkosBS1Resgl+s3VENVg4ibaeIgKjermXESoA=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      intellsmi.comment-translate = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "intellsmi";
          name = "comment-translate";
          version = "2.2.4";
          sha256 = "sha256-g6mlScxv8opZuqgWtTJ3k0Yo7W7WzIkwB+8lWf6cMiU=";
        };
        meta = {
          description = "A Visual Studio Code extension to translate the comments for computer language";
          longDescription = ''
            This plugin uses the Google Translate API to translate comments for the VSCode programming language.
          '';
          homepage = "https://github.com/intellism/vscode-comment-translate/blob/HEAD/doc/README.md";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=intellsmi.comment-translate";
          changelog = "https://marketplace.visualstudio.com/items/intellsmi.comment-translate/changelog";
          maintainers = with lib.maintainers; [ onedragon ];
          license = lib.licenses.mit;
        };
      };

      ionide.ionide-fsharp = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "Ionide-fsharp";
          publisher = "Ionide";
          version = "7.5.4";
          sha256 = "sha256-cM3ssUzQnqt5WL8UaLYkrmfHscVa2sGa7/UWLXMIHGg=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/Ionide.Ionide-fsharp/changelog";
          description = "Enhanced F# Language Features for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=Ionide.Ionide-fsharp";
          homepage = "https://ionide.io";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.ratsclub ];
        };
      };

      irongeek.vscode-env = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-env";
          publisher = "irongeek";
          version = "0.1.0";
          sha256 = "sha256-URq90lOFtPCNfSIl2NUwihwRQyqgDysGmBc3NG7o7vk=";
        };
        meta = {
          description = "Adds formatting and syntax highlighting support for env files (.env) to Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=IronGeek.vscode-env";
          homepage = "https://github.com/IronGeek/vscode-env.git";
          license = lib.licenses.mit;
          maintainers = [ ];
        };
      };

      james-yu.latex-workshop = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "latex-workshop";
          publisher = "James-Yu";
          version = "9.10.0";
          sha256 = "s0+8952svPSA69M4H29zuIxUWV6xNRpIqLNd8pzGJhY=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/James-Yu.latex-workshop/changelog";
          description = "LaTeX Workshop Extension";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop";
          homepage = "https://github.com/James-Yu/LaTeX-Workshop";
          license = lib.licenses.mit;
          maintainers = [ ];
        };
      };

      janet-lang.vscode-janet = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-janet";
          publisher = "janet-lang";
          version = "0.0.2";
          sha256 = "sha256-oj0e++z2BtadIXOnTlocIIHliYweZ1iyrV08DwatfLI=";
        };
        meta = {
          description = "Janet language support for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=janet-lang.vscode-janet";
          homepage = "https://github.com/janet-lang/vscode-janet";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.wackbyte ];
        };
      };

      jdinhlife.gruvbox = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "gruvbox";
          publisher = "jdinhlife";
          version = "1.8.0";
          sha256 = "sha256-P4FbbcRcKWbnC86TSnzQaGn2gHWkDM9I4hj4GiHNPS4=";
        };
        meta = {
          description = "Gruvbox Theme";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=jdinhlife.gruvbox";
          homepage = "https://github.com/jdinhify/vscode-theme-gruvbox";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.imgabe ];
        };
      };

      jebbs.plantuml = callPackage ./jebbs.plantuml { };

      jellyedwards.gitsweep = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "jellyedwards";
          name = "gitsweep";
          version = "1.0.0";
          sha256 = "sha256-XBD8rN6E/0GjZ3zXgR45MN9v4PYrEXBSzN7+CcLrRsg=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/jellyedwards.gitsweep/changelog";
          description = "VS Code extension which allows you to easily exclude modified or new files so they don't get committed accidentally";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=jellyedwards.gitsweep";
          homepage = "https://github.com/jellyedwards/gitsweep";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.MatthieuBarthel ];
        };
      };

      jkillian.custom-local-formatters = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "jkillian";
          name = "custom-local-formatters";
          version = "0.0.6";
          sha256 = "sha256-FYDkOuoiF/N24BFG9GOqtTDwq84txmaa1acdzfskf/c=";
        };
        meta = {
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.kamadorueda ];
        };
      };

      jnoortheen.nix-ide = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "nix-ide";
          publisher = "jnoortheen";
          version = "0.2.2";
          sha256 = "sha256-jwOM+6LnHyCkvhOTVSTUZvgx77jAg6hFCCpBqY8AxIg=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/jnoortheen.nix-ide/changelog";
          description = "Nix language support with formatting and error report";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=jnoortheen.nix-ide";
          homepage = "https://github.com/jnoortheen/vscode-nix-ide";
          license = lib.licenses.mit;
          maintainers = [ ];
        };
      };

      jock.svg = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "svg";
          publisher = "jock";
          version = "1.5.2";
          sha256 = "sha256-Ii2e65BJU+Vw3i8917dgZtGsiSn6qConu8SJ+IqF82U=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      johnpapa.vscode-peacock = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-peacock";
          publisher = "johnpapa";
          version = "4.2.2";
          sha256 = "1z9crpz025ha9hgc9mxxg3vyrsfpf9d16zm1vrf4q592j9156d2m";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      justusadam.language-haskell = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "language-haskell";
          publisher = "justusadam";
          version = "3.6.0";
          sha256 = "sha256-rZXRzPmu7IYmyRWANtpJp3wp0r/RwB7eGHEJa7hBvoQ=";
        };
        meta = {
          license = lib.licenses.bsd3;
        };
      };

      kahole.magit = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "magit";
          publisher = "kahole";
          version = "0.6.43";
          sha256 = "sha256-DPLlQ2IliyvzW8JvgVlGKNd2JjD/RbclNXU3gEFVhOE=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/kahole.magit/changelog";
          description = "Magit for VSCode";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=kahole.magit";
          homepage = "https://github.com/kahole/edamagit";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.azd325 ];
        };
      };

      kalebpace.balena-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "balena-vscode";
          publisher = "kalebpace";
          version = "0.1.3";
          sha256 = "sha256-CecEv19nEtnMe0KlCMNBM9ZAjbAVgPNUcZ6cBxHw44M=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/kalebpace.balena-vscode/changelog";
          description = "VS Code extension for integration with Balena";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=kalebpace.balena-vscode";
          homepage = "https://github.com/balena-vscode/balena-vscode";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.kalebpace ];
        };
      };

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
        meta = {
          description = "The Uncompromising Nix Code Formatter";
          homepage = "https://github.com/kamadorueda/alejandra";
          license = lib.licenses.unlicense;
          maintainers = [ lib.maintainers.kamadorueda ];
        };
      };

      kamikillerto.vscode-colorize = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-colorize";
          publisher = "kamikillerto";
          version = "0.11.1";
          sha256 = "1h82b1jz86k2qznprng5066afinkrd7j3738a56idqr3vvvqnbsm";
        };
        meta = {
          license = lib.licenses.asl20;
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

          meta = {
            description = "CloudFormation Linter IDE integration, autocompletion, and documentation";
            homepage = "https://github.com/aws-cloudformation/cfn-lint-visual-studio-code";
            license = lib.licenses.asl20;
            maintainers = [ lib.maintainers.wolfangaukang ];
          };
        };

      kubukoz.nickel-syntax = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "nickel-syntax";
          publisher = "kubukoz";
          version = "0.0.2";
          sha256 = "sha256-ffPZd717Y2OF4d9MWE6zKwcsGWS90ZJvhWkqP831tVM=";
        };
        meta = {
          license = lib.licenses.asl20;
        };
      };

      llvm-org.lldb-vscode = llvmPackages_8.lldb;

      llvm-vs-code-extensions.vscode-clangd = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-clangd";
          publisher = "llvm-vs-code-extensions";
          version = "0.1.24";
          sha256 = "sha256-yOpsYjjwHRXxbiHDPgrtswUtgbQAo+3RgN2s6UYe9mg=";
        };
        meta = {
          description = "C/C++ completion, navigation, and insights";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=llvm-vs-code-extensions.vscode-clangd";
          homepage = "https://github.com/clangd/vscode-clangd";
          changelog = "https://marketplace.visualstudio.com/items/llvm-vs-code-extensions.vscode-clangd/changelog";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.wackbyte ];
        };
      };

      lokalise.i18n-ally = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "i18n-ally";
          publisher = "Lokalise";
          version = "2.8.1";
          sha256 = "sha256-oDW7ijcObfOP7ZNggSHX0aiI5FkoJ/iQD92bRV0eWVQ=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      lucperkins.vrl-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "lucperkins";
          name = "vrl-vscode";
          version = "0.1.4";
          sha256 = "sha256-xcGa43iPwUR6spOJGTmmWA1dOMNMQEdiuhMZPYZ+dTU=";
        };
        meta = {
          description = "VS Code extension for Vector Remap Language (VRL)";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=lucperkins.vrl-vscode";
          homepage = "https://github.com/lucperkins/vrl-vscode";
          license = lib.licenses.mpl20;
          maintainers = [ lib.maintainers.lucperkins ];
        };
      };

      mads-hartmann.bash-ide-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "mads-hartmann";
          name = "bash-ide-vscode";
          version = "1.36.0";
          sha256 = "sha256-DqY2PS4JSjb6VMO1b0Hi/7JOKSTUk5VSxJiCrUKBfLk=";
        };
        meta = {
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.kamadorueda ];
        };
      };

      marp-team.marp-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "marp-vscode";
          publisher = "marp-team";
          version = "2.5.0";
          sha256 = "sha256-I8UevZs04tUj/jaHrU7LiMF40ElMqtniU1h/9LNLdac=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      matangover.mypy = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "mypy";
          publisher = "matangover";
          version = "0.2.3";
          sha256 = "sha256-m/8j89M340fiMF7Mi7FT2+Xag3fbMGWf8Gt9T8hLdmo=";
        };
        meta.license = lib.licenses.mit;
      };

      matthewpi.caddyfile-support = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "caddyfile-support";
          publisher = "matthewpi";
          version = "0.3.0";
          sha256 = "sha256-1yiOnvC2w33kiPRdQYskee38Cid/GOj9becLadP1fUY=";
        };
        meta = {
          description = "Rich Caddyfile support for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=matthewpi.caddyfile-support";
          homepage = "https://github.com/caddyserver/vscode-caddyfile";
          changelog = "https://marketplace.visualstudio.com/items/matthewpi.caddyfile-support/changelog";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.matthewpi ];
        };
      };

      mattn.lisp = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "lisp";
          publisher = "mattn";
          version = "0.1.12";
          sha256 = "sha256-x6aFrcX0YElEFEr0qA669/LPlab15npmXd5Q585pIEw=";
        };
        meta = {
          description = "Lisp syntax for vscode";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=mattn.lisp";
          homepage = "https://github.com/mattn/vscode-lisp";
          changelog = "https://marketplace.visualstudio.com/items/mattn.lisp/changelog";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.kamadorueda ];
        };
      };

      maximedenes.vscoq = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "maximedenes";
          name = "vscoq";
          version = "0.3.8";
          sha256 = "sha256-0FX5KBsvUmI+JMGBnaI3kJmmD+Y6XFl7LRHU0ADbHos=";
        };
        meta = {
          description = "VsCoq is an extension for Visual Studio Code (VS Code) and VSCodium with support for the Coq Proof Assistant.";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=maximedenes.vscoq";
          homepage = "https://github.com/coq-community/vscoq";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.Zimmi48 ];
        };
      };

      mechatroner.rainbow-csv = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "rainbow-csv";
          publisher = "mechatroner";
          version = "3.6.0";
          sha256 = "sha256-bvxMnT6oSjflAwWQZkNnEoEsVlVg86T0TMYi8tNsbdQ=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      mgt19937.typst-preview = buildVscodeMarketplaceExtension {
        mktplcRef =
        let
          sources = {
            "x86_64-linux" = {
              arch = "linux-x64";
              sha256 = "sha256-O8sFv23tlhJS6N8LRKkHcTJTupZejCLDRdVVCdDlWbA=";
            };
            "x86_64-darwin" = {
              arch = "darwin-x64";
              sha256 = "1npzjch67agswh3nm14dbbsx777daq2rdw1yny10jf3858z2qynr";
            };
            "aarch64-linux" = {
              arch = "linux-arm64";
              sha256 = "1vv1jfgnyjbmshh4w6rf496d9dpdsk3f0049ii4d9vi23igk4xpk";
            };
            "aarch64-darwin" = {
              arch = "darwin-arm64";
              sha256 = "0dfchzqm61kddq20zvp1pcpk1625b9wgj32ymc08piq06pbadk29";
            };
          };
        in
        {
          name = "typst-preview";
          publisher = "mgt19937";
          version = "0.6.1";
        } // sources.${stdenv.system};

        nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];

        buildInputs = lib.optionals stdenv.isLinux [ stdenv.cc.cc.lib ];

        meta = {
          description = "Typst Preview is an extension for previewing your Typst files in vscode instantly";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=mgt19937.typst-preview";
          homepage = "https://github.com/Enter-tainer/typst-preview-vscode";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.drupol ];
        };
      };

      mhutchie.git-graph = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "git-graph";
          publisher = "mhutchie";
          version = "1.30.0";
          sha256 = "sha256-sHeaMMr5hmQ0kAFZxxMiRk6f0mfjkg2XMnA4Gf+DHwA=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      mikestead.dotenv = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "dotenv";
          publisher = "mikestead";
          version = "1.0.1";
          sha256 = "sha256-dieCzNOIcZiTGu4Mv5zYlG7jLhaEsJR05qbzzzQ7RWc=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      mishkinf.goto-next-previous-member = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "goto-next-previous-member";
          publisher = "mishkinf";
          version = "0.0.6";
          sha256 = "07rpnbkb51835gflf4fpr0v7fhj8hgbhsgcz2wpag8wdzdxc3025";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      mkhl.direnv = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "direnv";
          publisher = "mkhl";
          version = "0.14.0";
          sha256 = "sha256-T+bt6ku+zkqzP1gXNLcpjtFAevDRiSKnZaE7sM4pUOs=";
        };
        meta = {
          description = "direnv support for Visual Studio Code";
          license = lib.licenses.bsd0;
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=mkhl.direnv";
          maintainers = [ lib.maintainers.nullx76 ];
        };
      };

      ms-azuretools.vscode-docker = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-docker";
          publisher = "ms-azuretools";
          version = "1.24.0";
          sha256 = "sha256-zZ34KQrRPqVbfGdpYACuLMiMj4ZIWSnJIPac1yXD87k=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ms-ceintl = callPackage ./language-packs.nix { }; # non-English language packs

      ms-dotnettools.csharp = callPackage ./ms-dotnettools.csharp { };

      ms-kubernetes-tools.vscode-kubernetes-tools = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-kubernetes-tools";
          publisher = "ms-kubernetes-tools";
          version = "1.3.11";
          sha256 = "sha256-I2ud9d4VtgiiIT0MeoaMThgjLYtSuftFVZHVJTMlJ8s=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ms-pyright.pyright = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "pyright";
          publisher = "ms-pyright";
          version = "1.1.300";
          sha256 = "sha256-GzRJeV4qfgM2kBv6U3MH7lMWl3CL6LWPI/9GaVWZL+o=";
        };
        meta = {
          description = "VS Code static type checking for Python";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-pyright.pyright";
          homepage = "https://github.com/Microsoft/pyright#readme";
          changelog = "https://marketplace.visualstudio.com/items/ms-pyright.pyright/changelog";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.ratsclub ];
        };
      };

      ms-python.black-formatter = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "black-formatter";
          publisher = "ms-python";
          version = "2023.4.1";
          sha256 = "sha256-IJaLke0WF1rlKTiuwJHAXDQB1SS39AoQhc4iyqqlTyY=";
        };
        meta = with lib; {
          description = "Formatter extension for Visual Studio Code using black";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-python.black-formatter";
          homepage = "https://github.com/microsoft/vscode-black-formatter";
          license = licenses.mit;
          maintainers = with maintainers; [ sikmir ];
        };
      };

      ms-python.isort = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "isort";
          publisher = "ms-python";
          version = "2023.10.1";
          sha256 = "sha256-NRsS+mp0pIhGZiqxAMXNZ7SwLno9Q8pj+RS1WB92HzU=";
        };
        meta = with lib; {
          description = "Import sorting extension for Visual Studio Code using isort";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-python.isort";
          homepage = "https://github.com/microsoft/vscode-isort";
          license = licenses.mit;
          maintainers = with maintainers; [ sikmir ];
        };
      };

      ms-python.python = callPackage ./ms-python.python { };

      ms-python.vscode-pylance = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-pylance";
          publisher = "MS-python";
          version = "2022.7.11";
          sha256 = "sha256-JatjLZXO7iwpBwjL1hrNafBiF81CaozWWANyRm8A36Y=";
        };

        buildInputs = [ nodePackages.pyright ];

        meta = {
          changelog = "https://marketplace.visualstudio.com/items/ms-python.vscode-pylance/changelog";
          description = "A performant, feature-rich language server for Python in VS Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance";
          homepage = "https://github.com/microsoft/pylance-release";
          license = lib.licenses.unfree;
        };
      };

      ms-toolsai.jupyter = callPackage ./ms-toolsai.jupyter { };

      ms-toolsai.jupyter-keymap = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "jupyter-keymap";
          publisher = "ms-toolsai";
          version = "1.1.0";
          sha256 = "sha256-krDtR+ZJiJf1Kxcu5mdXOaSAiJb2bXC1H0XWWviWeMQ=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ms-toolsai.jupyter-renderers = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "jupyter-renderers";
          publisher = "ms-toolsai";
          version = "1.0.15";
          sha256 = "sha256-JR6PunvRRTsSqjSGGAn/1t1B+Ia6X0MgqahehcuSNYA=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ms-toolsai.vscode-jupyter-cell-tags = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-jupyter-cell-tags";
          publisher = "ms-toolsai";
          version = "0.1.8";
          sha256 = "sha256-0oPyptnUWL1h/H13SdR+FdgGzVwEpTaK9SCE7BvI/5M=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ms-toolsai.vscode-jupyter-slideshow = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-jupyter-slideshow";
          publisher = "ms-toolsai";
          version = "0.1.5";
          sha256 = "1p6r5vkzvwvxif3wxqi9599vplabzig27fzzz0bx9z0awfglzyi7";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ms-vscode.anycode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "anycode";
          publisher = "ms-vscode";
          version = "0.0.70";
          sha256 = "sha256-POxgwvKF4A+DxKVIOte4I8REhAbO1U9Gu6r/S41/MmA=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ms-vscode.cmake-tools = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "cmake-tools";
          publisher = "ms-vscode";
          version = "1.14.20";
          sha256 = "sha256-j67Z65N9YW8wY4zIWWCtPIKgW9GYoUntBoGVBLR/H2o=";
        };
        meta.license = lib.licenses.mit;
      };

      ms-vscode.cpptools = callPackage ./ms-vscode.cpptools { };

      ms-vscode.hexeditor = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "hexeditor";
          publisher = "ms-vscode";
          version = "1.9.11";
          sha256 = "sha256-w1R8z7Q/JRAsqJ1mgcvlHJ6tywfgKtS6A6zOY2p01io=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ms-vscode.live-server = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "live-server";
          publisher = "ms-vscode";
          version = "0.4.8";
          sha256 = "sha256-/IrLq+nNxwQB1S1NIGYkv24DOY7Mc25eQ+orUfh42pg=";
        };
        meta = {
          description = "Launch a development local Server with live reload feature for static & dynamic pages";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-vscode.live-server";
          homepage = "https://github.com/microsoft/vscode-livepreview";
          license = lib.licenses.mit;
        };
      };

      ms-vscode.makefile-tools = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "makefile-tools";
          publisher = "ms-vscode";
          version = "0.6.0";
          sha256 = "07zagq5ib9hd3w67yk2g728vypr4qazw0g9dyd5bax21shnmppa9";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ms-vscode.powershell = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "PowerShell";
          publisher = "ms-vscode";
          version = "2023.3.1";
          sha256 = "sha256-FJolnWU0DbuQYvMuGL3mytf0h39SH9rUPCl2ahLXLuY=";
        };
        meta = {
          description = "A Visual Studio Code extension for PowerShell language support";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell";
          homepage = "https://github.com/PowerShell/vscode-powershell";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.rhoriguchi ];
        };
      };

      ms-vscode.theme-tomorrowkit = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "Theme-TomorrowKit";
          publisher = "ms-vscode";
          version = "0.1.4";
          sha256 = "sha256-qakwJWak+IrIeeVcMDWV/fLPx5M8LQGCyhVt4TS/Lmc=";
        };
        meta = {
          description = "Additional Tomorrow and Tomorrow Night themes for VS Code. Based on the TextMate themes.";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-vscode.Theme-TomorrowKit";
          homepage = "https://github.com/microsoft/vscode-themes";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.ratsclub ];
        };
      };

      ms-vscode-remote.remote-containers = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "remote-containers";
          publisher = "ms-vscode-remote";
          version = "0.305.0";
          sha256 = "sha256-srSRD/wgDbQo9P1uJk8YtcXPZO62keG5kRnp1TmHqOc=";
        };
        meta = {
          description = "Open any folder or repository inside a Docker container.";
          downloadPage = "Use a container as your development environment";
          homepage = "https://code.visualstudio.com/docs/devcontainers/containers";
          license = lib.licenses.unfree;
          maintainers = [ lib.maintainers.anthonyroussel ];
        };
      };

      ms-vscode-remote.remote-ssh = callPackage ./ms-vscode-remote.remote-ssh { };

      ms-vsliveshare.vsliveshare = callPackage ./ms-vsliveshare.vsliveshare { };

      mskelton.one-dark-theme = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "one-dark-theme";
          publisher = "mskelton";
          version = "1.14.2";
          sha256 = "sha256-6nIfEPbau5Dy1DGJ0oQ5L2EGn2NDhpd8jSdYujtOU68=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      mskelton.npm-outdated = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "npm-outdated";
          publisher = "mskelton";
          version = "2.2.0";
          sha256 = "sha256-kHItIlTW+PIVXrLgzdGAoPeR6sWKuKl/QyJ5+TIv3/E=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/mskelton.npm-outdated/changelog";
          description = "Shows which packages are outdated in an npm project";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=mskelton.npm-outdated";
          homepage = "https://github.com/mskelton/vscode-npm-outdated";
          license = lib.licenses.isc;
        };
      };

      mvllow.rose-pine = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "mvllow";
          name = "rose-pine";
          version = "2.7.1";
          sha256 = "sha256-QQIkuJAI4apDt8rfhXvMg9bNtGTFeMaEkN/Se12zGpc=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      naumovs.color-highlight = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "color-highlight";
          publisher = "naumovs";
          version = "2.6.0";
          sha256 = "sha256-TcPQOAHCYeFHPdR85GIXsy3fx70p8cLdO2UNO0krUOs=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/naumovs.color-highlight/changelog";
          description = "Highlight web colors in your editor";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=naumovs.color-highlight";
          homepage = "https://github.com/enyancc/vscode-ext-color-highlight";
          license = lib.licenses.gpl3Only;
          maintainers = [ lib.maintainers.datafoo ];
        };
      };

      njpwerner.autodocstring = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "autodocstring";
          publisher = "njpwerner";
          version = "0.6.1";
          sha256 = "sha256-NI0cbjsZPW8n6qRTRKoqznSDhLZRUguP7Sa/d0feeoc=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/njpwerner.autodocstring/changelog";
          description = "Generates python docstrings automatically";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=njpwerner.autodocstring";
          homepage = "https://github.com/NilsJPWerner/autoDocstring";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.kamadorueda ];
        };
      };

      nonylene.dark-molokai-theme = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "dark-molokai-theme";
          publisher = "nonylene";
          version = "1.0.5";
          sha256 = "sha256-2qjV6iSz8DDU1yP1II9sxGSgiETmEtotFvfNjm+cTuI=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/nonylene.dark-molokai-theme/changelog";
          description = "Theme inspired by VSCode default dark theme, monokai theme and Vim Molokai theme";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=nonylene.dark-molokai-theme";
          homepage = "https://github.com/nonylene/vscode-dark-molokai-theme";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.amz-x ];
        };
      };

      nvarner.typst-lsp = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "typst-lsp";
          publisher = "nvarner";
          version = "0.5.0";
          sha256 = "sha256-4bZbjbcd/EjSRBMkzMs1pD00qyQb5W6gePh4xfoU6Ug=";
        };

        nativeBuildInputs = [ jq moreutils ];

        postInstall = ''
          cd "$out/$installPrefix"
          jq '.contributes.configuration.properties."typst-lsp.serverPath".default = "${typst-lsp}/bin/typst-lsp"' package.json | sponge package.json
        '';

        meta = {
          changelog = "https://marketplace.visualstudio.com/items/nvarner.typst-lsp/changelog";
          description = "A VSCode extension for providing a language server for Typst";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=nvarner.typst-lsp";
          homepage = "https://github.com/nvarner/typst-lsp";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.drupol ];
        };
      };

      ocamllabs.ocaml-platform = buildVscodeMarketplaceExtension {
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/ocamllabs.ocaml-platform/changelog";
          description = "Official OCaml Support from OCamlLabs";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ocamllabs.ocaml-platform";
          homepage = "https://github.com/ocamllabs/vscode-ocaml-platform";
          license = lib.licenses.isc;
          maintainers = [ lib.maintainers.ratsclub ];
        };
        mktplcRef = {
          name = "ocaml-platform";
          publisher = "ocamllabs";
          version = "1.12.2";
          sha256 = "sha256-dj8UFbYgAl6dt/1MuIBawTVUbBDTTedZEcHtKZjEcew=";
        };
      };

      octref.vetur = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vetur";
          publisher = "octref";
          version = "0.37.3";
          sha256 = "sha256-3hi1LOZto5AYaomB9ihkAt4j/mhkCDJ8Jqa16piwHIQ=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      oderwat.indent-rainbow = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "indent-rainbow";
          publisher = "oderwat";
          version = "8.3.1";
          sha256 = "sha256-dOicya0B2sriTcDSdCyhtp0Mcx5b6TUaFKVb0YU3jUc=";
        };
        meta = {
          description = "Makes indentation easier to read";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=oderwat.indent-rainbow";
          homepage = "https://github.com/oderwat/vscode-indent-rainbow";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.imgabe ];
        };
      };

      phoenixframework.phoenix = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "phoenix";
          publisher = "phoenixframework";
          version = "0.1.2";
          sha256 = "sha256-T+YNRR8jAzNagmoCDzjbytBDFtPhNn289Kywep/w8sw=";
        };
        meta = {
          description = "Syntax highlighting support for HEEx / Phoenix templates";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=phoenixframework.phoenix";
          homepage = "https://github.com/phoenixframework/vscode-phoenix";
          license = lib.licenses.mit;
          maintainers = [ ];
        };
      };

      piousdeer.adwaita-theme = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "adwaita-theme";
          publisher = "piousdeer";
          version = "1.1.0";
          sha256 = "sha256-tKpKLUcc33YrgDS95PJu22ngxhwjqeVMC1Mhhy+IPGE=";
        };
        meta = {
          description = "Theme for the GNOME desktop";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=piousdeer.adwaita-theme";
          homepage = "https://github.com/piousdeer/vscode-adwaita";
          license = lib.licenses.gpl3;
          maintainers = [ lib.maintainers.wyndon ];
        };
      };

      pkief.material-icon-theme = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "material-icon-theme";
          publisher = "PKief";
          version = "4.29.0";
          sha256 = "sha256-YqleqYSpZuhGFGkNo3FRLjiglxX+iUCJl69CRCY/oWM=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      pkief.material-product-icons = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "material-product-icons";
          publisher = "PKief";
          version = "1.5.0";
          sha256 = "sha256-gKU21OS2ZFyzCQVQ1fa3qlahLBAcJaHDEcz7xof3P4A=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      prisma.prisma = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "prisma";
          publisher = "Prisma";
          version = "4.11.0";
          sha256 = "sha256-fHvwv9E/O8ZvhnyY7nNF/SIyl87z8KVEXTbhU/37EP0=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/Prisma.prisma/changelog";
          description = "VSCode extension for syntax highlighting, formatting, auto-completion, jump-to-definition and linting for .prisma files";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=Prisma.prisma";
          homepage = "https://github.com/prisma/language-tools";
          license = lib.licenses.asl20;
          maintainers = [ ];
        };
      };

      rebornix.ruby = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "ruby";
          publisher = "rebornix";
          version = "0.28.1";
          sha256 = "sha256-HAUdv+2T+neJ5aCGiQ37pCO6x6r57HIUnLm4apg9L50=";
        };

        meta.license = lib.licenses.mit;
      };

      redhat.java = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "java";
          publisher = "redhat";
          version = "1.17.2023032504";
          sha256 = "sha256-ni1jzCPjwtcdJTEORn0vYzLRbQ/wseTZmrETJ8QPW58=";
        };
        buildInputs = [ jdk ];
        meta = {
          license = lib.licenses.epl20;
          broken = lib.versionOlder jdk.version "11";
        };
      };

      redhat.vscode-xml = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-xml";
          publisher = "redhat";
          version = "0.25.2023032304";
          sha256 = "sha256-3hU/MZU9dP91p2PVycFL6yg/nf4/x8tt76vmlkiHnE8=";
        };
        meta.license = lib.licenses.epl20;
      };

      redhat.vscode-yaml = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-yaml";
          publisher = "redhat";
          version = "1.12.0";
          sha256 = "sha256-r/me14KonxnQeensIYyWU4dQrhomc8h2ntYoiZ+Y7jE=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      richie5um2.snake-trail = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "snake-trail";
          publisher = "richie5um2";
          version = "0.6.0";
          sha256 = "0wkpq9f48hplrgabb0v1ij6fc4sb8h4a93dagw4biprhnnm3qx49";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      rioj7.commandonallfiles = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "commandOnAllFiles";
          publisher = "rioj7";
          version = "0.3.2";
          sha256 = "sha256-777jdBpWJ66ASeeETWevWF4mIAj4RWviNSTxzvqwl0U=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ritwickdey.liveserver = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "liveserver";
          publisher = "ritwickdey";
          version = "5.7.9";
          sha256 = "sha256-w0CYSEOdltwMFzm5ZhOxSrxqQ1y4+gLfB8L+EFFgzDc=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      roman.ayu-next = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "ayu-next";
          publisher = "roman";
          version = "1.2.15";
          sha256 = "sha256-gGEjb9BrvFmKhAxRUmN3YWx7VZqlUp6w7m4r46DPn50=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      RoweWilsonFrederiskHolme.wikitext = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "wikitext";
          publisher = "RoweWilsonFrederiskHolme";
          version = "3.8.0";
          sha256 = "30540a85163e797028eec9bc3db1866bbf473e98615bf6ade6d1d672017ebe52";
        };
        meta = {
          description = "Extension that helps users view and write MediaWiki's Wikitext files";
          longDescription = ''
            With this extension, you can more easily discover your grammatical problems
            through the marked and styled text. The plugin is based on MediaWiki's
            Wikitext standard, but the rules are somewhat stricter, which helps users
            write text that is easier to read and maintain.
          '';
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=RoweWilsonFrederiskHolme.wikitext";
          homepage = "https://github.com/Frederisk/Wikitext-VSCode-Extension";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.rapiteanu ];
        };
      };

      rubbersheep.gi = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "gi";
          publisher = "rubbersheep";
          version = "0.2.11";
          sha256 = "0j9k6wm959sziky7fh55awspzidxrrxsdbpz1d79s5lr5r19rs6j";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      rubymaniac.vscode-paste-and-indent = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-paste-and-indent";
          publisher = "Rubymaniac";
          version = "0.0.8";
          sha256 = "0fqwcvwq37ndms6vky8jjv0zliy6fpfkh8d9raq8hkinfxq6klgl";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      rust-lang.rust-analyzer = callPackage ./rust-lang.rust-analyzer { };

      ryu1kn.partial-diff = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "partial-diff";
          publisher = "ryu1kn";
          version = "1.4.3";
          sha256 = "0x3lkvna4dagr7s99yykji3x517cxk5kp7ydmqa6jb4bzzsv1s6h";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      sanaajani.taskrunnercode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "taskrunnercode";
          publisher = "sanaajani";
          version = "0.3.0";
          sha256 = "NVGMM9ugmYZNCWhNmclcGuVJPhJ9h4q2G6nNzVUEpes=";
        };
        meta = {
          description = "Extension to view and run tasks from Explorer pane";
          longDescription = ''
            This extension adds an additional "Task Runner" view in your Explorer Pane
            to visualize and individually run the auto-detected or configured tasks
            in your project.
          '';
          homepage = "https://github.com/sana-ajani/taskrunner-code";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.pbsds ];
        };
      };

      scala-lang.scala = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "scala";
          publisher = "scala-lang";
          version = "0.5.6";
          sha256 = "sha256-eizIPazqEb27aQ+o9nTD1O58zbjkHYHNhGjK0uJgnwA=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      scalameta.metals = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "metals";
          publisher = "scalameta";
          version = "1.22.3";
          sha256 = "sha256-iLLWobQv5CEjJwCdDNdWYQ1ehOiYyNi940b4QmNZFoQ=";
        };
        meta = {
          license = lib.licenses.asl20;
        };
      };

      seatonjiang.gitmoji-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "seatonjiang";
          name = "gitmoji-vscode";
          version = "1.2.2";
          sha256 = "sha256-+lwbCLV62y1IHrjCygBphQZJUu+ZApYTwBQld5uu12w=";
        };
        meta = {
          description = "Gitmoji tool for git commit messages in VSCode";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=seatonjiang.gitmoji-vscode";
          homepage = "https://github.com/seatonjiang/gitmoji-vscode/";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.laurent-f1z1 ];
        };
      };

      serayuzgur.crates = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "crates";
          publisher = "serayuzgur";
          version = "0.6.0";
          sha256 = "080zd103vjrz86vllr1ricq2vi3hawn4534n492m7xdcry9l9dpc";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      shardulm94.trailing-spaces = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "shardulm94";
          name = "trailing-spaces";
          version = "0.4.1";
          sha256 = "sha256-pLE1bfLRxjlm/kgU9nmtiPBOnP05giQnWq6bexrrIZY=";
        };
        meta = {
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.kamadorueda ];
        };
      };

      shd101wyy.markdown-preview-enhanced = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "shd101wyy";
          name = "markdown-preview-enhanced";
          version = "0.6.10";
          sha256 = "sha256-nCsl7ZYwuTvNZSTUMR6jEywClmcPm8xW6ABu9220wJI=";
        };
        meta = {
          description = "Provides a live preview of markdown using either markdown-it or pandoc";
          longDescription = ''
            Markdown Preview Enhanced provides you with many useful functionalities
            such as automatic scroll sync, math typesetting, mermaid, PlantUML,
            pandoc, PDF export, code chunk, presentation writer, etc.
          '';
          homepage = "https://github.com/shd101wyy/vscode-markdown-preview-enhanced";
          license = lib.licenses.ncsa;
          maintainers = [ lib.maintainers.pbsds ];
        };
      };

      shyykoserhiy.vscode-spotify = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-spotify";
          publisher = "shyykoserhiy";
          version = "3.2.1";
          sha256 = "14d68rcnjx4a20r0ps9g2aycv5myyhks5lpfz0syr2rxr4kd1vh6";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      skellock.just = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "just";
          publisher = "skellock";
          version = "2.0.0";
          sha256 = "sha256-FOp/dcW0+07rADEpUMzx+SGYjhvE4IhcCOqUQ38yCN4=";
        };
        meta = {
          changelog = "https://github.com/skellock/vscode-just/blob/master/CHANGELOG.md";
          description = "Provides syntax and recipe launcher for Just scripts";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=skellock.just";
          homepage = "https://github.com/skellock/vscode-just";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.maximsmol ];
        };
      };

      skyapps.fish-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "fish-vscode";
          publisher = "skyapps";
          version = "0.2.1";
          sha256 = "0y1ivymn81ranmir25zk83kdjpjwcqpnc9r3jwfykjd9x0jib2hl";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      slevesque.vscode-multiclip = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-multiclip";
          publisher = "slevesque";
          version = "0.1.5";
          sha256 = "1cg8dqj7f10fj9i0g6mi3jbyk61rs6rvg9aq28575rr52yfjc9f9";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      sonarsource.sonarlint-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "sonarlint-vscode";
          publisher = "sonarsource";
          version = "3.16.0";
          sha256 = "sha256-zWgITdvUS9fq1uT6A4Gs3fSTBwCXoEIQ/tVcC7Eigfs=";
        };
        meta.license = lib.licenses.lgpl3Only;
      };

      spywhere.guides = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "guides";
          publisher = "spywhere";
          version = "0.9.3";
          sha256 = "1kvsj085w1xax6fg0kvsj1cizqh86i0pkzpwi0sbfvmcq21i6ghn";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      stefanjarina.vscode-eex-snippets = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-eex-snippets";
          publisher = "stefanjarina";
          version = "0.0.8";
          sha256 = "0j8pmrs1lk138vhqx594pzxvrma4yl3jh7ihqm2kgh0cwnkbj36m";
        };
        meta = {
          description = "VSCode extension for Elixir EEx and HTML (EEx) code snippets";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=stefanjarina.vscode-eex-snippets";
          homepage = "https://github.com/stefanjarina/vscode-eex-snippets";
          license = lib.licenses.mit;
          maintainers = [ ];
        };
      };

      stephlin.vscode-tmux-keybinding = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-tmux-keybinding";
          publisher = "stephlin";
          version = "0.0.7";
          sha256 = "sha256-MrW0zInweAhU2spkEEiDLyuT6seV3GFFurWTqYMzqgY=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/stephlin.vscode-tmux-keybinding/changelog";
          description = "A simple extension for tmux behavior in vscode terminal.";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=stephlin.vscode-tmux-keybinding";
          homepage = "https://github.com/StephLin/vscode-tmux-keybinding";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.dbirks ];
        };
      };

      stkb.rewrap = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "stkb";
          name = "rewrap";
          version = "17.8.0";
          sha256 = "sha256-9t1lpVbpcmhLamN/0ZWNEWD812S6tXG6aK3/ALJCJvg=";
        };
        meta = {
          changelog = "https://github.com/stkb/Rewrap/blob/master/CHANGELOG.md";
          description = "Hard word wrapping for comments and other text at a given column.";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=stkb.rewrap";
          homepage = "https://github.com/stkb/Rewrap#readme";
          license = lib.licenses.asl20;
          maintainers = [ lib.maintainers.datafoo ];
        };
      };

      streetsidesoftware.code-spell-checker = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "code-spell-checker";
          publisher = "streetsidesoftware";
          version = "3.0.1";
          sha256 = "sha256-KeYE6/yO2n3RHPjnJOnOyHsz4XW81y9AbkSC/I975kQ=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/streetsidesoftware.code-spell-checker/changelog";
          description = "Spelling checker for source code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker";
          homepage = "https://streetsidesoftware.github.io/vscode-spell-checker";
          license = lib.licenses.gpl3Only;
          maintainers = [ lib.maintainers.datafoo ];
        };
      };

      styled-components.vscode-styled-components = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-styled-components";
          publisher = "styled-components";
          version = "1.7.6";
          sha256 = "sha256-ZXXXFUriu//2Wmj1N+plj7xzJauGBfj+79SyrkUZAO4=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/styled-components.vscode-styled-components/changelog";
          description = "Syntax highlighting and IntelliSense for styled-components";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=styled-components.vscode-styled-components";
          homepage = "https://github.com/styled-components/vscode-styled-components";
          license = lib.licenses.mit;
        };
      };

      sumneko.lua = callPackage ./sumneko.lua { };

      svelte.svelte-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "svelte-vscode";
          publisher = "svelte";
          version = "107.4.3";
          sha256 = "sha256-z1foIJXVKmJ0G4FfO9xsjiQgmq/ZtoB3b6Ch8Nyj1zY=";
        };
        meta = {
          changelog = "https://github.com/sveltejs/language-tools/releases";
          description = "Svelte language support for VS Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=svelte.svelte-vscode";
          homepage = "https://github.com/sveltejs/language-tools#readme";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.fabianhauser ];
        };
      };

      svsool.markdown-memo = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "markdown-memo";
          publisher = "svsool";
          version = "0.3.19";
          sha256 = "sha256-JRM9Tm7yql7dKXOdpTwBVR/gx/nwvM7qqrCNlV2i1uI=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/svsool.markdown-memo/changelog";
          description = "Markdown knowledge base with bidirectional [[link]]s built on top of VSCode";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=svsool.markdown-memo";
          homepage = "https://github.com/svsool/vscode-memo";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.ratsclub ];
        };
      };

      tabnine.tabnine-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "tabnine-vscode";
          publisher = "tabnine";
          version = "3.6.43";
          sha256 = "sha256-/onQybGMBscD6Rj4PWafetuag1J1cgHTw5NHri082cs=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      tailscale.vscode-tailscale = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-tailscale";
          publisher = "tailscale";
          version = "0.4.0";
          sha256 = "sha256-c/BZHKHs2EKd37148dSxEeP1wBXv75HhDqzegmHPjOs=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/tailscale.vscode-tailscale/changelog";
          description = "VSCode extension to share a port over the internet with Tailscale Funnel";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=Tailscale.vscode-tailscale";
          homepage = "https://github.com/tailscale-dev/vscode-tailscale";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.drupol ];
        };
      };

      takayama.vscode-qq = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "takayama";
          name = "vscode-qq";
          version = "1.4.2";
          sha256 = "sha256-koeiFXUFI/i8EGCRDTym62m7JER18J9MKZpbAozr0Ng=";
        };
        meta = {
          license = lib.licenses.mpl20;
        };
      };

      tamasfe.even-better-toml = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "even-better-toml";
          publisher = "tamasfe";
          version = "0.19.2";
          sha256 = "sha256-JKj6noi2dTe02PxX/kS117ZhW8u7Bhj4QowZQiJKP2E=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      techtheawesome.rust-yew = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "rust-yew";
          publisher = "techtheawesome";
          version = "0.2.2";
          sha256 = "sha256-t9DYY1fqW7M5F1pbIUtnnodxMzIzURew4RXT78djWMI=";
        };
        meta = {
          description = "A VSCode extension that provides some language features for Yew's html macro syntax";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=TechTheAwesome.rust-yew";
          homepage = "https://github.com/TechTheAwesome/code-yew-server";
          license = lib.licenses.gpl3Only;
          maintainers = [ lib.maintainers.CardboardTurkey ];
        };
      };

      theangryepicbanana.language-pascal = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "language-pascal";
          publisher = "theangryepicbanana";
          version = "0.1.6";
          sha256 = "096wwmwpas21f03pbbz40rvc792xzpl5qqddzbry41glxpzywy6b";
        };
        meta = {
          description = "VSCode extension for high-quality Pascal highlighting";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=theangryepicbanana.language-pascal";
          homepage = "https://github.com/ALANVF/vscode-pascal-magic";
          license = lib.licenses.mit;
          maintainers = [ ];
        };
      };

      thenuprojectcontributors.vscode-nushell-lang = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-nushell-lang";
          publisher = "thenuprojectcontributors";
          version = "1.1.0";
          sha256 = "sha256-7v4q0OEqv7q2ejHp4lph2Dsqg0GWE65pxyz9goQEm8g=";
        };
        meta.license = lib.licenses.mit;
      };

      tiehuis.zig = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "zig";
          publisher = "tiehuis";
          version = "0.2.6";
          sha256 = "sha256-s0UMY0DzEufEF+pizYeH4MKYOiiJ6z05gYHvfpaS4zA=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      timonwong.shellcheck = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "shellcheck";
          publisher = "timonwong";
          version = "0.26.3";
          sha256 = "GlyOLc2VrRnA50MkaG83qa0yLUyJYwueqEO+ZeAStYs=";
        };
        nativeBuildInputs = [ jq moreutils ];
        postInstall = ''
          cd "$out/$installPrefix"
          jq '.contributes.configuration.properties."shellcheck.executablePath".default = "${shellcheck}/bin/shellcheck"' package.json | sponge package.json
        '';
        meta = {
          license = lib.licenses.mit;
        };
      };

      tobiasalthoff.atom-material-theme = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "atom-material-theme";
          publisher = "tobiasalthoff";
          version = "1.10.9";
          sha256 = "sha256-EdU0FMkaQpwhOpPRC+HGIxcrt7kSN+l4+mSgIwogB/I=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      tomoki1207.pdf = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "pdf";
          publisher = "tomoki1207";
          version = "1.2.2";
          sha256 = "sha256-i3Rlizbw4RtPkiEsodRJEB3AUzoqI95ohyqZ0ksROps=";
        };
        meta = {
          description = "Show PDF preview in VSCode";
          homepage = "https://github.com/tomoki1207/vscode-pdfviewer";
          license = lib.licenses.mit;
        };
      };

      tuttieee.emacs-mcx = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "emacs-mcx";
          publisher = "tuttieee";
          version = "0.47.0";
          sha256 = "sha256-dGty5+1+JEtJgl/DiyqEB/wuf3K8tCj1qWKua6ongIs=";
        };
        meta = {
          changelog = "https://github.com/whitphx/vscode-emacs-mcx/blob/main/CHANGELOG.md";
          description = "Awesome Emacs Keymap - VSCode emacs keybinding with multi cursor support";
          homepage = "https://github.com/whitphx/vscode-emacs-mcx";
          license = lib.licenses.mit;
        };
      };

      twxs.cmake = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "cmake";
          publisher = "twxs";
          version = "0.0.17";
          sha256 = "11hzjd0gxkq37689rrr2aszxng5l9fwpgs9nnglq3zhfa1msyn08";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      tyriar.sort-lines = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "sort-lines";
          publisher = "Tyriar";
          version = "1.10.2";
          sha256 = "sha256-AI16YBmmfZ3k7OyUrh4wujhu7ptqAwfI5jBbAc6MhDk=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      unifiedjs.vscode-mdx = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-mdx";
          publisher = "unifiedjs";
          version = "1.4.0";
          sha256 = "sha256-qqqq0QKTR0ZCLdPltsnQh5eTqGOh9fV1OSOZMjj4xXg=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/unifiedjs.vscode-mdx/changelog";
          description = "VSCode language support for MDX";
          downloadPage = "https://github.com/mdx-js/mdx-analyzer";
          homepage = "https://github.com/mdx-js/mdx-analyzer#readme";
          license = lib.licenses.mit;
        };
      };

      usernamehw.errorlens = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "errorlens";
          publisher = "usernamehw";
          version = "3.12.0";
          sha256 = "sha256-G5+We49/f5UwYqoBovegRK+UOT6KPZo85cvoDjD1Mu4=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/usernamehw.errorlens/changelog";
          description = "Improve highlighting of errors, warnings and other language diagnostics.";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=usernamehw.errorlens";
          homepage = "https://github.com/usernamehw/vscode-error-lens";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.imgabe ];
        };
      };

      vadimcn.vscode-lldb = callPackage ./vadimcn.vscode-lldb { llvmPackages = llvmPackages_14; };

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

        meta = {
          license = lib.licenses.mpl20;
          maintainers = [ lib.maintainers._0xbe7a ];
        };
      };

      viktorqvarfordt.vscode-pitch-black-theme = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-pitch-black-theme";
          publisher = "ViktorQvarfordt";
          version = "1.3.0";
          sha256 = "sha256-1JDm/cWNWwxa1gNsHIM/DIvqjXsO++hAf0mkjvKyi4g=";
        };
        meta = {
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.wolfangaukang ];
        };
      };

      vincaslt.highlight-matching-tag = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "highlight-matching-tag";
          publisher = "vincaslt";
          version = "0.11.0";
          sha256 = "sha256-PxngjprSpWtD2ZDZfh+gOnZ+fVk5rvgGdZFxqbE21CY=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vscjava.vscode-gradle = buildVscodeMarketplaceExtension rec {
        mktplcRef = {
          name = "vscode-gradle";
          publisher = "vscjava";
          version = "3.12.6";
          sha256 = "sha256-j4JyhNGsRlJmS8Wj38gLpC1gXVvdPx10cgzP8dXmmNo=";
        };

        meta = {
          changelog = "https://marketplace.visualstudio.com/items/vscjava.vscode-gradle/changelog";
          description = "A Visual Studio Code extension for Gradle build tool";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-gradle";
          homepage = "https://github.com/microsoft/vscode-gradle";
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [ rhoriguchi ];
        };
      };

      vscjava.vscode-java-debug = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-java-debug";
          publisher = "vscjava";
          version = "0.49.2023032407";
          sha256 = "sha256-ZxJ6BM3rt98HPSyL0hDiyCGIBS7YtF/OuzlTvw7Bp1w=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vscjava.vscode-java-dependency = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-java-dependency";
          publisher = "vscjava";
          version = "0.21.2023032400";
          sha256 = "sha256-lG04Yu8exMcMvupqasUrbZS4CkSggQeJKtkm9iyKL5U=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vscjava.vscode-java-test = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-java-test";
          publisher = "vscjava";
          version = "0.38.2023032402";
          sha256 = "sha256-4WKsw+iuONaGQRMNN2TGd3zIYonHgOzvNleVhCyYFes=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vscjava.vscode-maven = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-maven";
          publisher = "vscjava";
          version = "0.41.2023032403";
          sha256 = "sha256-VeN4q6pEaLPQVYleLCDkDCv2Gr8QdHVPjpwSuo3mBuE=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vscjava.vscode-spring-initializr = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-spring-initializr";
          publisher = "vscjava";
          version = "0.11.2023031603";
          sha256 = "sha256-MSyVLSjaiH+FaeGn/5Y+IWRJmNpAx3UPGpY4VmsiCD8=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vscode-icons-team.vscode-icons = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-icons";
          publisher = "vscode-icons-team";
          version = "12.2.0";
          sha256 = "12s5br0s9n99vjn6chivzdsjb71p0lai6vnif7lv13x497dkw4rz";
        };
        meta = {
          description = "Bring real icons to your Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=vscode-icons-team.vscode-icons";
          homepage = "https://github.com/vscode-icons/vscode-icons";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.bastaynav ];
        };
      };

      vscodevim.vim = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vim";
          publisher = "vscodevim";
          version = "1.25.2";
          sha256 = "sha256-hy2Ks6oRc9io6vfgql9aFGjUiRzBCS4mGdDO3NqIFEg=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vspacecode.vspacecode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vspacecode";
          publisher = "VSpaceCode";
          version = "0.10.14";
          sha256 = "sha256-iTFwm/P2wzbNahozyLbdfokcSDHFzLrzVDHI/g2aFm0=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vspacecode.whichkey = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "whichkey";
          publisher = "VSpaceCode";
          version = "0.11.3";
          sha256 = "sha256-PnaOwOIcSo1Eff1wOtQPhoHYvrHDGTcsRy9mQfdBPX4=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      waderyan.gitblame = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "gitblame";
          publisher = "waderyan";
          version = "10.1.0";
          sha256 = "TTYBaJ4gcMVICz4bGZTvbNRPpWD4tXuAJbI8QcHNDv0=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/waderyan.gitblame/changelog";
          description = "Visual Studio Code Extension - See Git Blame info in status bar";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=waderyan.gitblame";
          homepage = "https://github.com/Sertion/vscode-gitblame";
          license = lib.licenses.mit;
        };
      };

      wakatime.vscode-wakatime = callPackage ./WakaTime.vscode-wakatime { };

      wholroyd.jinja = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "jinja";
          publisher = "wholroyd";
          version = "0.0.8";
          sha256 = "1ln9gly5bb7nvbziilnay4q448h9npdh7sd9xy277122h0qawkci";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      wingrunr21.vscode-ruby = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-ruby";
          publisher = "wingrunr21";
          version = "0.28.0";
          sha256 = "sha256-H3f1+c31x+lgCzhgTb0uLg9Bdn3pZyJGPPwfpCYrS70=";
        };

        meta.license = lib.licenses.mit;
      };

      wix.vscode-import-cost = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-import-cost";
          publisher = "wix";
          version = "3.3.0";
          sha256 = "0wl8vl8n0avd6nbfmis0lnlqlyh4yp3cca6kvjzgw5xxdc5bl38r";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      wmaurer.change-case = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "change-case";
          publisher = "wmaurer";
          version = "1.0.0";
          sha256 = "sha256-tN/jlG2PzuiCeERpgQvdqDoa3UgrUaM7fKHv6KFqujc=";
        };
        meta = {
          description = "A VSCode extension for quickly changing the case (camelCase, CONSTANT_CASE, snake_case, etc) of the current selection or current word";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=wmaurer.change-case";
          homepage = "https://github.com/wmaurer/vscode-change-case";
          license = lib.licenses.mit;
        };
      };

      xadillax.viml = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "viml";
          publisher = "xadillax";
          version = "2.1.2";
          sha256 = "sha256-n91Rj1Rpp7j7gndkt0bV+jT1nRMv7+coVoSL5c7Ii3A=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      xaver.clang-format = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "clang-format";
          publisher = "xaver";
          version = "1.9.0";
          sha256 = "abd0ef9176eff864f278c548c944032b8f4d8ec97d9ac6e7383d60c92e258c2f";
        };
        meta = {
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.zeratax ];
        };
      };

      xyz.local-history = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "local-history";
          publisher = "xyz";
          version = "1.8.1";
          sha256 = "1mfmnbdv76nvwg4xs3rgsqbxk8hw9zr1b61har9c3pbk9r4cay7v";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      yzhang.dictionary-completion = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "yzhang";
          name = "dictionary-completion";
          version = "1.2.2";
          sha256 = "sha256-dpJcJARRKzRNHfXs/qknud8OQ8xIyeaVnt/EcDq0k4E=";
        };
        meta = {
          description = "A Visual Studio Code extension to help user easyly finish long words ";
          longDescription = ''
            Dictionary completion allows user to get a list of keywords, based off of the current word at the cursor.
            This is useful if you are typing a long word (e.g. acknowledgeable) and don't want to finish typing or don't remember the Spelling
          '';
          homepage = "https://github.com/yzhang-gh/vscode-dic-completion#readme";
          changelog = "https://marketplace.visualstudio.com/items/yzhang.dictionary-completion/changelog";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=yzhang.dictionary-completion";
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [ onedragon ];
        };
      };

      yzhang.markdown-all-in-one = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "markdown-all-in-one";
          publisher = "yzhang";
          version = "3.5.1";
          sha256 = "sha256-ZyvkRp0QTjoMEXRGHzp3udGngYcU9EkTCvx8o2CEaBE=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      zhuangtongfa.material-theme = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "material-theme";
          publisher = "zhuangtongfa";
          version = "3.15.8";
          sha256 = "sha256-PwWGs9KRfV3qpYbgdiw8FYvnkaJQ2VW2H6p6+umk7eg=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      zhwu95.riscv = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "riscv";
          publisher = "zhwu95";
          version = "0.0.8";
          sha256 = "sha256-PXaHSEXoN0ZboHIoDg37tZ+Gv6xFXP4wGBS3YS/53TY=";
        };
        meta = {
          description = "Basic RISC-V colorization and snippets support.";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=zhwu95.riscv";
          homepage = "https://github.com/zhuanhao-wu/vscode-riscv-support";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.CardboardTurkey ];
        };
      };

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
    };

  aliases = super: {
    _1Password = super."1Password";
    _2gua = super."2gua";
    _4ops = super."4ops";
    Arjun.swagger-viewer = super.arjun.swagger-viewer;
    jakebecker.elixir-ls = super.elixir-lsp.vscode-elixir-ls;
    jpoissonnier.vscode-styled-components = super.styled-components.vscode-styled-components;
    matklad.rust-analyzer = super.rust-lang.rust-analyzer; # Previous publisher
    ms-vscode.go = super.golang.go;
    ms-vscode.PowerShell = super.ms-vscode.powershell;
    rioj7.commandOnAllFiles = super.rioj7.commandonallfiles;
    WakaTime.vscode-wakatime = super.wakatime.vscode-wakatime;
  };

  # TODO: add overrides overlay, so that we can have a generated.nix
  # then apply extension specific modifcations to packages.

  # overlays will be applied left to right, overrides should come after aliases.
  overlays = lib.optionals config.allowAliases [
    (self: super: lib.recursiveUpdate super (aliases super))
  ];

  toFix = lib.foldl' (lib.flip lib.extends) baseExtensions overlays;
in
lib.fix toFix
