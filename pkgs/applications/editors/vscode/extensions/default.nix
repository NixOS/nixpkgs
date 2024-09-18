# Before adding a new extension, read ./README.md

{
  autoPatchelfHook,
  callPackage,
  config,
  fetchurl,
  jdk,
  jq,
  lib,
  llvmPackages,
  llvmPackages_14,
  moreutils,
  protobuf,
  python3Packages,
  stdenv,
  vscode-utils,
  zlib,
}:

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;

  baseExtensions =
    self:
    lib.mapAttrs (_n: lib.recurseIntoAttrs) {
      "13xforever".language-x86-64-assembly = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "language-x86-64-assembly";
          publisher = "13xforever";
          version = "3.1.4";
          hash = "sha256-FJRDm1H3GLBfSKBSFgVspCjByy9m+j9OStlU+/pMfs8=";
        };
        meta = {
          description = "Cutting edge x86 and x86_64 assembly syntax highlighting";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=13xforever.language-x86-64-assembly";
          homepage = "https://github.com/13xforever/x86_64-assembly-vscode";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.themaxmur ];
        };
      };

      "1Password".op-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "1Password";
          name = "op-vscode";
          version = "1.0.4";
          hash = "sha256-s6acue8kgFLf5fs4A7l+IYfhibdY76cLcIwHl+54WVk=";
        };
        meta = {
          changelog = "https://github.com/1Password/op-vscode/releases";
          description = "VSCode extension that integrates your development workflow with 1Password service";
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
          description = "Visual Studio Code extension providing rainbow brackets";
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
          hash = "sha256-y5LljxK8V9Fir9EoG8g9N735gISrlMg3czN21qF/KjI=";
        };
        meta = {
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.kamadorueda ];
        };
      };

      "42crunch".vscode-openapi = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "42Crunch";
          name = "vscode-openapi";
          version = "4.27.0";
          hash = "sha256-urXGyHpIDWQ0Bc+8LODC0DcEo6jQ5tA/QptyxCej9yU=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/42Crunch.vscode-openapi/changelog";
          description = "Visual Studio Code extension with rich support for the OpenAPI Specification (OAS)";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=42Crunch.vscode-openapi";
          homepage = "https://github.com/42Crunch/vscode-openapi";
          license = lib.licenses.gpl3;
          maintainers = [ lib.maintainers.benhiemer ];
        };
      };

      a5huynh.vscode-ron = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-ron";
          publisher = "a5huynh";
          version = "0.10.0";
          hash = "sha256-DmyYE7RHOX/RrbIPYCq/x0l081SzmyBAd7yHSUOPkOA=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      aaron-bond.better-comments = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "better-comments";
          publisher = "aaron-bond";
          version = "3.0.2";
          sha256 = "850980f0f5a37f635deb4bf9100baaa83f0b204bbbb25acdb3c96e73778f8197";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/aaron-bond.better-comments/changelog";
          description = "Improve your code commenting by annotating with alert, informational, TODOs, and more!";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=aaron-bond.better-comments";
          homepage = "https://github.com/aaron-bond/better-comments";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.DataHearth ];
        };
      };

      adpyke.codesnap = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "codesnap";
          publisher = "adpyke";
          version = "1.3.4";
          hash = "sha256-dR6qODSTK377OJpmUqG9R85l1sf9fvJJACjrYhSRWgQ=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      adzero.vscode-sievehighlight = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-sievehighlight";
          publisher = "adzero";
          version = "1.0.6";
          hash = "sha256-8Ompv792eI2kIH+5+KPL9jAf88xsMGQewHEQwi8BhoQ=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/adzero.vscode-sievehighlight/changelog";
          description = "Visual Studio Code extension to enable syntax highlight support for Sieve mail filtering language";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=adzero.vscode-sievehighlight";
          homepage = "https://github.com/adzero/vscode-sievehighlight";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.sebtm ];
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

      albymor.increment-selection = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "increment-selection";
          publisher = "albymor";
          version = "0.2.0";
          hash = "sha256-iP4c0xLPiTsgD8Q8Kq9jP54HpdnBveKRY31Ro97ROJ8=";
        };
        meta = {
          description = "Increment, decrement or reverse selection with multiple cursors";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=albymor.increment-selection";
          homepage = "https://github.com/albymor/Increment-Selection";
          license = lib.licenses.mit;
        };
      };

      alefragnani.bookmarks = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "bookmarks";
          publisher = "alefragnani";
          version = "13.3.1";
          hash = "sha256-CZSFprI8HMQvc8P9ZH+m0j9J6kqmSJM1/Ik24ghif2A=";
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
          hash = "sha256-rBMwvm7qUI6zBrXdYntQlY8WvH2fDBhEuQ1pHDl9fQg=";
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

      alexisvt.flutter-snippets = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "flutter-snippets";
          publisher = "alexisvt";
          version = "3.0.0";
          sha256 = "44ac46f826625f0a4aec40f2542f32c161e672ff96f45a548d0bccd9feed04ef";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/alexisvt.flutter-snippets/changelog";
          description = "Set of helpful widget snippets for day to day Flutter development";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=alexisvt.flutter-snippets";
          homepage = "https://github.com/Alexisvt/flutter-snippets";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.DataHearth ];
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
          hash = "sha256-ho3DtXAAafY/mpUcea2OPhy8tpX+blJMyVxbFVUsspk=";
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
          hash = "sha256-R8eHLuebfgHaKtHPKBaaYybotluuH9WrUBpgyuIVOxc=";
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
          hash = "sha256-MNQMOT9LaEVZqelvikBTpUPTsSIA2z5qvLxw51aJw1w=";
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
          version = "2.2.0";
          hash = "sha256-9CKm9SLotPlwkAELb7Us/blK959HVt6eXiDp0fgVLmA=";
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
          hash = "sha256-awbqFv6YuYI0tzM/QbHRTUl4B2vNUdy52F4nPmv+dRU=";
        };
        meta = {
          description = "Arctic, north-bluish clean and elegant Visual Studio Code theme";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=arcticicestudio.nord-visual-studio-code";
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
          version = "1.0.10";
          hash = "sha256-b3Sr0bwU2VJgl2qcdsUROZ3jnK+YUuzJMySvSD7goj8=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      asciidoctor.asciidoctor-vscode = callPackage ./asciidoctor.asciidoctor-vscode { };

      asdine.cue = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "cue";
          publisher = "asdine";
          version = "0.3.2";
          hash = "sha256-jMXqhgjRdM3UG/9NtiwWAg61mBW8OYVAKDWgb4hzhA4=";
        };
        meta = {
          description = "Cue language support for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=asdine.cue";
          homepage = "https://github.com/asdine/vscode-cue";
          changelog = "https://marketplace.visualstudio.com/items/asdine.cue/changelog";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.matthewpi ];
        };
      };

      astro-build.astro-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "astro-vscode";
          publisher = "astro-build";
          version = "2.10.2";
          hash = "sha256-lmqbZnCpkNN+i877hURRkPuRtuxRKD29bDppGBAEMGs=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/astro-build.astro-vscode/changelog";
          description = "Astro language support for VS Code";
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
          version = "1.18.11";
          hash = "sha256-j1igEItS4TT1WxSxK3tFG29McTTo8ojEs6TJShGZiGI=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/asvetliakov.vscode-neovim/changelog";
          description = "Vim-mode for VS Code using embedded Neovim";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim";
          license = lib.licenses.mit;
          homepage = "https://github.com/vscode-neovim/vscode-neovim";
          maintainers = [ lib.maintainers.mikaelfangel ];
        };
      };

      attilabuti.brainfuck-syntax = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "brainfuck-syntax";
          publisher = "attilabuti";
          version = "0.0.1";
          hash = "sha256-ZcZlHoa2aoCeruMWbUUgfFHsPqyWmd2xFY6AKxJysYE=";
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

      azdavis.millet = callPackage ./azdavis.millet { };

      b4dm4n.vscode-nixpkgs-fmt = callPackage ./b4dm4n.vscode-nixpkgs-fmt { };

      baccata.scaladex-search = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "scaladex-search";
          publisher = "baccata";
          version = "0.3.3";
          hash = "sha256-+793uA+cSBHV6t4wAM4j4GeWggLJTl2GENkn8RFIwr0=";
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
          hash = "sha256-D04EJButnam/l4aAv1yNbHlTKMb3x1yrS47+9XjpCLI=";
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
          hash = "sha256-79Yg4I0OkfG7PaDYnTA8HK8jrSxre4FGriq0Baiq7wA=";
        };
        meta = {
          description = "Visual Studio Code extension for Spellchecker";
          changelog = "https://marketplace.visualstudio.com/items/ban.spellright/changelog";
          homepage = "https://github.com/bartosz-antosik/vscode-spellright";
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [ onedragon ];
        };
      };

      banacorn.agda-mode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "banacorn";
          name = "agda-mode";
          version = "0.4.7";
          hash = "sha256-gNa3n16lP3ooBRvGaugTua4IXcIzpMk7jBYMJDQsY00=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/banacorn.agda-mode/changelog";
          description = "agda-mode on VS Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=banacorn.agda-mode";
          homepage = "https://github.com/banacorn/agda-mode-vscode";
          maintainers = with lib.maintainers; [ Anillc ];
          license = lib.licenses.mit;
        };
      };

      batisteo.vscode-django = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "batisteo";
          name = "vscode-django";
          version = "1.10.0";
          hash = "sha256-vTaE3KhG5i2jGc5o33u76RUUFYaW4s4muHvph48HeQ4=";
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

      bazelbuild.vscode-bazel = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-bazel";
          publisher = "bazelbuild";
          version = "0.10.0";
          sha256 = "sha256-8SUOzsUmfgt9fAy037qLVNrGJPvTnIeMNz2tbN5psbs=";
        };
        meta = {
          description = "Bazel support for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=BazelBuild.vscode-bazel";
          homepage = "https://github.com/bazelbuild/vscode-bazel";
          license = lib.licenses.asl20;
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
          hash = "sha256-IDM9v+LWckf20xnRTj+ThAFSzVxxDVQaJkwO37UIIhs=";
        };
        meta = {
          license = lib.licenses.asl20;
        };
      };

      betterthantomorrow.calva = callPackage ./betterthantomorrow.calva { };

      bierner.comment-tagged-templates = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "comment-tagged-templates";
          publisher = "bierner";
          version = "0.3.3";
          hash = "sha256-M2XdMQ2l6oMYiHTdfRJ/n/Ys3LecEPwAozQtLBcn7FY=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/bierner.comment-tagged-templates/changelog";
          description = "VS Code extension that adds basic syntax highlighting for JavaScript and TypeScript tagged template strings using language identifier comments";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=bierner.comment-tagged-templates";
          homepage = "https://github.com/mjbvz/vscode-comment-tagged-templates";
          license = lib.licenses.mit;
        };
      };

      bierner.docs-view = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "docs-view";
          publisher = "bierner";
          version = "0.0.11";
          hash = "sha256-3njIL2SWGFp87cvQEemABJk2nXzwI1Il/WG3E0ZYZxw=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/bierner.docs-view/changelog";
          description = "VSCode extension that displays documentation in the sidebar or panel";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=bierner.docs-view";
          homepage = "https://github.com/mattbierner/vscode-docs-view#readme";
          license = lib.licenses.mit;
        };
      };

      bierner.emojisense = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "emojisense";
          publisher = "bierner";
          version = "0.10.0";
          hash = "sha256-PD8edYuJu6QHPYIM08kV85LuKh0H0/MIgFmMxSJFK5M=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      bierner.github-markdown-preview = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "github-markdown-preview";
          publisher = "bierner";
          version = "0.3.0";
          hash = "sha256-7pbl5OgvJ6S0mtZWsEyUzlg+lkUhdq3rkCCpLsvTm4g=";
        };
        meta = {
          description = "A VSCode extension that changes the markdown preview to support GitHub markdown features";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=bierner.github-markdown-preview";
          homepage = "https://github.com/mjbvz/vscode-github-markdown-preview";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.pandapip1 ];
        };
      };

      bierner.markdown-checkbox = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "markdown-checkbox";
          publisher = "bierner";
          version = "0.4.0";
          hash = "sha256-AoPcdN/67WOzarnF+GIx/nans38Jan8Z5D0StBWIbkk=";
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
          hash = "sha256-rw8/HeDA8kQuiPVDpeOGw1Mscd6vn4utw1Qznsd8lVI=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      bierner.markdown-footnotes = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "markdown-footnotes";
          publisher = "bierner";
          version = "0.1.1";
          hash = "sha256-h/Iyk8CKFr0M5ULXbEbjFsqplnlN7F+ZvnUTy1An5t4=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/bierner.markdown-footnotes/changelog";
          description = "Adds [^1] footnote syntax support to VS Code's built-in Markdown preview";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=bierner.markdown-footnotes";
          homepage = "https://github.com/mjbvz/vscode-markdown-footnotes";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.uncenter ];
        };
      };

      bierner.markdown-mermaid = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "markdown-mermaid";
          publisher = "bierner";
          version = "1.23.1";
          hash = "sha256-hYWSeBXhqMcMxs+Logl5zRs4MlzBeHgCC07Eghmp0OM=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/bierner.markdown-mermaid/changelog";
          description = "Adds Mermaid diagram and flowchart support to VS Code's builtin markdown preview";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=bierner.markdown-mermaid";
          homepage = "https://github.com/mjbvz/vscode-markdown-mermaid";
          license = lib.licenses.mit;
        };
      };

      bierner.markdown-preview-github-styles = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "markdown-preview-github-styles";
          publisher = "bierner";
          version = "2.0.4";
          hash = "sha256-jJulxvjMNsqQqmsb5szQIAUuLWuHw824Caa0KArjUVw=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/bierner.markdown-preview-github-styles/changelog";
          description = "Changes VS Code's built-in markdown preview to match GitHub's styling";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=bierner.markdown-preview-github-styles";
          homepage = "https://github.com/mjbvz/vscode-github-markdown-preview-style";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.uncenter ];
        };
      };

      biomejs.biome = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "biome";
          publisher = "biomejs";
          version = "2024.5.251958";
          hash = "sha256-Pxbvj6e3nRwuLKmPEtE02JdHmZbyuXNh4T+FZKjBkWo=";
        };
        meta = {
          changelog = "https://github.com/biomejs/biome-vscode/blob/main/CHANGELOG.md";
          description = "Biome LSP extension for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=biomejs.biome";
          homepage = "https://github.com/biomejs/biome-vscode";
          license = with lib.licenses; [
            mit
            # or
            asl20
          ];
          maintainers = [ lib.maintainers.uncenter ];
        };
      };

      bmalehorn.vscode-fish = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-fish";
          publisher = "bmalehorn";
          version = "1.0.38";
          hash = "sha256-QEifCTlzYMX+5H6+k2o1lsQrhW3vxVpn+KFg/3WVVFo=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/bmalehorn.vscode-fish/changelog";
          description = "Fish syntax highlighting and formatting for VS Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=bmalehorn.vscode-fish";
          homepage = "https://github.com/bmalehorn/vscode-fish";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.uncenter ];
        };
      };

      bmewburn.vscode-intelephense-client = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-intelephense-client";
          publisher = "bmewburn";
          version = "1.12.5";
          hash = "sha256-2Tamwag4KovIOKTe/g4qePVDFxm0mgsLtPNdWcKzigI=";
        };
        meta = {
          description = "PHP code intelligence for Visual Studio Code";
          license = lib.licenses.unfree;
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=bmewburn.vscode-intelephense-client";
          maintainers = [ lib.maintainers.drupol ];
        };
      };

      bodil.file-browser = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "file-browser";
          publisher = "bodil";
          version = "0.2.11";
          hash = "sha256-yPVhhsAUZxnlhj58fXkk+yhxop2q7YJ6X4W9dXGKJfo=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      bradgashler.htmltagwrap = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "bradgashler";
          name = "htmltagwrap";
          version = "1.0.0";
          hash = "sha256-WOMfwxyeDLoSwF0xz9tbntDVrUWycJ4bW0rZjfLSzgM=";
        };
        meta = {
          changelog = "https://github.com/bgashler1/vscode-htmltagwrap/blob/master/CHANGELOG.md";
          description = "VSCode extension for wrapping a text selection in HTML tags";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=bradgashler.htmltagwrap";
          homepage = "https://github.com/bgashler1/vscode-htmltagwrap";
          license = lib.licenses.mit;
          maintainers = [ ];
        };
      };

      bradlc.vscode-tailwindcss = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-tailwindcss";
          publisher = "bradlc";
          version = "0.13.17";
          hash = "sha256-hcFBMYfexNB7NMf3C7BQVTps1CBesEOxU3mW2cKXDHc=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/bradlc.vscode-tailwindcss/changelog";
          description = "Tailwind CSS tooling for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=bradlc.vscode-tailwindcss";
          homepage = "https://github.com/tailwindlabs/tailwindcss-intellisense";
          license = lib.licenses.mit;
        };
      };

      brandonkirbyson.solarized-palenight = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "solarized-palenight";
          publisher = "BrandonKirbyson";
          version = "1.0.1";
          hash = "sha256-vVbaHSaBX6QzpnYMQlpPsJU1TQYJEBe8jq95muzwN0o=";
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
          hash = "sha256-g+LfgjAnSuSj/nSmlPdB0t29kqTmegZB5B1cYzP8kCI=";
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

      carrie999.cyberpunk-2020 = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "cyberpunk-2020";
          publisher = "carrie999";
          version = "0.1.4";
          hash = "sha256-tVbd+j9+90Z07+jGAiT0gylZN9YWHdJmq2sh1wf2oGE=";
        };
        meta = {
          description = "Cyberpunk-inspired colour theme to satisfy your neon dreams";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=carrie999.cyberpunk-2020";
          homepage = "https://github.com/Carrie999/cyberpunk";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.d3vil0p3r ];
        };
      };

      catppuccin = {
        catppuccin-vsc = buildVscodeMarketplaceExtension {
          mktplcRef = {
            name = "catppuccin-vsc";
            publisher = "catppuccin";
            version = "3.14.0";
            hash = "sha256-kNQFR1ghdFJF4XLWCFgVpeXCZ/XiHGr/O1iJyWTT3Bg=";
          };
          meta = {
            changelog = "https://marketplace.visualstudio.com/items/Catppuccin.catppuccin-vsc/changelog";
            description = "Soothing pastel theme for VSCode";
            downloadPage = "https://marketplace.visualstudio.com/items?itemName=Catppuccin.catppuccin-vsc";
            homepage = "https://github.com/catppuccin/vscode";
            license = lib.licenses.mit;
            maintainers = [ ];
          };
        };
        catppuccin-vsc-icons = buildVscodeMarketplaceExtension {
          mktplcRef = {
            name = "catppuccin-vsc-icons";
            publisher = "catppuccin";
            version = "1.13.0";
            hash = "sha256-4gsblUMcN7a7UgoklBjc+2uiaSERq1vmi0exLht+Xi0=";
          };
          meta = {
            changelog = "https://marketplace.visualstudio.com/items/Catppuccin.catppuccin-vsc-icons/changelog";
            description = "Soothing pastel icon theme for VSCode";
            downloadPage = "https://marketplace.visualstudio.com/items?itemName=Catppuccin.catppuccin-vsc-icons";
            homepage = "https://github.com/catppuccin/vscode-icons";
            license = lib.licenses.mit;
            maintainers = [ lib.maintainers.laurent-f1z1 ];
          };
        };
      };

      charliermarsh.ruff = callPackage ./charliermarsh.ruff { };

      cameron.vscode-pytest = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-pytest";
          publisher = "Cameron";
          version = "0.1.1";
          hash = "sha256-YU37a0Q+IXusXgwf9doxXLlYiyzkizbPjjdCZFxeDaA=";
        };
        meta = {
          changelog = "https://github.com/cameronmaske/pytest-vscode/blob/master/CHANGELOG.md";
          description = "Visual Studio Code extension that adds IntelliSense support for pytest fixtures";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=Cameron.vscode-pytest";
          license = lib.licenses.unlicense;
          maintainers = [ lib.maintainers.rhoriguchi ];
        };
      };

      christian-kohler.npm-intellisense = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "npm-intellisense";
          publisher = "christian-kohler";
          version = "1.4.5";
          sha256 = "962b851a7cafbd51f34afeb4a0b91e985caff3947e46218a12b448533d8f60ab";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/christian-kohler.npm-intellisense/changelog";
          description = "Visual Studio Code plugin that autocompletes npm modules in import statements";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=christian-kohler.npm-intellisense";
          homepage = "https://github.com/ChristianKohler/NpmIntellisense";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.DataHearth ];
        };
      };

      chenglou92.rescript-vscode = callPackage ./chenglou92.rescript-vscode { };

      chris-hayes.chatgpt-reborn = buildVscodeMarketplaceExtension {
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/chris-hayes.chatgpt-reborn/changelog";
          description = "Visual Studio Code extension to support ChatGPT, GPT-3 and Codex conversations";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=chris-hayes.chatgpt-reborn";
          homepage = "https://github.com/christopher-hayes/vscode-chatgpt-reborn";
          license = lib.licenses.isc;
          maintainers = [ lib.maintainers.drupol ];
        };
        mktplcRef = {
          name = "chatgpt-reborn";
          publisher = "chris-hayes";
          version = "3.19.1";
          sha256 = "1msb3lqy9p2v26nsw0clfsisiwxcid3jp1l6549hk1i1gcqhd84w";
        };
      };

      christian-kohler.path-intellisense = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "path-intellisense";
          publisher = "christian-kohler";
          version = "2.8.5";
          sha256 = "1ndffv1m4ayiija1l42m28si44vx9y6x47zpxzqv2j4jj7ga1n5z";
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
          version = "0.1.36";
          hash = "sha256-N1X8wB2n6JYoFHCP5iHBXHnEaRa9S1zooQZsR5mUeh8=";
        };
        meta = {
          description = "Extension for Visual Studio Code to open any Coder workspace in VS Code with a single click";
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
          hash = "sha256-IHoF+c8Rsi6WnXoCX7x3wKyuMwLh14nbL9sNVJHogHM=";
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
          hash = "sha256-blqLK7S+RmEoyr9zktS5/SNC0GeSXnNpbhltyajoAfw=";
        };
        meta = {
          description = "Visual Studio Code extension to provide purely hover translation";
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
          hash = "sha256-D5zLp3ruq0F9UFT9emgOBDLr1tya2Vw52VvCc40TtV0=";
        };
        meta = {
          description = "Lightweight syntax highlighting for LLVM IR";
          homepage = "https://github.com/colejcummins/llvm-syntax-highlighting";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=colejcummins.llvm-syntax-highlighting";
          maintainers = [ lib.maintainers.inclyc ];
          license = lib.licenses.mit;
        };
      };

      contextmapper.context-mapper-vscode-extension =
        callPackage ./contextmapper.context-mapper-vscode-extension
          { };

      continue.continue = buildVscodeMarketplaceExtension {
        mktplcRef =
          let
            sources = {
              "x86_64-linux" = {
                arch = "linux-x64";
                hash = "sha256-X6Oszc88F0ENABwX63uwxbJ4VPQOQzZbJA87znVg5d8=";
              };
              "x86_64-darwin" = {
                arch = "darwin-x64";
                hash = "sha256-NH3kGmNZpKofNplw+FRJFvV3m36HRuIqGR3zt6X5x60=";
              };
              "aarch64-linux" = {
                arch = "linux-arm64";
                hash = "sha256-hlFAMz17cl2/1CK7/dgrLktcPZYAcccIWIpkAVdwpkI=";
              };
              "aarch64-darwin" = {
                arch = "darwin-arm64";
                hash = "sha256-oVkmdw0sHv5Y+ysT4zWW6qFDh/h4/TcgSAauh1KrE1c=";
              };
            };
          in
          {
            name = "continue";
            publisher = "Continue";
            version = "0.8.44";
          }
          // sources.${stdenv.system};
        nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];
        buildInputs = [ stdenv.cc.cc.lib ];
        meta = {
          description = "Open-source autopilot for software development - bring the power of ChatGPT to your IDE";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=Continue.continue";
          homepage = "https://github.com/continuedev/continue";
          license = lib.licenses.asl20;
          maintainers = [ lib.maintainers.raroh73 ];
          platforms = [
            "x86_64-linux"
            "x86_64-darwin"
            "aarch64-darwin"
            "aarch64-linux"
          ];
        };
      };

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

      csharpier.csharpier-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "csharpier-vscode";
          publisher = "csharpier";
          version = "1.7.3";
          hash = "sha256-/ZLjnlLl6xmgEazdCbnuE6UuuV1tDwAjpxz+vmBuYHE=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/csharpier.csharpier-vscode/changelog";
          description = "CSharpier code formatter for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=csharpier.csharpier-vscode";
          homepage = "https://github.com/belav/csharpier";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.magnouvean ];
        };
      };

      cweijan.dbclient-jdbc = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "dbclient-jdbc";
          publisher = "cweijan";
          version = "1.3.4";
          hash = "sha256-qknooeedRhTvEWSuGXFoO/BczGanYCdMr7WWjthxG+k=";
        };
        meta = {
          description = "JDBC Adapter For Database Client";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=cweijan.dbclient-jdbc";
          homepage = "https://github.com/database-client/jdbc-adapter-server";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.themaxmur ];
        };
      };

      cweijan.vscode-database-client2 = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-database-client2";
          publisher = "cweijan";
          version = "6.3.0";
          hash = "sha256-BFTY3NZQd6XTE3UNO1bWo/LiM4sHujFGOSufDLD4mzM=";
        };
        meta = {
          description = "Database Client For Visual Studio Code";
          homepage = "https://marketplace.visualstudio.com/items?itemName=cweijan.vscode-mysql-client2";
          license = lib.licenses.mit;
        };
      };

      danielgavin.ols = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "DanielGavin";
          name = "ols";
          version = "0.1.28";
          hash = "sha256-yVXltjvtLc+zqela/Jyg+g66PU61+YTMX1hWPW8fIkk=";
        };
        meta = {
          description = "Visual Studio Code extension for Odin language";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=DanielGavin.ols";
          homepage = "https://github.com/DanielGavin/ols";
          license = lib.licenses.mit;
        };
      };

      danielsanmedium.dscodegpt = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "DanielSanMedium";
          name = "dscodegpt";
          version = "3.4.10";
          hash = "sha256-zjaM9YME0wfBOwhJTacnQbQvw35QL5NvXIBAx5d/bjI=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/DanielSanMedium.dscodegpt/changelog";
          description = "Easily connect to AI providers using their official APIs in VSCode";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=DanielSanMedium.dscodegpt";
          homepage = "https://codegpt.co";
          license = lib.licenses.unfree;
          maintainers = [ lib.maintainers.onny ];
        };
      };

      daohong-emilio.yash = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "daohong-emilio";
          name = "yash";
          version = "0.2.9";
          hash = "sha256-5JX6Z7xVPoqGjD1/ySc9ObD14O1sWDpvBj9VbtGO1Cg=";
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
          hash = "sha256-VVQ32heyzLjM5HdeNAK5PwqB1NsSQ9iQJBwJiJXlu+g=";
        };

        meta.license = lib.licenses.mit;
      };

      dart-code.flutter = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "flutter";
          publisher = "dart-code";
          version = "3.61.20230301";
          hash = "sha256-t4AfFgxVCl15YOz7NTULvNUcyuiQilEP6jPK4zMAAmc=";
        };

        meta.license = lib.licenses.mit;
      };

      databricks.databricks = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "databricks";
          publisher = "databricks";
          version = "2.3.1";
          hash = "sha256-Qa839ygG8Z3aD/ZSshe2hg0ee3ZFU8xRrJ5E0cUjfCU=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/databricks.databricks/changelog";
          description = "Databricks extension for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=databricks.databricks";
          homepage = "https://github.com/databricks/databricks-vscode";
          license = lib.licenses.databricks-license;
          maintainers = [ lib.maintainers.softinio ];
        };
      };

      davidanson.vscode-markdownlint = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-markdownlint";
          publisher = "DavidAnson";
          version = "0.55.0";
          hash = "sha256-slfHfRPcuRu+649n6kAr2bv9H6J+DvYVN/ysq1QpPQM=";
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
          hash = "sha256-crq6CTXpzwHJL8FPIBneAGjDgUUNdpBt6rIaMCr1F1U=";
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
          version = "3.0.10";
          hash = "sha256-EVmexnTIQQDmj25/rql3eCfJd47zRui3TpHol6l0Vgs=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/dbaeumer.vscode-eslint/changelog";
          description = "Integrates ESLint JavaScript into VS Code";
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
          version = "3.38.0";
          hash = "sha256-wmcMkX1gmFhE6JukvOI3fez05dP7ZFAZz1OxmV8uu4k=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/denoland.vscode-deno/changelog";
          description = "Language server client for Deno";
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
          version = "1.41.14332";
          hash = "sha256-qRgncn6u40Igd40OZShRHXqdgjFqRLNb0hPirwc+DoU=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/DEVSENSE.composer-php-vscode/changelog";
          description = "Visual studio code extension for full development integration for Composer, the PHP package manager";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=DEVSENSE.composer-php-vscode";
          homepage = "https://github.com/DEVSENSE/phptools-docs";
          license = lib.licenses.unfree;
          maintainers = [ lib.maintainers.drupol ];
        };
      };

      devsense.phptools-vscode = buildVscodeMarketplaceExtension {
        mktplcRef =
          let
            sources = {
              "x86_64-linux" = {
                arch = "linux-x64";
                hash = "sha256-8i5nRlzd+LnpEh9trWECxfiC1W4S0ekBab5vo18OlsA=";
              };
              "x86_64-darwin" = {
                arch = "darwin-x64";
                sha256 = "14crw56277rdwhigabb3nsndkfcs3yzzf7gw85jvryxviq32chgy";
              };
              "aarch64-linux" = {
                arch = "linux-arm64";
                sha256 = "1j1xlvbg3nrfmdd9zm6kywwicdwdkrq0si86lcndaii8m7sj5pfp";
              };
              "aarch64-darwin" = {
                arch = "darwin-arm64";
                sha256 = "0nlks6iqxkx1xlicsa8lrb1319rgznlxkv2gg7wkwgzph97ik8bi";
              };
            };
          in
          {
            name = "phptools-vscode";
            publisher = "devsense";
            version = "1.41.14332";
          }
          // sources.${stdenv.system};

        nativeBuildInputs = [ autoPatchelfHook ];

        buildInputs = [
          zlib
          stdenv.cc.cc.lib
        ];

        postInstall = ''
          chmod +x $out/share/vscode/extensions/devsense.phptools-vscode/out/server/devsense.php.ls
        '';

        meta = {
          changelog = "https://marketplace.visualstudio.com/items/DEVSENSE.phptools-vscode/changelog";
          description = "Visual studio code extension for full development integration for the PHP language";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=DEVSENSE.phptools-vscode";
          homepage = "https://github.com/DEVSENSE/phptools-docs";
          license = lib.licenses.unfree;
          maintainers = [ lib.maintainers.drupol ];
          platforms = [
            "x86_64-linux"
            "x86_64-darwin"
            "aarch64-darwin"
            "aarch64-linux"
          ];
        };
      };

      devsense.profiler-php-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "profiler-php-vscode";
          publisher = "devsense";
          version = "1.41.14332";
          hash = "sha256-u2lNqG6FUhWnnNGtv+sjTbP/hbu4Da/8xjLzmPZkZOA=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/DEVSENSE.profiler-php-vscode/changelog";
          description = "Visual studio code extension for PHP and XDebug profiling and inspecting";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=DEVSENSE.profiler-php-vscode";
          homepage = "https://github.com/DEVSENSE/phptools-docs";
          license = lib.licenses.unfree;
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
        meta = {
          license = lib.licenses.mit;
        };
      };

      dhall.vscode-dhall-lsp-server = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-dhall-lsp-server";
          publisher = "dhall";
          version = "0.0.4";
          sha256 = "1zin7s827bpf9yvzpxpr5n6mv0b5rhh3civsqzmj52mdq365d2js";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      dhedgecock.radical-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "radical-vscode";
          publisher = "dhedgecock";
          version = "3.3.1";
          hash = "sha256-VvFQovuE+I0lqXU9fHrmk7nWMpuuWafqm9Acwb0+QYg=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/dhedgecock.radical-vscode/changelog";
          description = "Dark theme for radical hacking inspired by retro futuristic design";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=dhedgecock.radical-vscode";
          homepage = "https://github.com/dhedgecock/radical-vscode";
          license = lib.licenses.isc;
          maintainers = [ lib.maintainers.d3vil0p3r ];
        };
      };

      discloud.discloud = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "discloud";
          name = "discloud";
          version = "2.21.2";
          hash = "sha256-es1WjKchxC2hIWOkIRuf5MqMjTYu6qcBgo8abCqTjFc=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/discloud.discloud/changelog";
          description = "Visual Studio Code extension for hosting and managing applications on Discloud";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=discloud.discloud";
          homepage = "https://github.com/discloud/vscode-discloud";
          license = lib.licenses.asl20;
          maintainers = [ lib.maintainers.diogomdp ];
        };
      };

      disneystreaming.smithy = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "disneystreaming";
          name = "smithy";
          version = "0.0.8";
          hash = "sha256-BQPiSxiPPjdNPtIJI8L+558DVKxngPAI9sscpcJSJUI=";
        };
        meta = {
          license = lib.licenses.asl20;
        };
      };

      divyanshuagrawal.competitive-programming-helper = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "competitive-programming-helper";
          publisher = "DivyanshuAgrawal";
          version = "5.10.0";
          hash = "sha256-KALTldVaptKt8k2Y6PMqhJEMrayB4yn86x2CxHn6Ba0=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/DivyanshuAgrawal.competitive-programming-helper/changelog";
          description = "Makes judging, compiling, and downloading problems for competitve programming easy. Also supports auto-submit for a few sites";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=DivyanshuAgrawal.competitive-programming-helper";
          homepage = "https://github.com/agrawal-d/cph";
          license = lib.licenses.gpl3;
          maintainers = [ lib.maintainers.arcticlimer ];
        };
      };

      donjayamanne.githistory = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "githistory";
          publisher = "donjayamanne";
          version = "0.6.20";
          hash = "sha256-nEdYS9/cMS4dcbFje23a47QBZr9eDK3dvtkFWqA+OHU=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/donjayamanne.githistory/changelog";
          description = "View git log, file history, compare branches or commits";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=donjayamanne.githistory";
          homepage = "https://github.com/DonJayamanne/gitHistoryVSCode/";
          license = lib.licenses.mit;
          maintainers = [ ];
        };
      };

      dotenv.dotenv-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "dotenv-vscode";
          publisher = "dotenv";
          version = "0.28.0";
          hash = "sha256-KiQgFvbfLsA/ADROoG6y6c/i0XHuTNH2AN+6mWEm0P8=";
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
          version = "2.24.3";
          hash = "sha256-3B18lEu8rXVXySdF3+xsPnAyruIuEQJDhlNw82Xm6b0=";
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
          version = "15.1.0";
          hash = "sha256-xGgm/WNJDIh/Bs11fLYwHQ9ULiZBWbKw4QYl/l4KYJ4=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/eamodio.gitlens/changelog";
          description = "Visual Studio Code extension that improves its built-in Git capabilities";
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

      earthly.earthfile-syntax-highlighting = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "earthfile-syntax-highlighting";
          publisher = "earthly";
          version = "0.0.16";
          sha256 = "c54d6fd4d2f503a1031be92ff118b5eb1b997907511734e730e08b1a90a6960f";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/earthly.earthfile-syntax-highlighting/changelog";
          description = "Syntax highlighting for Earthly build Earthfiles";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=earthly.earthfile-syntax-highlighting";
          homepage = "https://github.com/earthly/earthfile-grammar";
          license = lib.licenses.mpl20;
          maintainers = [ lib.maintainers.DataHearth ];
        };
      };

      ecmel.vscode-html-css = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-html-css";
          publisher = "ecmel";
          version = "2.0.9";
          sha256 = "7c30d57d2ff9986bd5daa2c9f51ec4bb04239ca23a51e971a63f7b93d005d297";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/ecmel.vscode-html-css/changelog";
          description = "CSS Intellisense for HTML";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ecmel.vscode-html-css";
          homepage = "https://github.com/ecmel/vscode-html-css";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.DataHearth ];
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
          hash = "sha256-Fq0KgW5N6urj8hMUs6Spidy47jwIkpkmBUlpXMVnq7s=";
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
          hash = "sha256-k6DtmhYBj7mg8SUU3pg+ezRzWvhiECqYQVj9LDhhV4I=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      elixir-lsp.vscode-elixir-ls = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "elixir-ls";
          publisher = "JakeBecker";
          version = "0.23.1";
          hash = "sha256-rwpaixQbuxVkH4wlKPG4Qk69IylwjfCtyfUcqCuN/e8=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/JakeBecker.elixir-ls/changelog";
          description = "Elixir support with debugger, autocomplete, and more. Powered by ElixirLS";
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
          hash = "sha256-iNFc7YJFl3d4/BJE9TPJfL0iqEkUtyEyVt4v1J2bXts=";
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
          hash = "sha256-cywFx33oTQZxFUxL9qCpV12pV2tP0ujR4osCdtSOOTc=";
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
          hash = "sha256-GwuFtBVj0Z2rHryst/7cegskvZIMPsrAH12+K942+JA=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/emroussel.atomize-atom-one-dark-theme/changelog";
          description = "Detailed and accurate Atom One Dark theme for VSCode";
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
          hash = "sha256-/fM+aUDUzVJ6P38i+GrxhLv2eLJNa8OFkKsM4yPBy4c=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/enkia.tokyo-night/changelog";
          description = "Clean Visual Studio Code theme that celebrates the lights of Downtown Tokyo at night";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=enkia.tokyo-night";
          homepage = "https://github.com/enkia/tokyo-night-vscode-theme";
          license = lib.licenses.mit;
        };
      };

      equinusocio.vsc-material-theme = callPackage ./equinusocio.vsc-material-theme { };

      equinusocio.vsc-material-theme-icons = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vsc-material-theme-icons";
          publisher = "Equinusocio";
          version = "3.5.0";
          hash = "sha256-XqtyZVlsPaPkKB9HdigKSXjCwqXe9wzJWeRcPpS6EVM=";
        };
        meta = {
          description = "Material Theme Icons, the most epic icons theme for Visual Studio Code and Material Theme";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=Equinusocio.vsc-material-theme-icons";
          homepage = "https://github.com/material-theme/vsc-material-theme-icons";
          license = lib.licenses.asl20;
          maintainers = [ lib.maintainers.themaxmur ];
        };
      };

      esbenp.prettier-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "prettier-vscode";
          publisher = "esbenp";
          version = "10.4.0";
          hash = "sha256-8+90cZpqyH+wBgPFaX5GaU6E02yBWUoB+T9C2z2Ix8c=";
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
          hash = "sha256-pZK/QNomQoFRsL6LRIKvWQj8/SYo2ZdVU47Gsmb9MXo=";
        };
      };

      eugleo.magic-racket = callPackage ./eugleo.magic-racket { };

      ExiaHuang.dictionary = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "ExiaHuang";
          name = "dictionary";
          version = "0.0.2";
          hash = "sha256-caNcbDTB/F2mdlGpfIfJv13lzY5Wwj7p7r8dAte9+3A=";
        };
        meta = {
          description = "Visual Studio Code extension of using chinese-english dictonary in right-click menu";
          homepage = "https://github.com/exiahuang/fanyi-vscode";
          changelog = "https://marketplace.visualstudio.com/items/ExiaHuang.dictionary/changelog";
          license = lib.licenses.gpl3Only;
          maintainers = with lib.maintainers; [ onedragon ];
        };
      };

      fabiospampinato.vscode-open-in-github = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-open-in-github";
          publisher = "fabiospampinato";
          version = "2.3.0";
          hash = "sha256-vrW6uZyeEJipGtfz7BEeeAwiwtBlfQLjC7jAP1v5GoE=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/fabiospampinato.vscode-open-in-github/changelog";
          description = "VS Code extension to open the current project or file in github.com";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=fabiospampinato.vscode-open-in-github";
          homepage = "https://github.com/fabiospampinato/vscode-open-in-github";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.uncenter ];
        };
      };

      file-icons.file-icons = buildVscodeMarketplaceExtension {
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/file-icons.file-icons/changelog";
          description = "File-specific icons in VSCode for improved visual grepping";
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

      fill-labs.dependi = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "dependi";
          publisher = "fill-labs";
          version = "0.7.9";
          hash = "sha256-VsjISVDZGGh6/pf3Fd5g8pYDvWXA1+0oZKlQEGLBp4M=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/fill-labs.dependi/changelog";
          description = "VSCode extension for managing dependencies and address vulnerabilities in Rust, Go, JavaScript, and Python projects";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=fill-labs.dependi";
          homepage = "https://github.com/filllabs/dependi";
          license = lib.licenses.unfree;
          maintainers = [ lib.maintainers._21CSM ];
        };
      };

      firefox-devtools.vscode-firefox-debug = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-firefox-debug";
          publisher = "firefox-devtools";
          version = "2.9.10";
          hash = "sha256-xuvlE8L/qjOn8Qhkv9sutn/xRbwC9V/IIfEr4Ixm1vA=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/firefox-devtools.vscode-firefox-debug/changelog";
          description = "Visual Studio Code extension for debugging web applications and browser extensions in Firefox";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=firefox-devtools.vscode-firefox-debug";
          homepage = "https://github.com/firefox-devtools/vscode-firefox-debug";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.felschr ];
        };
      };

      firsttris.vscode-jest-runner = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-jest-runner";
          publisher = "firsttris";
          version = "0.4.72";
          hash = "sha256-1nUpOXdteWsyFYJ2uATCcr1SUbeusmbpa09Bkw9/TZM=";
        };
        meta = {
          description = "Simple way to run or debug a single (or multiple) tests from context-menu";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=firsttris.vscode-jest-runner";
          homepage = "https://github.com/firsttris/vscode-jest-runner";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.themaxmur ];
        };
      };

      foam.foam-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "foam-vscode";
          publisher = "foam";
          version = "0.21.1";
          hash = "sha256-Ff1g+Qu4nUGR3g5PqOwP7W6S+3jje9gz1HK8J0+B65w=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/foam.foam-vscode/changelog";
          description = "Personal knowledge management and sharing system for VSCode ";
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
          hash = "sha256-XYYHS2QTy8WYjtUYYWsIESzmH4dRQLlXQpJq78BolMw=";
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
          hash = "sha256-uXqWebxnDwaUVLFG6MUh4bZ7jw5d2rTHRm5NoR2n0Vs=";
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
          hash = "sha256-Q2gcuclG7NLR81HjKj/0RF0jM5Eqe2vZMbpoabp/osg=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      fortran-lang.linter-gfortran = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "linter-gfortran";
          publisher = "fortran-lang";
          version = "3.4.2024061701";
          hash = "sha256-i357EzQ8cm8NPsMBbsV5ToMoBDa59Bh6ylC9tNjMY6s=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/fortran-lang.linter-gfortran/changelog";
          description = "Fortran language support for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=fortran-lang.linter-gfortran";
          homepage = "https://github.com/fortran-lang/vscode-fortran-support";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.uncenter ];
        };
      };

      foxundermoon.shell-format = callPackage ./foxundermoon.shell-format { };

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
          hash = "sha256-9Vo6lwqD1eE3zY0Gi9ME/6lPwmwuJ3Iq9StHPvncnM4=";
        };
        meta = {
          description = "Visual Studio Code extension using google translation to helping you quickly translate text right in your code rocket";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=funkyremi.vscode-google-translate";
          homepage = "https://github.com/funkyremi/vscode-google-translate.git";
          changelog = "https://marketplace.visualstudio.com/items/funkyremi.vscode-google-translate/changelog";
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [ onedragon ];
        };
      };

      garlicbreadcleric.pandoc-markdown-syntax = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "pandoc-markdown-syntax";
          publisher = "garlicbreadcleric";
          version = "0.0.2";
          hash = "sha256-YAMH5smLyBuoTdlxSCTPyMIKOWTSIdf2MQVZuOO2V1w=";
        };
        meta = {
          description = "A VSCode extension that adds syntax highlighting for Pandoc-flavored Markdown";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=garlicbreadcleric.pandoc-markdown-syntax";
          homepage = "https://github.com/garlicbreadcleric/vscode-pandoc-markdown";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.pandapip1 ];
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
          description = "Visual Studio Code extension to support ChatGPT, GPT-3 and Codex conversations";
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
          version = "1.16.9";
          hash = "sha256-Zj1dHz8uBHnRpjnD9tUr8OJILRq9Ty91ePiNq6/Vi7c=";
        };

        meta = {
          description = "VSCode extensions that provides cloud-hosted development environments for any activity";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=GitHub.codespaces";
          homepage = "https://github.com/features/codespaces";
          license = lib.licenses.unfree;
        };
      };

      github.copilot = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "github";
          name = "copilot";
          version = "1.219.1028"; # compatible with vscode ^1.92.0
          hash = "sha256-5f1P/CV6+Rp2kS9oSz5Ko5jMUt/Q6pWa9a+3nPyin6k=";
        };

        meta = {
          description = "GitHub Copilot uses OpenAI Codex to suggest code and entire functions in real-time right from your editor";
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
          version = "0.19.2024073102"; # compatible with vscode ^1.92.0
          hash = "sha256-ekRBmJiAav1gITWlqBOuWtZMt1YZeseF+3fw326db/s=";
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
          hash = "sha256-JbI0B7jxt/2pNg/hMjAE5pBBa3LbUdi+GF0iEZUDUDM=";
        };
        meta = {
          description = "GitHub theme for VS Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=GitHub.github-vscode-theme";
          homepage = "https://github.com/primer/github-vscode-theme";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.hugolgst ];
        };
      };

      github.vscode-github-actions = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-github-actions";
          publisher = "github";
          version = "0.26.3";
          hash = "sha256-tHUpYK6RmLl1s1J+N5sd9gyxTJSNGT1Md/CqapXs5J4=";
        };
        meta = {
          description = "Visual Studio Code extension for GitHub Actions workflows and runs for github.com hosted repositories";
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
          version = "0.78.1";
          hash = "sha256-T9oW6o4ItZfR8E1qrcH3nhMvVB6ihi4kpiDz7YGHOcI=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      gitlab.gitlab-workflow = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "gitlab-workflow";
          publisher = "gitlab";
          version = "5.6.0";
          hash = "sha256-K4oCMQBH5jrt61f/C3DDZC61RuDvOApnPEF3AsOrE20=";
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
          hash = "sha256-dhRS8fLKY0plRwnrAUWT4g/LfH6IpODTNhT79g4Nm+0=";
        };
        meta = {
          description = "Support for the Gleam programming language";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=Gleam.gleam";
          homepage = "https://github.com/gleam-lang/vscode-gleam#readme";
          license = lib.licenses.asl20;
          maintainers = [ ];
        };
      };

      golang.go = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "Go";
          publisher = "golang";
          version = "0.41.4";
          hash = "sha256-ntrEI/l+UjzqGJmtyfVf/+sZJstZy3fm/PSWKTd7/Q0=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/golang.Go/changelog";
          description = "Go extension for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=golang.Go";
          homepage = "https://github.com/golang/vscode-go";
          license = lib.licenses.mit;
        };
      };

      grapecity.gc-excelviewer = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "gc-excelviewer";
          publisher = "grapecity";
          version = "4.2.56";
          hash = "sha256-lrKkxaqPDouWzDP1uUE4Rgt9mI61jUOi/xZ85A0mnrk=";
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
          hash = "sha256-u3VcpgLKiEeUr1I6w71wleKyaO6v0gmHiw5Ama6fv88=";
        };
        meta = {
          description = "GraphQL extension for VSCode built with the aim to tightly integrate the GraphQL Ecosystem with VSCode for an awesome developer experience";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=GraphQL.vscode-graphql";
          homepage = "https://github.com/graphql/graphiql/tree/main/packages/vscode-graphql";
          license = lib.licenses.mit;
          maintainers = [ ];
        };
      };

      graphql.vscode-graphql-syntax = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-graphql-syntax";
          publisher = "GraphQL";
          version = "1.3.6";
          hash = "sha256-74Y/LpOhAj3TSplohhJqBwJDT87nCAiKrWsF90bc8jU=";
        };
        meta = {
          description = "Adds full GraphQL syntax highlighting and language support such as bracket matching";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=GraphQL.vscode-graphql-syntax";
          homepage = "https://github.com/graphql/graphiql/tree/main/packages/vscode-graphql-syntax";
          license = lib.licenses.mit;
          maintainers = [ ];
        };
      };

      griimick.vhs = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vhs";
          publisher = "griimick";
          version = "0.0.4";
          hash = "sha256-zAy8o5d2pK5ra/dbwoLgPAQAYfRQtUYQjisWYgIhsXA=";
        };
        meta = {
          description = "Visual Studio Code extension providing syntax support for VHS .tape files";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=griimick.vhs";
          homepage = "https://github.com/griimick/vscode-vhs";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.drupol ];
        };
      };

      gruntfuggly.todo-tree = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "todo-tree";
          publisher = "Gruntfuggly";
          version = "0.0.226";
          hash = "sha256-Fj9cw+VJ2jkTGUclB1TLvURhzQsaryFQs/+f2RZOLHs=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      hars.cppsnippets = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "cppsnippets";
          publisher = "hars";
          version = "0.0.15";
          hash = "sha256-KXdEKcxPclbD22aKGAKSmdpVBZP2IpQRaKfc2LDsL0U=";
        };
        meta = {
          description = "Code snippets for C/C++";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=hars.CppSnippets";
          homepage = "https://github.com/one-harsh/vscode-cpp-snippets";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.themaxmur ];
        };
      };

      hashicorp.hcl = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "HCL";
          publisher = "HashiCorp";
          version = "0.3.2";
          hash = "sha256-cxF3knYY29PvT3rkRS8SGxMn9vzt56wwBXpk2PqO0mo=";
        };
        meta = {
          description = "HashiCorp HCL syntax";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=HashiCorp.HCL";
          homepage = "https://github.com/hashicorp/vscode-hcl";
          license = lib.licenses.mpl20;
          maintainers = [ lib.maintainers.themaxmur ];
        };
      };

      hashicorp.terraform = callPackage ./hashicorp.terraform { };

      haskell.haskell = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "haskell";
          publisher = "haskell";
          version = "2.2.2";
          hash = "sha256-zWdIVdz+kZg7KZQ7LeBCB4aB9wg8dUbkWfzGlM0Fq7Q=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      hbenl.vscode-test-explorer = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-test-explorer";
          publisher = "hbenl";
          version = "2.21.1";
          hash = "sha256-fHyePd8fYPt7zPHBGiVmd8fRx+IM3/cSBCyiI/C0VAg=";
        };
        meta = {
          changelog = "https://github.com/hbenl/vscode-test-explorer/blob/master/CHANGELOG.md";
          description = "Visual Studio Code extension that runs your tests in the sidebar";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=hbenl.vscode-test-explorer";
          homepage = "https://github.com/hbenl/vscode-test-explorer";
          license = lib.licenses.mit;
        };
      };

      hediet.vscode-drawio = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-drawio";
          publisher = "hediet";
          version = "1.6.6";
          hash = "sha256-SPcSnS7LnRL5gdiJIVsFaN7eccrUHSj9uQYIQZllm0M=";
        };
        meta = {
          description = "This unofficial extension integrates Draw.io into VS Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=hediet.vscode-drawio";
          homepage = "https://github.com/hediet/vscode-drawio";
          license = lib.licenses.gpl3Only;
          maintainers = [ lib.maintainers.themaxmur ];
        };
      };

      hiukky.flate = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "flate";
          publisher = "hiukky";
          version = "0.7.0";
          hash = "sha256-6ouYQk7mHCJdGrcutM1EXolJAT7/Sp1hi+Bu0983GKw=";
        };
        meta = {
          description = "Colorful dark themes for VS Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=hiukky.flate";
          homepage = "https://github.com/hiukky/flate";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.stunkymonkey ];
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
          hash = "sha256-DSzZ9wGB0IVK8gYOzLLbT03WX3xSmR/IUVZkDzcczKc=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      huytd.nord-light = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "nord-light";
          publisher = "huytd";
          version = "0.1.1";
          hash = "sha256-q2GG3j5j3CLGF02J7/plywKLkhUmm2Gn3MiSVmiZ+48=";
        };
        meta = {
          description = "Light theme for VSCode based on the Nord color palette";
          license = lib.licenses.mit;
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=huytd.nord-light";
          homepage = "https://github.com/huytd/vscode-nord-light";
          maintainers = [ lib.maintainers.Flameopathic ];
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
          hash = "sha256-ZsjBgoTr4LGQW0kn+CtbdLwpPHmlYl5LKhwXIzcPe2o=";
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

      iliazeus.vscode-ansi = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-ansi";
          publisher = "iliazeus";
          version = "1.1.6";
          hash = "sha256-ZPV8zd/GkXOGf6s8fz9ZPmC3i1jO0wFAqV0E67lW0do=";
        };
        meta = {
          description = "ANSI color styling for text documents";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=iliazeus.vscode-ansi";
          homepage = "https://github.com/iliazeus/vscode-ansi";
          license = lib.licenses.mit;
        };
      };

      influxdata.flux = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "influxdata";
          name = "flux";
          version = "1.0.4";
          hash = "sha256-KIKROyfkosBS1Resgl+s3VENVg4ibaeIgKjermXESoA=";
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
          hash = "sha256-g6mlScxv8opZuqgWtTJ3k0Yo7W7WzIkwB+8lWf6cMiU=";
        };
        meta = {
          description = "Visual Studio Code extension to translate the comments for computer language";
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
          version = "7.19.1";
          hash = "sha256-QyGt3q00IEXw6YNvx7pFhLS1s44aeiB/U0m3Ow1UdlM=";
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
          hash = "sha256-URq90lOFtPCNfSIl2NUwihwRQyqgDysGmBc3NG7o7vk=";
        };
        meta = {
          description = "Adds formatting and syntax highlighting support for env files (.env) to Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=IronGeek.vscode-env";
          homepage = "https://github.com/IronGeek/vscode-env.git";
          license = lib.licenses.mit;
          maintainers = [ ];
        };
      };

      jackmacwindows.vscode-computercraft = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-computercraft";
          publisher = "jackmacwindows";
          version = "1.1.1";
          hash = "sha256-ec1I3oQ06iMdSUcqf8yA3GjE7Aqa0PiLzRQLwFcL0KU=";
        };
        postInstall = ''
          # Remove superflouous images to reduce closure size
          rm $out/$installPrefix/images/*.gif
        '';
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/jackmacwindows.vscode-computercraft/changelog";
          description = "Visual Studio Code extension for ComputerCraft and CC: Tweaked auto-completion";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=jackmacwindows.vscode-computercraft";
          homepage = "https://github.com/MCJack123/vscode-computercraft";
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [ tomodachi94 ];
        };
      };

      jackmacwindows.craftos-pc = callPackage ./jackmacwindows.craftos-pc { };

      james-yu.latex-workshop = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "latex-workshop";
          publisher = "James-Yu";
          version = "9.14.1";
          sha256 = "1a8im7n25jy2zyqcqhscj62bamhwzp6kk6hdarb0p38d4pwwzxbm";
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

      jamesyang999.vscode-emacs-minimum = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-emacs-minimum";
          publisher = "jamesyang999";
          version = "1.1.1";
          hash = "sha256-qxnAhT2UGTQmPw9XmdBdx0F0NNLAaU1/ES9jiqiRrGI=";
        };
        meta = {
          description = "Minimal emacs key bindings for VSCode";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=jamesyang999.vscode-emacs-minimum";
          homepage = "https://github.com/futurist/vscode-emacs-minimum";
          license = lib.licenses.unfree;
        };
      };

      janet-lang.vscode-janet = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-janet";
          publisher = "janet-lang";
          version = "0.0.2";
          hash = "sha256-oj0e++z2BtadIXOnTlocIIHliYweZ1iyrV08DwatfLI=";
        };
        meta = {
          description = "Janet language support for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=janet-lang.vscode-janet";
          homepage = "https://github.com/janet-lang/vscode-janet";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.wackbyte ];
        };
      };

      jbockle.jbockle-format-files = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "jbockle-format-files";
          publisher = "jbockle";
          version = "3.4.0";
          hash = "sha256-BHw+T2EPdQq/wOD5kzvSln5SBFTYUXip8QDjnAGBfFY=";
        };
        meta = {
          description = "VSCode extension to formats all files in the current workspace";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=jbockle.jbockle-format-files";
          homepage = "https://github.com/jbockle/format-files";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.wackbyte ];
        };
      };

      jdinhlife.gruvbox = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "gruvbox";
          publisher = "jdinhlife";
          version = "1.18.0";
          hash = "sha256-4sGGVJYgQiOJzcnsT/YMdJdk0mTi7qcAcRHLnYghPh4=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/jdinhlife.gruvbox/changelog";
          description = "Port of Gruvbox theme to VS Code editor";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=jdinhlife.gruvbox";
          homepage = "https://github.com/jdinhify/vscode-theme-gruvbox";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.imgabe ];
        };
      };

      jebbs.plantuml = callPackage ./jebbs.plantuml { };

      jeff-hykin.better-nix-syntax = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "jeff-hykin";
          name = "better-nix-syntax";
          version = "1.1.5";
          hash = "sha256-9V+ziWk9V4LyQiVNSC6DniJDun+EvcK30ykPjyNsvp0=";
        };
        meta = {
          description = "Visual Studio Code extension providing Nix Syntax highlighting";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=jeff-hykin.better-nix-syntax";
          homepage = "https://github.com/jeff-hykin/better-nix-syntax";
          license = lib.licenses.mit;
          maintainers = [ ];
        };
      };

      jellyedwards.gitsweep = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "jellyedwards";
          name = "gitsweep";
          version = "1.0.0";
          hash = "sha256-XBD8rN6E/0GjZ3zXgR45MN9v4PYrEXBSzN7+CcLrRsg=";
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
          hash = "sha256-FYDkOuoiF/N24BFG9GOqtTDwq84txmaa1acdzfskf/c=";
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
          version = "0.3.1";
          hash = "sha256-05oMDHvFM/dTXB6T3rcDK3EiNG2T0tBN9Au9b+Bk7rI=";
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
          hash = "sha256-Ii2e65BJU+Vw3i8917dgZtGsiSn6qConu8SJ+IqF82U=";
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

      jgclark.vscode-todo-highlight = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-todo-highlight";
          publisher = "jgclark";
          version = "2.0.8";
          hash = "sha256-/CctaLcG+dA2Cf69/ACeDKdRLsu/VUGbAxUbyhI0VyA=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/wayou.vscode-todo-highlight/changelog";
          description = "highlight TODOs, FIXMEs, and any keywords, annotations...";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=jgclark.vscode-todo-highlight";
          homepage = "https://github.com/jgclark/vscode-todo-highlight";
          license = lib.licenses.mit;
        };
      };

      julialang.language-julia = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "language-julia";
          publisher = "julialang";
          version = "1.75.2";
          hash = "sha256-wGguwyTy3jj89ud/nQw2vbtNxYuWkfi0qG6QGUyvuz4=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/julialang.language-julia/changelog";
          description = "Visual Studio Code extension for Julia programming language";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=julialang.language-julia";
          homepage = "https://github.com/julia-vscode/julia-vscode";
          license = lib.licenses.mit;
        };
      };

      justusadam.language-haskell = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "language-haskell";
          publisher = "justusadam";
          version = "3.6.0";
          hash = "sha256-rZXRzPmu7IYmyRWANtpJp3wp0r/RwB7eGHEJa7hBvoQ=";
        };
        meta = {
          license = lib.licenses.bsd3;
        };
      };

      k--kato.intellij-idea-keybindings = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "intellij-idea-keybindings";
          publisher = "k--kato";
          version = "1.7.0";
          hash = "sha256-mIcSZANZlj5iO2oLiJBUHn08rXVhu/9SKsRhlu/hcvI=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/k--kato.intellij-idea-keybindings/changelog";
          description = "Visual Studio Code extension for IntelliJ IDEA keybindings";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=k--kato.intellij-idea-keybindings";
          homepage = "https://github.com/kasecato/vscode-intellij-idea-keybindings";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.t4sm5n ];
        };
      };

      kahole.magit = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "magit";
          publisher = "kahole";
          version = "0.6.43";
          hash = "sha256-DPLlQ2IliyvzW8JvgVlGKNd2JjD/RbclNXU3gEFVhOE=";
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
          hash = "sha256-CecEv19nEtnMe0KlCMNBM9ZAjbAVgPNUcZ6cBxHw44M=";
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

      kamadorueda.alejandra = callPackage ./kamadorueda.alejandra { };

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

      karunamurti.haml = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "haml";
          publisher = "karunamurti";
          version = "1.4.1";
          sha256 = "123cwfajakkg2pr0z4v289fzzlhwbxx9dvb5bjc32l3pzvbhq4gv";
        };
        meta.license = lib.licenses.mit;
      };

      kddejong.vscode-cfn-lint =
        let
          inherit (python3Packages) cfn-lint pydot;
        in
        buildVscodeMarketplaceExtension {
          mktplcRef = {
            name = "vscode-cfn-lint";
            publisher = "kddejong";
            version = "0.25.1";
            hash = "sha256-IueXiN+077tiecAsVCzgYksWYTs00mZv6XJVMtRJ/PQ=";
          };

          nativeBuildInputs = [
            jq
            moreutils
          ];

          buildInputs = [
            cfn-lint
            pydot
          ];

          postInstall = ''
            cd "$out/$installPrefix"
            jq '.contributes.configuration.properties."cfnLint.path".default = "${cfn-lint}/bin/cfn-lint"' package.json | sponge package.json
          '';

          meta = {
            description = "CloudFormation Linter IDE integration, autocompletion, and documentation";
            homepage = "https://github.com/aws-cloudformation/cfn-lint-visual-studio-code";
            license = lib.licenses.asl20;
            maintainers = [ ];
          };
        };

      kravets.vscode-publint = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-publint";
          publisher = "Kravets";
          version = "0.0.3";
          hash = "sha256-1KVqfCVyCn5LJOdazp3W6FECRGOviVC4+FHn6vTn5DI=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/Kravets.vscode-publint/changelog";
          description = "Lint packaging errors in VS Code with publint";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=Kravets.vscode-publint";
          homepage = "https://github.com/kravetsone/vscode-publint";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.uncenter ];
        };
      };

      kubukoz.nickel-syntax = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "nickel-syntax";
          publisher = "kubukoz";
          version = "0.0.2";
          hash = "sha256-ffPZd717Y2OF4d9MWE6zKwcsGWS90ZJvhWkqP831tVM=";
        };
        meta = {
          license = lib.licenses.asl20;
        };
      };

      lapo.asn1js = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "asn1js";
          publisher = "lapo";
          version = "0.1.4";
          hash = "sha256-utbIKlwNHnJZj/51f8hEDmUA/A26De/gY73iT4tXKRU=";
        };
        meta = {
          description = "Decode ASN.1 content inside VSCode";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=lapo.asn1js";
          homepage = "https://github.com/lapo-luchini/vscode-asn1js";
          maintainers = with lib.maintainers; [ katexochen ];
          license = lib.licenses.isc;
        };
      };

      leonardssh.vscord = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscord";
          publisher = "leonardssh";
          version = "5.2.13";
          hash = "sha256-Jgm3ekXFLhylX7RM6tdfi+lRLrcl4UQGmRHbr27M59M=";
        };
        meta = {
          description = "Highly customizable Discord Rich Presence extension for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=leonardssh.vscord";
          homepage = "https://github.com/leonardssh/vscord";
          maintainers = [ lib.maintainers.ryand56 ];
          license = lib.licenses.mit;
        };
      };

      llvm-org.lldb-vscode = llvmPackages.lldb;

      llvm-vs-code-extensions.vscode-clangd = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-clangd";
          publisher = "llvm-vs-code-extensions";
          version = "0.1.24";
          hash = "sha256-yOpsYjjwHRXxbiHDPgrtswUtgbQAo+3RgN2s6UYe9mg=";
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
          hash = "sha256-oDW7ijcObfOP7ZNggSHX0aiI5FkoJ/iQD92bRV0eWVQ=";
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
          hash = "sha256-xcGa43iPwUR6spOJGTmmWA1dOMNMQEdiuhMZPYZ+dTU=";
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
          hash = "sha256-DqY2PS4JSjb6VMO1b0Hi/7JOKSTUk5VSxJiCrUKBfLk=";
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
          hash = "sha256-I8UevZs04tUj/jaHrU7LiMF40ElMqtniU1h/9LNLdac=";
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
          hash = "sha256-m/8j89M340fiMF7Mi7FT2+Xag3fbMGWf8Gt9T8hLdmo=";
        };
        meta.license = lib.licenses.mit;
      };

      mathiasfrohlich.kotlin = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "Kotlin";
          publisher = "mathiasfrohlich";
          version = "1.7.1";
          hash = "sha256-MuAlX6cdYMLYRX2sLnaxWzdNPcZ4G0Fdf04fmnzQKH4=";
        };
        meta = {
          description = "Kotlin language support for VS Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=mathiasfrohlich.Kotlin";
          homepage = "https://github.com/mathiasfrohlich/vscode-kotlin";
          license = lib.licenses.asl20;
          maintainers = [ lib.maintainers.themaxmur ];
        };
      };

      matthewpi.caddyfile-support = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "caddyfile-support";
          publisher = "matthewpi";
          version = "0.3.0";
          hash = "sha256-1yiOnvC2w33kiPRdQYskee38Cid/GOj9becLadP1fUY=";
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
          hash = "sha256-x6aFrcX0YElEFEr0qA669/LPlab15npmXd5Q585pIEw=";
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
          hash = "sha256-0FX5KBsvUmI+JMGBnaI3kJmmD+Y6XFl7LRHU0ADbHos=";
        };
        meta = {
          description = "VsCoq is an extension for Visual Studio Code (VS Code) and VSCodium with support for the Coq Proof Assistant";
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
          version = "3.12.0";
          hash = "sha256-pnHaszLa4a4ptAubDUY+FQX3F6sQQUQ/sHAxyZsbhcQ=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/mechatroner.rainbow-csv/changelog";
          description = "Rainbow syntax higlighting for CSV and TSV files in Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemname=mechatroner.rainbow-csv";
          homepage = "https://github.com/mechatroner/vscode_rainbow_csv";
          license = lib.licenses.mit;
        };
      };

      meganrogge.template-string-converter = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "template-string-converter";
          publisher = "meganrogge";
          version = "0.6.1";
          hash = "sha256-w0ppzh0m/9Hw3BPJbAKsNcMStdzoH9ODf3zweRcCG5k=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/meganrogge.template-string-converter/changelog";
          description = "VS Code extension to autocorrect from quotes to backticks";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=meganrogge.template-string-converter";
          homepage = "https://github.com/meganrogge/template-string-converter";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.uncenter ];
        };
      };

      mesonbuild.mesonbuild = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "mesonbuild";
          name = "mesonbuild";
          version = "1.24.0";
          hash = "sha256-n7c2CUiTIej2Y/QMGWpv6anuCDjqpo2W+hJylfvvMVE=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/mesonbuild.mesonbuild/changelog";
          description = "Meson language support for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=mesonbuild.mesonbuild";
          homepage = "https://github.com/mesonbuild/vscode-meson";
          maintainers = with lib.maintainers; [ Anillc ];
          license = lib.licenses.asl20;
        };
      };

      mhutchie.git-graph = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "git-graph";
          publisher = "mhutchie";
          version = "1.30.0";
          hash = "sha256-sHeaMMr5hmQ0kAFZxxMiRk6f0mfjkg2XMnA4Gf+DHwA=";
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
          hash = "sha256-dieCzNOIcZiTGu4Mv5zYlG7jLhaEsJR05qbzzzQ7RWc=";
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
          version = "0.17.0";
          hash = "sha256-9sFcfTMeLBGw2ET1snqQ6Uk//D/vcD9AVsZfnUNrWNg=";
        };
        meta = {
          description = "direnv support for Visual Studio Code";
          license = lib.licenses.bsd0;
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=mkhl.direnv";
          maintainers = [ ];
        };
      };

      mongodb.mongodb-vscode = callPackage ./mongodb.mongodb-vscode { };

      moshfeu.compare-folders = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "compare-folders";
          publisher = "moshfeu";
          version = "0.24.3";
          hash = "sha256-eaumF2BIqEYoyL7LQ0Wx3+gkkFGpWKQoN3AisI8wTQY=";
        };

        meta = {
          changelog = "https://github.com/moshfeu/vscode-compare-folders/releases";
          description = "Extension allows you to compare folders, show the diffs in a list and present diff in a splitted view side by side";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=moshfeu.compare-folders";
          homepage = "https://github.com/moshfeu/vscode-compare-folders";
          license = lib.licenses.mit;
        };
      };

      ms-azuretools.vscode-docker = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-docker";
          publisher = "ms-azuretools";
          version = "1.29.0";
          hash = "sha256-mVRsVsolXj31WhbWnt3Xml+NnIq7Q2uHhUUd1zgW42c=";
        };
        meta = {
          description = "Docker Extension for Visual Studio Code";
          homepage = "https://github.com/microsoft/vscode-docker";
          changelog = "https://marketplace.visualstudio.com/items/ms-azuretools.vscode-docker/changelog";
          license = lib.licenses.mit;
        };
      };

      ms-ceintl = callPackage ./language-packs.nix { }; # non-English language packs

      ms-dotnettools.csdevkit = callPackage ./ms-dotnettools.csdevkit { };
      ms-dotnettools.csharp = callPackage ./ms-dotnettools.csharp { };

      ms-dotnettools.vscode-dotnet-runtime = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-dotnet-runtime";
          publisher = "ms-dotnettools";
          version = "2.1.1";
          hash = "sha256-k14bjWITPDduJi79W59SnMV2TFNRCeAymhs6u1Y0vzk=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/ms-dotnettools.vscode-dotnet-runtime/changelog";
          description = "Provides a way for other Visual Studio Code extensions to install local versions of .NET SDK/Runtime";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.vscode-dotnet-runtime";
          homepage = "https://github.com/dotnet/vscode-dotnet-runtime";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.magnouvean ];
        };
      };

      ms-dotnettools.vscodeintellicode-csharp = buildVscodeMarketplaceExtension {
        mktplcRef =
          let
            sources = {
              "x86_64-linux" = {
                arch = "linux-x64";
                hash = "sha256-oQMwzQuW5vjxtDboRCeiEO5aytsAY6rb14JDTmK3JPg=";
              };
              "x86_64-darwin" = {
                arch = "darwin-x64";
                hash = "sha256-/9+qtLDNYUFvdoehit3BihA38p6RqJ7na5Q27xxpZk0=";
              };
              "aarch64-linux" = {
                arch = "linux-arm64";
                hash = "sha256-JqLlYMKyTXaEzuTPPxVaO8WJiuCUN+9xBzyA6+aYdSc=";
              };
              "aarch64-darwin" = {
                arch = "darwin-arm64";
                hash = "sha256-dhiUePePkO3MxRQ5UP+lOxRax503JlERe/GWJ8pPUIg=";
              };
            };
          in
          {
            name = "vscodeintellicode-csharp";
            publisher = "ms-dotnettools";
            version = "2.1.11";
          }
          // sources.${stdenv.system};
        nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];
        buildInputs = [
          stdenv.cc.cc.lib
          zlib
        ];
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/ms-dotnettools.vscodeintellicode-csharp/changelog";
          description = "AI-assisted development features for C# in Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.vscodeintellicode-csharp";
          homepage = "https://github.com/MicrosoftDocs/intellicode";
          license = lib.licenses.unfree;
          maintainers = [ lib.maintainers.magnouvean ];
          platforms = [
            "x86_64-linux"
            "x86_64-darwin"
            "aarch64-darwin"
            "aarch64-linux"
          ];
        };
      };

      ms-kubernetes-tools.vscode-kubernetes-tools = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-kubernetes-tools";
          publisher = "ms-kubernetes-tools";
          version = "1.3.11";
          hash = "sha256-I2ud9d4VtgiiIT0MeoaMThgjLYtSuftFVZHVJTMlJ8s=";
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
          hash = "sha256-GzRJeV4qfgM2kBv6U3MH7lMWl3CL6LWPI/9GaVWZL+o=";
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
          version = "2024.2.0";
          hash = "sha256-qIO+YqTXjwgznzUlnPSts1R2BM6iN8B9vESkelGPgZM=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/ms-python.black-formatter/changelog";
          description = "Formatter extension for Visual Studio Code using black";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-python.black-formatter";
          homepage = "https://github.com/microsoft/vscode-black-formatter";
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [
            amadejkastelic
            sikmir
          ];
        };
      };

      ms-python.flake8 = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "flake8";
          publisher = "ms-python";
          version = "2023.10.0";
          hash = "sha256-4Vjw8yJPrxLg0hcoTw8AEBEcmQ9sEUNqFaHLxICks0E=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/ms-python.flake8/changelog";
          description = "Python linting support for VS Code using Flake8";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-python.flake8";
          homepage = "https://github.com/microsoft/vscode-flake8";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.amadejkastelic ];
        };
      };

      ms-python.isort = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "isort";
          publisher = "ms-python";
          version = "2023.10.1";
          hash = "sha256-NRsS+mp0pIhGZiqxAMXNZ7SwLno9Q8pj+RS1WB92HzU=";
        };
        meta = with lib; {
          description = "Import sorting extension for Visual Studio Code using isort";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-python.isort";
          homepage = "https://github.com/microsoft/vscode-isort";
          license = licenses.mit;
          maintainers = with maintainers; [ sikmir ];
        };
      };

      ms-python.pylint = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "pylint";
          publisher = "ms-python";
          version = "2023.10.1";
          hash = "sha256-1tI5u33c5CHFQxkJZ/OxW3ZA5qPr4RoCIf6dqIMPykQ=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/ms-python.pylint/changelog";
          description = "Python linting support for VS Code using Pylint";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-python.pylint";
          homepage = "https://github.com/microsoft/vscode-pylint";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.amadejkastelic ];
        };
      };

      ms-python.python = callPackage ./ms-python.python { };

      ms-python.debugpy = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "debugpy";
          publisher = "ms-python";
          version = "2024.6.0";
          hash = "sha256-VlPe65ViBur5P6L7iRKdGnmbNlSCwYrdZAezStx8Bz8=";
        };
        meta = {
          description = "Python debugger (debugpy) extension for VS Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-python.debugpy";
          homepage = "https://github.com/Microsoft/vscode-python-debugger";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.carlthome ];
        };
      };

      ms-python.vscode-pylance = callPackage ./ms-python.vscode-pylance { };

      ms-toolsai.datawrangler = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "datawrangler";
          publisher = "ms-toolsai";
          version = "1.7.2";
          hash = "sha256-3UK87MhDBCT4La8jRgmkRJJQPZbgvOu0+VBea7ho9hs=";
        };

        meta = {
          description = "Data viewing, cleaning and preparation for tabular datasets";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-toolsai.datawrangler";
          homepage = "https://github.com/microsoft/vscode-data-wrangler";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.katanallama ];
        };
      };

      ms-toolsai.jupyter = callPackage ./ms-toolsai.jupyter { };

      ms-toolsai.jupyter-keymap = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "jupyter-keymap";
          publisher = "ms-toolsai";
          version = "1.1.0";
          hash = "sha256-krDtR+ZJiJf1Kxcu5mdXOaSAiJb2bXC1H0XWWviWeMQ=";
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
          hash = "sha256-JR6PunvRRTsSqjSGGAn/1t1B+Ia6X0MgqahehcuSNYA=";
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
          hash = "sha256-0oPyptnUWL1h/H13SdR+FdgGzVwEpTaK9SCE7BvI/5M=";
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
          hash = "sha256-POxgwvKF4A+DxKVIOte4I8REhAbO1U9Gu6r/S41/MmA=";
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
          hash = "sha256-j67Z65N9YW8wY4zIWWCtPIKgW9GYoUntBoGVBLR/H2o=";
        };
        meta.license = lib.licenses.mit;
      };

      ms-vscode.cpptools = callPackage ./ms-vscode.cpptools { };

      ms-vscode.cpptools-extension-pack = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "cpptools-extension-pack";
          publisher = "ms-vscode";
          version = "1.3.0";
          hash = "sha256-rHST7CYCVins3fqXC+FYiS5Xgcjmi7QW7M4yFrUR04U=";
        };
        meta = {
          description = "Popular extensions for C++ development in Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools-extension-pack";
          homepage = "https://github.com/microsoft/vscode-cpptools";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.themaxmur ];
        };
      };

      ms-vscode.hexeditor = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "hexeditor";
          publisher = "ms-vscode";
          version = "1.9.11";
          hash = "sha256-w1R8z7Q/JRAsqJ1mgcvlHJ6tywfgKtS6A6zOY2p01io=";
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
          hash = "sha256-/IrLq+nNxwQB1S1NIGYkv24DOY7Mc25eQ+orUfh42pg=";
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
          hash = "sha256-FJolnWU0DbuQYvMuGL3mytf0h39SH9rUPCl2ahLXLuY=";
        };
        meta = {
          description = "Visual Studio Code extension for PowerShell language support";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell";
          homepage = "https://github.com/PowerShell/vscode-powershell";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.rhoriguchi ];
        };
      };

      ms-vscode.test-adapter-converter = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "test-adapter-converter";
          publisher = "ms-vscode";
          version = "0.1.9";
          hash = "sha256-M53jhAVawk2yCeSrLkWrUit3xbDc0zgCK2snbK+BaSs=";
        };
        meta = {
          description = "Visual Studio Code extension that converts from the Test Explorer UI API into native VS Code testing";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-vscode.test-adapter-converter";
          homepage = "https://github.com/microsoft/vscode-test-adapter-converter";
          license = lib.licenses.mit;
        };
      };

      ms-vscode.theme-tomorrowkit = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "Theme-TomorrowKit";
          publisher = "ms-vscode";
          version = "0.1.4";
          hash = "sha256-qakwJWak+IrIeeVcMDWV/fLPx5M8LQGCyhVt4TS/Lmc=";
        };
        meta = {
          description = "Additional Tomorrow and Tomorrow Night themes for VS Code. Based on the TextMate themes";
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
          version = "0.376.0";
          hash = "sha256-fJ8ZcwGFWXzJZ8UgnzTxR+842vjiU0qCjV/zWzbq/KQ=";
        };
        meta = {
          description = "Open any folder or repository inside a Docker container";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers";
          homepage = "https://code.visualstudio.com/docs/devcontainers/containers";
          license = lib.licenses.unfree;
          maintainers = [ lib.maintainers.anthonyroussel ];
        };
      };

      ms-vscode-remote.remote-ssh = callPackage ./ms-vscode-remote.remote-ssh { };

      ms-vscode-remote.remote-ssh-edit = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "remote-ssh-edit";
          publisher = "ms-vscode-remote";
          version = "0.86.0";
          hash = "sha256-JsbaoIekUo2nKCu+fNbGlh5d1Tt/QJGUuXUGP04TsDI=";
        };
        meta = {
          description = "A Visual Studio Code extension that complements the Remote SSH extension with syntax colorization, keyword intellisense, and simple snippets when editing SSH configuration files";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh-edit";
          homepage = "https://code.visualstudio.com/docs/remote/ssh";
          license = lib.licenses.unfree;
          maintainers = [ lib.maintainers.pandapip1 ];
        };
      };

      ms-vscode-remote.remote-wsl = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "remote-wsl";
          publisher = "ms-vscode-remote";
          version = "0.88.2";
          hash = "sha256-fl7fLNd3EHA9eMiPUIL/23SUiA81gveqZLFkqaHTX+Q=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/ms-vscode-remote.remote-wsl/changelog";
          description = "Windows Subsystem for Linux support for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl";
          homepage = "https://code.visualstudio.com/docs/remote/wsl";
          license = lib.licenses.unfree;
          maintainers = [ lib.maintainers.uncenter ];
        };
      };

      ms-vsliveshare.vsliveshare = callPackage ./ms-vsliveshare.vsliveshare { };

      mshr-h.veriloghdl = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "veriloghdl";
          publisher = "mshr-h";
          version = "1.13.2";
          hash = "sha256-MOU8zf2qS7P2pQ29w3mvhDc2OvZiH4HNe530BjIiRAA=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/mshr-h.VerilogHDL/changelog";
          description = "Visual Studio Code extension for supporting Verilog-HDL, SystemVerilog, Bluespec and SystemVerilog";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=mshr-h.VerilogHDL";
          homepage = "https://github.com/mshr-h/vscode-verilog-hdl-support";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.newam ];
        };
      };

      mskelton.one-dark-theme = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "one-dark-theme";
          publisher = "mskelton";
          version = "1.14.2";
          hash = "sha256-6nIfEPbau5Dy1DGJ0oQ5L2EGn2NDhpd8jSdYujtOU68=";
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
          hash = "sha256-kHItIlTW+PIVXrLgzdGAoPeR6sWKuKl/QyJ5+TIv3/E=";
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
          hash = "sha256-QQIkuJAI4apDt8rfhXvMg9bNtGTFeMaEkN/Se12zGpc=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      myriad-dreamin.tinymist = callPackage ./myriad-dreamin.tinymist { };

      naumovs.color-highlight = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "color-highlight";
          publisher = "naumovs";
          version = "2.6.0";
          hash = "sha256-TcPQOAHCYeFHPdR85GIXsy3fx70p8cLdO2UNO0krUOs=";
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

      naumovs.theme-oceanicnext = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "theme-oceanicnext";
          publisher = "naumovs";
          version = "0.0.4";
          hash = "sha256-romhWL3s0NVZ3kptSNT4/X9WkgakgNNfFElaBCo6jj4=";
        };
        meta = {
          description = "Oceanic Next theme for VSCode + dimmed bg version for better looking UI";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=naumovs.theme-oceanicnext";
          homepage = "https://github.com/voronianski/oceanic-next-color-scheme";
          license = lib.licenses.unlicense;
          maintainers = [ lib.maintainers.themaxmur ];
        };
      };

      nefrob.vscode-just-syntax = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-just-syntax";
          publisher = "nefrob";
          version = "0.5.1";
          hash = "sha256-DacDGK8gqlt8u0ZKcVxZ7jiUFFEX3ixv3P7RKWJVluA=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/nefrob.vscode-just-syntax/changelog";
          description = "Justfile syntax support for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=nefrob.vscode-just-syntax";
          homepage = "https://github.com/nefrob/vscode-just";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.uncenter ];
        };
      };

      njpwerner.autodocstring = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "autodocstring";
          publisher = "njpwerner";
          version = "0.6.1";
          hash = "sha256-NI0cbjsZPW8n6qRTRKoqznSDhLZRUguP7Sa/d0feeoc=";
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
          hash = "sha256-2qjV6iSz8DDU1yP1II9sxGSgiETmEtotFvfNjm+cTuI=";
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

      nur.just-black = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "just-black";
          publisher = "nur";
          version = "3.1.1";
          hash = "sha256-fatJZquCDsLDFGVzBol2D6LIZUbZ6GzqcVEFAwLodW0=";
        };
        meta = {
          description = "Dark theme designed specifically for syntax highlighting";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=nur.just-black";
          homepage = "https://github.com/nurmohammed840/extension.vsix/tree/Just-Black";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.d3vil0p3r ];
        };
      };

      nvarner.typst-lsp = callPackage ./nvarner.typst-lsp { };

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
          hash = "sha256-dj8UFbYgAl6dt/1MuIBawTVUbBDTTedZEcHtKZjEcew=";
        };
      };

      octref.vetur = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vetur";
          publisher = "octref";
          version = "0.37.3";
          hash = "sha256-3hi1LOZto5AYaomB9ihkAt4j/mhkCDJ8Jqa16piwHIQ=";
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
          hash = "sha256-dOicya0B2sriTcDSdCyhtp0Mcx5b6TUaFKVb0YU3jUc=";
        };
        meta = {
          description = "Makes indentation easier to read";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=oderwat.indent-rainbow";
          homepage = "https://github.com/oderwat/vscode-indent-rainbow";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.imgabe ];
        };
      };

      phind.phind = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "phind";
          publisher = "phind";
          version = "0.25.3";
          hash = "sha256-GPFeI7tVLfzlGyal2LbsyTgPkWY/nPWnXtS38S9pvxo=";
        };
        meta = {
          description = "Using Phind AI service to provide answers based on the code context";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=phind.phind";
          license = lib.licenses.unfree;
          maintainers = [ lib.maintainers.onny ];
        };
      };

      phoenixframework.phoenix = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "phoenix";
          publisher = "phoenixframework";
          version = "0.1.2";
          hash = "sha256-T+YNRR8jAzNagmoCDzjbytBDFtPhNn289Kywep/w8sw=";
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
          hash = "sha256-tKpKLUcc33YrgDS95PJu22ngxhwjqeVMC1Mhhy+IPGE=";
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
          version = "4.31.0";
          sha256 = "0rn4dyqr46wbgi4k27ni6a6i3pa83gyaprhds5rlndjaw90iakb4";
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
          hash = "sha256-gKU21OS2ZFyzCQVQ1fa3qlahLBAcJaHDEcz7xof3P4A=";
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
          hash = "sha256-fHvwv9E/O8ZvhnyY7nNF/SIyl87z8KVEXTbhU/37EP0=";
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

      pythagoratechnologies.gpt-pilot-vs-code = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "gpt-pilot-vs-code";
          publisher = "PythagoraTechnologies";
          version = "0.1.7";
          hash = "sha256-EUddanrB6h5cn3pK2JTkEPffVb06ZMI2qDPh0kFfJjA=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/PythagoraTechnologies.gpt-pilot-vs-code/changelog";
          description = "VSCode extension for assisting the developer to code, debug, build applications using LLMs/AI";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=PythagoraTechnologies.gpt-pilot-vs-code";
          homepage = "https://github.com/Pythagora-io/gpt-pilot/";
          license = lib.licenses.asl20;
          maintainers = [ ];
        };
      };

      quicktype.quicktype = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "quicktype";
          publisher = "quicktype";
          version = "12.0.46";
          hash = "sha256-NTZ0BujnA+COg5txOLXSZSp8TPD1kZNfZPjnvZUL9lc=";
        };
        meta = {
          description = "Infer types from sample JSON data";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=quicktype.quicktype";
          homepage = "https://github.com/glideapps/quicktype";
          license = lib.licenses.asl20;
        };
      };

      rebornix.ruby = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "ruby";
          publisher = "rebornix";
          version = "0.28.1";
          hash = "sha256-HAUdv+2T+neJ5aCGiQ37pCO6x6r57HIUnLm4apg9L50=";
        };

        meta.license = lib.licenses.mit;
      };

      redhat.ansible = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "ansible";
          publisher = "redhat";
          version = "2.12.143";
          hash = "sha256-NEV7sVYJJvapZjk5sylkzijH8qLZ7xzmBzHI7qcj2Ok=";
        };
        meta = {
          description = "Ansible language support";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=redhat.ansible";
          homepage = "https://github.com/ansible/vscode-ansible";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.themaxmur ];
        };
      };

      redhat.java = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "java";
          publisher = "redhat";
          version = "1.30.2024041908";
          hash = "sha256-2VaB7duzDmoQYxLHIuC9yghJvmVnWJIBfH75xq5ljPg=";
        };
        buildInputs = [ jdk ];
        meta = {
          description = "Java language support for VS Code via the Eclipse JDT Language Server";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=redhat.java";
          homepage = "https://github.com/redhat-developer/vscode-java";
          changelog = "https://marketplace.visualstudio.com/items/redhat.java/changelog";
          license = lib.licenses.epl20;
          maintainers = [ lib.maintainers.wackbyte ];
          broken = lib.versionOlder jdk.version "17";
        };
      };

      redhat.vscode-xml = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-xml";
          publisher = "redhat";
          version = "0.26.2023092519";
          sha256 = "00p98qihw7ndwl4h18jx8n0lmrqsn1vab7h2k3cbjdz0b623j773";
        };
        meta.license = lib.licenses.epl20;
      };

      redhat.vscode-yaml = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-yaml";
          publisher = "redhat";
          version = "1.14.0";
          sha256 = "0pww9qndd2vsizsibjsvscz9fbfx8srrj67x4vhmwr581q674944";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      reditorsupport.r = callPackage ./reditorsupport.r { };

      reloadedextensions.reloaded-cpp = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "reloaded-cpp";
          publisher = "reloadedextensions";
          version = "0.1.9";
          hash = "sha256-KQiSD18W9NnsqhRt+XM3ko70u4zX4enn3OpMt0ebViU=";
        };
        meta = {
          description = "C/C++ must-have highlighter that understands many coding styles and APIs. Use with 'Reloaded Themes' extension";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=reloadedextensions.reloaded-cpp";
          homepage = "https://github.com/kobalicek/reloaded-cpp";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.themaxmur ];
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
          hash = "sha256-777jdBpWJ66ASeeETWevWF4mIAj4RWviNSTxzvqwl0U=";
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
          hash = "sha256-w0CYSEOdltwMFzm5ZhOxSrxqQ1y4+gLfB8L+EFFgzDc=";
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
          hash = "sha256-gGEjb9BrvFmKhAxRUmN3YWx7VZqlUp6w7m4r46DPn50=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      RoweWilsonFrederiskHolme.wikitext = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "wikitext";
          publisher = "RoweWilsonFrederiskHolme";
          version = "3.8.1";
          hash = "sha256-piwS3SPjx10nsjN5axC+EN0MEDf0r2lVFllqQzciOfc=";
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

      samuelcolvin.jinjahtml = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "jinjahtml";
          publisher = "samuelcolvin";
          version = "0.20.0";
          sha256 = "c000cbdc090b7d3d8df62a3c87a5d881c78aca5b490b3e591d9841d788a9aa93";
        };
        meta = with lib; {
          description = "Syntax highlighting for jinja(2) including HTML, Markdown, YAML, Ruby and LaTeX templates";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=samuelcolvin.jinjahtml";
          homepage = "https://github.com/samuelcolvin/jinjahtml-vscode";
          changelog = "https://marketplace.visualstudio.com/items/samuelcolvin.jinjahtml/changelog";
          license = licenses.mit;
          maintainers = [ maintainers.DataHearth ];
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
          hash = "sha256-eizIPazqEb27aQ+o9nTD1O58zbjkHYHNhGjK0uJgnwA=";
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
          hash = "sha256-iLLWobQv5CEjJwCdDNdWYQ1ehOiYyNi940b4QmNZFoQ=";
        };
        meta = {
          license = lib.licenses.asl20;
        };
      };

      sdras.night-owl = buildVscodeMarketplaceExtension rec {
        mktplcRef = {
          name = "night-owl";
          publisher = "sdras";
          version = "2.0.1";
          hash = "sha256-AqfcVV9GYZ+GLgusXfij9z4WzrU9cCHp3sdZb0i6HzE=";
        };
        meta = {
          changelog = "https://github.com/sdras/night-owl-vscode-theme/blob/main/CHANGELOG.md#${
            builtins.replaceStrings [ "." ] [ "" ] mktplcRef.version
          }";
          description = "A Visual Studio Code theme named Light Owl for daytime usage";
          longDescription = ''
            A VS Code theme for the night owls out there. Now introducing
            Light Owl theme for daytime usage. Decisions were based
            on meaningful contrast for reading comprehension and for
            optimal razzle dazzle.
          '';
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=sdras.night-owl";
          homepage = "https://github.com/sdras/night-owl-vscode-theme";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.pladypus ];
        };
      };

      seatonjiang.gitmoji-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "seatonjiang";
          name = "gitmoji-vscode";
          version = "1.2.2";
          hash = "sha256-+lwbCLV62y1IHrjCygBphQZJUu+ZApYTwBQld5uu12w=";
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
          version = "0.6.6";
          hash = "sha256-HXoH1IgMLniq0kxHs2snym4rerScu9qCqUaqwEC+O/E=";
        };
        meta = {
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.wackbyte ];
        };
      };

      shardulm94.trailing-spaces = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "shardulm94";
          name = "trailing-spaces";
          version = "0.4.1";
          hash = "sha256-pLE1bfLRxjlm/kgU9nmtiPBOnP05giQnWq6bexrrIZY=";
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
          version = "0.8.14";
          hash = "sha256-vCuuPB/GTkM2xCBn1UF3CZwP49Ge/8eelHhg67EG7tQ=";
        };
        meta = {
          description = "Provides a live preview of markdown using either markdown-it or pandoc";
          longDescription = ''
            Markdown Preview Enhanced is an extension that provides you with
            many useful functionalities such as automatic scroll sync, math
            typesetting, mermaid, PlantUML, pandoc, PDF export, code chunk,
            presentation writer, etc. A lot of its ideas are inspired by
            Markdown Preview Plus and RStudio Markdown.
          '';
          homepage = "https://github.com/shd101wyy/vscode-markdown-preview-enhanced";
          license = lib.licenses.ncsa;
          maintainers = [ lib.maintainers.pbsds ];
        };
      };

      shopify.ruby-lsp = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "shopify";
          name = "ruby-lsp";
          version = "0.5.8";
          hash = "sha256-1FfBnw98SagHf1P7udWzMU6BS5dBihpeRj4qv9S4ZHw=";
        };
        meta = {
          description = "VS Code plugin for connecting with the Ruby LSP";
          license = lib.licenses.mit;
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

      signageos.signageos-vscode-sops = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "signageos-vscode-sops";
          publisher = "signageos";
          version = "0.9.1";
          hash = "sha256-b1Gp+tL5/e97xMuqkz4EvN0PxI7cJOObusEkcp+qKfM=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/signageos.signageos-vscode-sops/changelog";
          description = "Visual Studio Code extension for SOPS support";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=signageos.signageos-vscode-sops";
          homepage = "https://github.com/signageos/vscode-sops";
          license = lib.licenses.unfree;
          maintainers = [ ];
        };
      };

      silofy.hackthebox = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "hackthebox";
          publisher = "silofy";
          version = "0.2.9";
          hash = "sha256-WSPuEh+osu0DpXgPAzMU5Fw0Sh8sZFst7kx26s2BsyQ=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/silofy.hackthebox/changelog";
          description = "Visual Studio Code theme built for hackers by hackers";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=silofy.hackthebox";
          homepage = "https://github.com/silofy/hackthebox";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.d3vil0p3r ];
        };
      };

      skellock.just = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "just";
          publisher = "skellock";
          version = "2.0.0";
          hash = "sha256-FOp/dcW0+07rADEpUMzx+SGYjhvE4IhcCOqUQ38yCN4=";
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

      smcpeak.default-keys-windows = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "default-keys-windows";
          publisher = "smcpeak";
          version = "0.0.10";
          hash = "sha256-v1JY5ZGWOfF14H235Y9CLlPwIvmNwCeRhIkdmcgCCFU=";
        };
        meta = {
          changelog = "https://github.com/smcpeak/vscode-default-keys-windows/blob/master/CHANGELOG.md";
          description = "VSCode extension that provides default Windows keybindings on any platform";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=smcpeak.default-keys-windows";
          homepage = "https://github.com/smcpeak/vscode-default-keys-windows";
          license = lib.licenses.mit;
          maintainers = [ ];
        };
      };

      sonarsource.sonarlint-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "sonarlint-vscode";
          publisher = "sonarsource";
          version = "3.16.0";
          hash = "sha256-zWgITdvUS9fq1uT6A4Gs3fSTBwCXoEIQ/tVcC7Eigfs=";
        };
        meta.license = lib.licenses.lgpl3Only;
      };

      sourcery.sourcery = callPackage ./sourcery.sourcery { };

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

      sswg.swift-lang = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "swift-lang";
          publisher = "sswg";
          version = "1.10.4";
          hash = "sha256-5NrWBuaNdDNF0ON0HUwdwPFsRO3Hfe0UW4AooJbjiA0=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/sswg.swift-lang/changelog";
          description = "Swift Language Support for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=sswg.swift-lang";
          homepage = "https://github.com/swiftlang/vscode-swift";
          license = lib.licenses.asl20;
          maintainers = [ lib.maintainers.uncenter ];
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
          hash = "sha256-MrW0zInweAhU2spkEEiDLyuT6seV3GFFurWTqYMzqgY=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/stephlin.vscode-tmux-keybinding/changelog";
          description = "Simple extension for tmux behavior in vscode terminal";
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
          hash = "sha256-9t1lpVbpcmhLamN/0ZWNEWD812S6tXG6aK3/ALJCJvg=";
        };
        meta = {
          changelog = "https://github.com/stkb/Rewrap/blob/master/CHANGELOG.md";
          description = "Hard word wrapping for comments and other text at a given column";
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
          version = "4.0.7";
          hash = "sha256-y+xD8rOa/ljavAF7tdEpaOKEd4gUzfH15WBwMHyW7z4=";
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
          hash = "sha256-ZXXXFUriu//2Wmj1N+plj7xzJauGBfj+79SyrkUZAO4=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/styled-components.vscode-styled-components/changelog";
          description = "Syntax highlighting and IntelliSense for styled-components";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=styled-components.vscode-styled-components";
          homepage = "https://github.com/styled-components/vscode-styled-components";
          license = lib.licenses.mit;
        };
      };

      stylelint.vscode-stylelint = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-stylelint";
          publisher = "stylelint";
          version = "1.3.0";
          hash = "sha256-JoCa2d0ayBEuCcQi3Z/90GJ4AIECVz8NCpd+i+9uMeA=";
        };
        meta = {
          description = "Official Stylelint extension for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=stylelint.vscode-stylelint";
          homepage = "https://github.com/stylelint/vscode-stylelint";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.themaxmur ];
        };
      };

      sumneko.lua = callPackage ./sumneko.lua { };

      supermaven.supermaven = buildVscodeMarketplaceExtension {
        mktplcRef = {
          hash = "sha256-O3AN8fy28ZSun+k6MJnJdFcmwDDE21ib+I9HtDE0JwU=";
          name = "supermaven";
          publisher = "supermaven";
          version = "0.1.42";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/supermaven.supermaven/changelog";
          description = "Visual Studio Code extension for code completion suggestions";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=supermaven.supermaven";
          homepage = "https://supermaven.com/";
          license = lib.licenses.unfree;
          longDescription = ''
            Supermaven uses a 300,000 token context window to provide you the best code completion suggestions and the lowest latency.
            With our extension you will get the fastest and best completions of any tool on the market.
          '';
          maintainers = [ lib.maintainers.msanft ];
        };
      };

      svelte.svelte-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "svelte-vscode";
          publisher = "svelte";
          version = "108.3.3";
          hash = "sha256-q7w8DPzBLpD+13v7RnyDdC3ocDKAihHBVt3pnwSTwio=";
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
          hash = "sha256-JRM9Tm7yql7dKXOdpTwBVR/gx/nwvM7qqrCNlV2i1uI=";
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
          hash = "sha256-/onQybGMBscD6Rj4PWafetuag1J1cgHTw5NHri082cs=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      tailscale.vscode-tailscale = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-tailscale";
          publisher = "tailscale";
          version = "0.6.4";
          sha256 = "1jcq5kdcdyb5yyy0p9cnv56vmclvb6wdwq8xvy1qbkfdqbmy05gm";
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
          hash = "sha256-koeiFXUFI/i8EGCRDTym62m7JER18J9MKZpbAozr0Ng=";
        };
        meta = {
          license = lib.licenses.mpl20;
        };
      };

      tal7aouy.icons = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "icons";
          publisher = "tal7aouy";
          version = "3.8.0";
          hash = "sha256-PdhNFyVUWcOfli/ZlT+6TmtWrV31fBP1E1Vd4QWOY+A=";
        };
        meta = {
          description = "Icons for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=tal7aouy.icons";
          homepage = "https://github.com/tal7aouy/vscode-icons";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.themaxmur ];
        };
      };

      tamasfe.even-better-toml = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "even-better-toml";
          publisher = "tamasfe";
          version = "0.19.2";
          hash = "sha256-JKj6noi2dTe02PxX/kS117ZhW8u7Bhj4QowZQiJKP2E=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      teabyii.ayu = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "ayu";
          publisher = "teabyii";
          version = "1.0.5";
          sha256 = "sha256-+IFqgWliKr+qjBLmQlzF44XNbN7Br5a119v9WAnZOu4=";
        };
        meta = {
          description = "Simple theme with bright colors and comes in three versions — dark, light and mirage for all day long comfortable work";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=teabyii.ayu";
          homepage = "https://github.com/ayu-theme/vscode-ayu";
          license = lib.licenses.mit;
        };
      };

      techtheawesome.rust-yew = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "rust-yew";
          publisher = "techtheawesome";
          version = "0.2.2";
          hash = "sha256-t9DYY1fqW7M5F1pbIUtnnodxMzIzURew4RXT78djWMI=";
        };
        meta = {
          description = "VSCode extension that provides some language features for Yew's html macro syntax";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=TechTheAwesome.rust-yew";
          homepage = "https://github.com/TechTheAwesome/code-yew-server";
          license = lib.licenses.gpl3Only;
          maintainers = [ lib.maintainers.CardboardTurkey ];
        };
      };

      tekumara.typos-vscode = callPackage ./tekumara.typos-vscode { };

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
          version = "1.9.0";
          hash = "sha256-E9CK/GChd/yZT+P3ttROjL2jHtKPJ0KZzc32/nbuE4w=";
        };
        meta.license = lib.licenses.mit;
      };

      thorerik.hacker-theme = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "hacker-theme";
          publisher = "thorerik";
          version = "3.0.1";
          hash = "sha256-Ugk9kTJxW1kbD+X6PF96WBc1k7x4KaGu5WbCYPGQ3qE=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/thorerik.hacker-theme/changelog";
          description = "Perfect theme for writing IP tracers in Visual Basic and reverse-proxying a UNIX-system firewall";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=thorerik.hacker-theme";
          homepage = "https://github.com/thorerik/vscode-hacker-theme";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.d3vil0p3r ];
        };
      };

      tiehuis.zig = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "zig";
          publisher = "tiehuis";
          version = "0.2.6";
          hash = "sha256-s0UMY0DzEufEF+pizYeH4MKYOiiJ6z05gYHvfpaS4zA=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      tim-koehler.helm-intellisense = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "helm-intellisense";
          publisher = "Tim-Koehler";
          version = "0.14.3";
          hash = "sha256-TcXn8n6mKEFpnP8dyv+nXBjsyfUfJNgdL9iSZwA5eo0=";
        };
        meta = {
          description = "Extension to help writing Helm-Templates by providing intellisense";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=Tim-Koehler.helm-intellisense";
          homepage = "https://github.com/tim-koehler/Helm-Intellisense";
          license = lib.licenses.mit;
        };
      };

      timonwong.shellcheck = callPackage ./timonwong.shellcheck { };

      tobiasalthoff.atom-material-theme = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "atom-material-theme";
          publisher = "tobiasalthoff";
          version = "1.10.9";
          hash = "sha256-EdU0FMkaQpwhOpPRC+HGIxcrt7kSN+l4+mSgIwogB/I=";
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
          hash = "sha256-i3Rlizbw4RtPkiEsodRJEB3AUzoqI95ohyqZ0ksROps=";
        };
        meta = {
          description = "Show PDF preview in VSCode";
          homepage = "https://github.com/tomoki1207/vscode-pdfviewer";
          license = lib.licenses.mit;
        };
      };

      tsandall.opa = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "opa";
          publisher = "tsandall";
          version = "0.12.2";
          hash = "sha256-/eJzDhnQyvC9OBr4M03wLIWPiBeVtvX7ztSnO+YoCZM=";
        };
        meta = {
          changelog = "https://github.com/open-policy-agent/vscode-opa/blob/master/CHANGELOG.md";
          description = "Extension for VS Code which provides support for OPA";
          homepage = "https://github.com/open-policy-agent/vscode-opa";
          license = lib.licenses.asl20;
          maintainers = [ lib.maintainers.msanft ];
        };
      };

      tuttieee.emacs-mcx = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "emacs-mcx";
          publisher = "tuttieee";
          version = "0.47.0";
          hash = "sha256-dGty5+1+JEtJgl/DiyqEB/wuf3K8tCj1qWKua6ongIs=";
        };
        meta = {
          changelog = "https://github.com/whitphx/vscode-emacs-mcx/blob/main/CHANGELOG.md";
          description = "Awesome Emacs Keymap - VSCode emacs keybinding with multi cursor support";
          homepage = "https://github.com/whitphx/vscode-emacs-mcx";
          license = lib.licenses.mit;
        };
      };

      twpayne.vscode-testscript = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-testscript";
          publisher = "twpayne";
          version = "0.0.4";
          hash = "sha256-KOmcJlmmdUkC+q0AQ/Q/CQAeRgQPr6nVO0uccUxHmsY=";
        };
        meta = {
          description = "Syntax highlighting support for testscript";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=twpayne.vscode-testscript";
          homepage = "https://github.com/twpayne/vscode-testscript";
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
          hash = "sha256-AI16YBmmfZ3k7OyUrh4wujhu7ptqAwfI5jBbAc6MhDk=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      uiua-lang.uiua-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "uiua-vscode";
          publisher = "uiua-lang";
          version = "0.0.53";
          hash = "sha256-5CHAX1jGyJ2VVEBTh5G1JM8+L9paryBa2zJoTkZ+G7Q=";
        };
        meta = {
          description = "VSCode language extension for Uiua";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=uiua-lang.uiua-vscode";
          homepage = "https://github.com/uiua-lang/uiua-vscode";
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [
            tomasajt
            wackbyte
            defelo
          ];
        };
      };

      uloco.theme-bluloco-light = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "theme-bluloco-light";
          publisher = "uloco";
          version = "3.7.3";
          sha256 = "1il557x7c51ic9bjq7z431105m582kig9v2vpy3k2z3xhrbb0211";
        };
        postInstall = ''
          rm -r $out/share/vscode/extensions/uloco.theme-bluloco-light/screenshots
        '';
        meta = {
          description = "Fancy but yet sophisticated light designer color scheme / theme for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=uloco.theme-bluloco-light";
          homepage = "https://github.com/uloco/theme-bluloco-light";
          license = lib.licenses.lgpl3;
        };
      };

      unifiedjs.vscode-mdx = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-mdx";
          publisher = "unifiedjs";
          version = "1.4.0";
          hash = "sha256-qqqq0QKTR0ZCLdPltsnQh5eTqGOh9fV1OSOZMjj4xXg=";
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
          version = "3.16.0";
          hash = "sha256-Y3M/A5rYLkxQPRIZ0BUjhlkvixDae+wIRUsBn4tREFw=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/usernamehw.errorlens/changelog";
          description = "Visual Studio Code extension that improves highlighting of errors, warnings and other language diagnostics";
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

        nativeBuildInputs = [
          jq
          moreutils
        ];

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
          hash = "sha256-1JDm/cWNWwxa1gNsHIM/DIvqjXsO++hAf0mkjvKyi4g=";
        };
        meta = {
          license = lib.licenses.mit;
          maintainers = [ ];
        };
      };

      vincaslt.highlight-matching-tag = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "highlight-matching-tag";
          publisher = "vincaslt";
          version = "0.11.0";
          hash = "sha256-PxngjprSpWtD2ZDZfh+gOnZ+fVk5rvgGdZFxqbE21CY=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      visualstudioexptteam.intellicode-api-usage-examples = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "intellicode-api-usage-examples";
          publisher = "VisualStudioExptTeam";
          version = "0.2.8";
          hash = "sha256-aXAS3QX+mrX0kJqf1LUsvguqRxxC0o+jj1bKQteXPNA=";
        };
        meta = {
          description = "See relevant code examples from GitHub for over 100K different APIs right in your editor";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=VisualStudioExptTeam.intellicode-api-usage-examples";
          homepage = "https://github.com/MicrosoftDocs/intellicode";
          license = lib.licenses.cc-by-40;
          maintainers = [ lib.maintainers.themaxmur ];
        };
      };

      visualstudioexptteam.vscodeintellicode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscodeintellicode";
          publisher = "VisualStudioExptTeam";
          version = "1.2.30";
          hash = "sha256-f2Gn+W0QHN8jD5aCG+P93Y+JDr/vs2ldGL7uQwBK4lE=";
        };
        meta = {
          description = "AI-assisted development";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=VisualStudioExptTeam.vscodeintellicode";
          homepage = "https://github.com/MicrosoftDocs/intellicode";
          license = lib.licenses.cc-by-40;
          maintainers = [ lib.maintainers.themaxmur ];
        };
      };

      vitaliymaz.vscode-svg-previewer = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-svg-previewer";
          publisher = "vitaliymaz";
          version = "0.7.0";
          hash = "sha256-iX+Js2Pqz1gLDwrihuYtDwQG4ek7GiOhL3M0j3jHF/Y=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/vitaliymaz.vscode-svg-previewer/changelog";
          description = "Preview SVGs in VS Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=vitaliymaz.vscode-svg-previewer";
          homepage = "https://github.com/vitaliymaz/vscode-svg-previewer";
          license = lib.licenses.unfree;
          maintainers = [ lib.maintainers.uncenter ];
        };
      };

      vlanguage.vscode-vlang = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-vlang";
          publisher = "vlanguage";
          version = "0.1.14";
          hash = "sha256-hlBALxBs5wZZFk4lgAkdkGs731Xuc2p0qxffOW6mMWQ=";
        };
        meta = {
          description = "V language support (syntax highlighting, formatter, snippets) for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=vlanguage.vscode-vlang";
          homepage = "https://github.com/vlang/vscode-vlang";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.themaxmur ];
        };
      };

      vscjava.vscode-gradle = buildVscodeMarketplaceExtension rec {
        mktplcRef = {
          name = "vscode-gradle";
          publisher = "vscjava";
          version = "3.13.2024011802";
          hash = "sha256-TCYGL2GZCb1UFvJEoACPHg+DxTmDu0E8lvyNiy95bRw=";
        };

        meta = {
          changelog = "https://marketplace.visualstudio.com/items/vscjava.vscode-gradle/changelog";
          description = "Visual Studio Code extension for Gradle build tool";
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
          version = "0.55.2023121302";
          hash = "sha256-8kwV5LsAoad+16/PAVFqF5Nh6TbrLezuRS+buh/wFFo=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vscjava.vscode-java-dependency = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-java-dependency";
          publisher = "vscjava";
          version = "0.23.2024010506";
          hash = "sha256-kP5NTj1gGSNRiiT6cgBLsgUhBmBEULQGm7bqebRH+/w=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vscjava.vscode-java-test = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-java-test";
          publisher = "vscjava";
          version = "0.40.2024011806";
          hash = "sha256-ynl+94g34UdVFpl+q1XOFOLfNsz/HMOWeudL8VNG2bo=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vscjava.vscode-java-pack = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-java-pack";
          publisher = "vscjava";
          version = "0.25.2023121402";
          hash = "sha256-JhVJK2gZe3R6dpynon+9wauSAWPdW4LmG9oRWylCexM=";
        };
        meta = {
          description = "Popular extensions for Java development that provides Java IntelliSense, debugging, testing, Maven/Gradle support, project management and more";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-pack";
          homepage = "https://github.com/Microsoft/vscode-java-pack";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.themaxmur ];
        };
      };

      vscjava.vscode-maven = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-maven";
          publisher = "vscjava";
          version = "0.43.2024011905";
          hash = "sha256-75pttt0nCuZNP+1e9lmsAqLSDHdca3o+K1E5h0Y9u0I=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vscjava.vscode-spring-initializr = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-spring-initializr";
          publisher = "vscjava";
          version = "0.11.2023070103";
          hash = "sha256-EwUwMCaaW9vhrW3wl0Q7T25Ysm0c35ZNOkJ+mnRXA8Y=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vscode-icons-team.vscode-icons = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-icons";
          publisher = "vscode-icons-team";
          version = "12.8.0";
          hash = "sha256-2+Wf0AL9C5xOQCjA9maMt/W/kviNuiyMfaOFDU82KxM=";
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
          version = "1.26.1";
          hash = "sha256-zshuABicdkT52Nqj1L2RrfMziBRgO+R15fM32SCnyXI=";
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
          hash = "sha256-iTFwm/P2wzbNahozyLbdfokcSDHFzLrzVDHI/g2aFm0=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vue.volar = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "volar";
          publisher = "Vue";
          version = "2.0.16";
          hash = "sha256-RTBbF7qahYP4L7SZ/5aCM/e5crZAyyPRcgL48FVL1jk=";
        };
        meta = {
          changelog = "https://github.com/vuejs/language-tools/blob/master/CHANGELOG.md";
          description = "Official Vue VSCode extension";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=Vue.volar";
          homepage = "https://github.com/vuejs/language-tools";
          license = lib.licenses.mit;
        };
      };

      vspacecode.whichkey = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "whichkey";
          publisher = "VSpaceCode";
          version = "0.11.3";
          hash = "sha256-PnaOwOIcSo1Eff1wOtQPhoHYvrHDGTcsRy9mQfdBPX4=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vue.vscode-typescript-vue-plugin = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-typescript-vue-plugin";
          publisher = "Vue";
          version = "1.8.27";
          hash = "sha256-ym1+WPKBcn4h9lqSFVehfiDoGUEviOSEVXVLhHcYvfc=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/Vue.vscode-typescript-vue-plugin/changelog";
          description = "Vue VSCode extension for TypeScript";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=Vue.vscode-typescript-vue-plugin";
          homepage = "https://github.com/vuejs/language-tools";
          license = lib.licenses.mit;
        };
      };

      waderyan.gitblame = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "gitblame";
          publisher = "waderyan";
          version = "10.5.1";
          sha256 = "119rf52xnxz0cwvvjjfc5m5iv19288cxz33xzr79b67wyfd79hl9";
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
          hash = "sha256-H3f1+c31x+lgCzhgTb0uLg9Bdn3pZyJGPPwfpCYrS70=";
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
          hash = "sha256-tN/jlG2PzuiCeERpgQvdqDoa3UgrUaM7fKHv6KFqujc=";
        };
        meta = {
          description = "VSCode extension for quickly changing the case (camelCase, CONSTANT_CASE, snake_case, etc) of the current selection or current word";
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
          hash = "sha256-n91Rj1Rpp7j7gndkt0bV+jT1nRMv7+coVoSL5c7Ii3A=";
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

      xdebug.php-debug = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "php-debug";
          publisher = "xdebug";
          version = "1.34.0";
          hash = "sha256-WAcXWCMmvuw7nkfGcOgmK+s+Nw6XpvNR4POXD85E/So=";
        };
        meta = {
          description = "PHP Debug Adapter";
          license = lib.licenses.mit;
          homepage = "https://github.com/xdebug/vscode-php-debug";
          changelog = "https://github.com/xdebug/vscode-php-debug/blob/main/CHANGELOG.md";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=xdebug.php-debug";
          maintainers = [ lib.maintainers.onny ];
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

      yoavbls.pretty-ts-errors = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "pretty-ts-errors";
          publisher = "yoavbls";
          version = "0.5.4";
          hash = "sha256-SMEqbpKYNck23zgULsdnsw4PS20XMPUpJ5kYh1fpd14=";
        };
        meta = {
          description = "Make TypeScript errors prettier and human-readable in VSCode";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=yoavbls.pretty-ts-errors";
          homepage = "https://github.com/yoavbls/pretty-ts-errors";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.uncenter ];
        };
      };

      yzhang.dictionary-completion = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "yzhang";
          name = "dictionary-completion";
          version = "1.2.2";
          hash = "sha256-dpJcJARRKzRNHfXs/qknud8OQ8xIyeaVnt/EcDq0k4E=";
        };
        meta = {
          description = "Visual Studio Code extension to help user easyly finish long words ";
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
          version = "3.6.2";
          sha256 = "1n9d3qh7vypcsfygfr5rif9krhykbmbcgf41mcjwgjrf899f11h4";
        };
        meta = {
          description = "All you need to write Markdown (keyboard shortcuts, table of contents, auto preview and more)";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one";
          homepage = "https://github.com/yzhang-gh/vscode-markdown";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.raroh73 ];
        };
      };

      zaaack.markdown-editor = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "markdown-editor";
          publisher = "zaaack";
          version = "0.1.10";
          hash = "sha256-K1nczR059BsiHpT1xdtJjpFLl5krt4H9+CrEsIycq9U=";
        };
        meta = {
          description = "Visual Studio Code extension for WYSIWYG markdown editing";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=zaaack.markdown-editor";
          homepage = "https://github.com/zaaack/vscode-markdown-editor";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.pandapip1 ];
        };
      };

      zainchen.json = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "json";
          publisher = "ZainChen";
          version = "2.0.2";
          hash = "sha256-nC3Q8KuCtn/jg1j/NaAxWGvnKe/ykrPm2PUjfsJz8aI=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/ZainChen.json/changelog";
          description = "Visual Studio Code extension for JSON support";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ZainChen.json";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.rhoriguchi ];
        };
      };

      zguolee.tabler-icons = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "tabler-icons";
          publisher = "zguolee";
          version = "0.3.4";
          hash = "sha256-0XvB9UXqKHbL/ejUfciSvFzZ3GacaQ7pq6hJqRaxq+8=";
        };
        meta = {
          description = "Tabler product icon theme for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=zguolee.tabler-icons";
          homepage = "https://github.com/zguolee/vscode-tabler-icons";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.uncenter ];
        };
      };

      zhuangtongfa.material-theme = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "material-theme";
          publisher = "zhuangtongfa";
          version = "3.16.2";
          sha256 = "0ava94zn68lxy3ph78r5rma39qz03al5l5i6x070mpa1hzj3i319";
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
          hash = "sha256-PXaHSEXoN0ZboHIoDg37tZ+Gv6xFXP4wGBS3YS/53TY=";
        };
        meta = {
          description = "Basic RISC-V colorization and snippets support";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=zhwu95.riscv";
          homepage = "https://github.com/zhuanhao-wu/vscode-riscv-support";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.CardboardTurkey ];
        };
      };

      ziglang.vscode-zig = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-zig";
          publisher = "ziglang";
          version = "0.5.1";
          hash = "sha256-ygxvkewK5Tf1zNIXxzu6D/tKYNVcNsU9cKij7d5aRdQ=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/ziglang.vscode-zig/changelog";
          description = "Zig support for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ziglang.vscode-zig";
          homepage = "https://github.com/ziglang/vscode-zig";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.wackbyte ];
        };
      };

      zxh404.vscode-proto3 = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-proto3";
          publisher = "zxh404";
          version = "0.5.4";
          sha256 = "08dfl5h1k6s542qw5qx2czm1wb37ck9w2vpjz44kp2az352nmksb";
        };
        nativeBuildInputs = [
          jq
          moreutils
        ];
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
    _13xforever = throw "_13xforever is deprecated in favor of 13xforever"; # Added 2024-05-29
    _1Password = throw "_1Password is deprecated in favor of 1Password"; # Added 2024-05-29
    _2gua = throw "_2gua is deprecated in favor of 2gua"; # Added 2024-05-29
    _4ops = throw "_4ops is deprecated in favor of 4ops"; # Added 2024-05-29
    Arjun.swagger-viewer = throw "Arjun.swagger-viewer is deprecated in favor of arjun.swagger-viewer"; # Added 2024-05-29
    jakebecker.elixir-ls = throw "jakebecker.elixir-ls is deprecated in favor of elixir-lsp.vscode-elixir-ls"; # Added 2024-05-29
    jpoissonnier.vscode-styled-components = throw "jpoissonnier.vscode-styled-components is deprecated in favor of styled-components.vscode-styled-components"; # Added 2024-05-29
    matklad.rust-analyzer = throw "matklad.rust-analyzer is deprecated in favor of rust-lang.rust-analyzer"; # Added 2024-05-29
    mgt19937.typst-preview = throw "The features of 'typst-preview' have been consolidated to 'tinymist', an all-in-one language server for typst"; # Added 2024-07-07
    ms-vscode.go = throw "ms-vscode.go is deprecated in favor of golang.go"; # Added 2024-05-29
    ms-vscode.PowerShell = throw "ms-vscode.PowerShell is deprecated in favor of super.ms-vscode.powershell"; # Added 2024-05-29
    rioj7.commandOnAllFiles = throw "rioj7.commandOnAllFiles is deprecated in favor of rioj7.commandonallfiles"; # Added 2024-05-29
    WakaTime.vscode-wakatime = throw "WakaTime.vscode-wakatime is deprecated in favor of wakatime.vscode-wakatime"; # Added 2024-05-29
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
