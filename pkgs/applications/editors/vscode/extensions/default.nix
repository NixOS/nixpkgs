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
          version = "3.1.5";
          hash = "sha256-WIhmAZLR2WOSqQF3ozJ/Vr3Rp6HdSK7L23T3h4AVaGM=";
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
          version = "1.0.5";
          hash = "sha256-J7vAK2t6fSjm5i6y3+88aO84ipFwekQkJMD7W3EIWrc=";
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
          version = "4.38.0";
          hash = "sha256-J9hZhPrHkJEFkiyD8eACiJwbsPfYGMK42FkcwkTQ0RE=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/42Crunch.vscode-openapi/changelog";
          description = "Visual Studio Code extension with rich support for the OpenAPI Specification (OAS)";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=42Crunch.vscode-openapi";
          homepage = "https://github.com/42Crunch/vscode-openapi";
          license = lib.licenses.agpl3Only;
          maintainers = [ lib.maintainers.benhiemer ];
        };
      };

      a5huynh.vscode-ron = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-ron";
          publisher = "a5huynh";
          version = "0.11.0";
          hash = "sha256-xIGOgK/kcdwm8EicAGIac5zPqRxw6ZTRLwteC03NKQ8=";
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
          description = "Improve your code commenting by annotating with alert, informational, TODOs, and more";
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
          version = "1.0.8";
          hash = "sha256-bogT5Cshl6Rab5iiXWPwju29XX4PHdbR64J5UFPSlRo=";
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
          version = "0.2.1"; # see the note above
          sha256 = "sha256-/RA+7OnoR5Nu2bK6dFEL8aZW+CJkTeM0bKG6k5X1g+I=";
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
          version = "13.5.0";
          hash = "sha256-oKhd5BLa2wuGNrzW9yKsWWzaU5hNolw2pBcqPlql9Ro=";
        };
        meta = {
          license = lib.licenses.gpl3;
        };
      };

      alefragnani.project-manager = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "project-manager";
          publisher = "alefragnani";
          version = "12.8.0";
          hash = "sha256-sNiDyWdQ40Xeu7zp1ioRCi3majrPshlVbUSV2klr4r4=";
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

      almenon.arepl = callPackage ./almenon.arepl { };

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

      amazonwebservices.amazon-q-vscode = callPackage ./amazonwebservices.amazon-q-vscode { };

      anthropic.claude-code = callPackage ./anthropic.claude-code { };

      angular.ng-template = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "ng-template";
          publisher = "Angular";
          version = "20.2.2";
          hash = "sha256-2I5Pmd05zNGjM15tFo2yw6AGUKp3zxufVcoe4oSAO5U=";
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
          version = "0.2.8";
          hash = "sha256-9ZU6xZxoT+z/hy+HAbrf52rbSdrA448Ph5/N7A3QB2A=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      antfu.slidev = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "antfu";
          name = "slidev";
          version = "51.4.0";
          hash = "sha256-Z9YNMhRtW8A0hi3e77negSIw1avsbb6+L701pgv5RTY=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      antyos.openscad = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "openscad";
          publisher = "Antyos";
          version = "1.3.2";
          hash = "sha256-1hEUBJW4QNq0ECO9Mwk4OCDxu4VQ+ZvMrj2rRna51Gc=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/Antyos.openscad/changelog";
          description = "OpenSCAD highlighting, snippets, and more for VSCode";
          homepage = "https://github.com/Antyos/vscode-openscad";
          license = lib.licenses.gpl3;
        };
      };

      anweber.vscode-httpyac = callPackage ./anweber.vscode-httpyac { };

      apollographql.vscode-apollo = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-apollo";
          publisher = "apollographql";
          version = "2.6.3";
          hash = "sha256-1F0iy5GhpuCqTrP/atoOyD0SWNOwa1sKXH14kN4FXNE=";
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
          version = "1.1.0";
          hash = "sha256-c5WX5L1hufKwBX64UiaLWOQaZTYma+6AbOphLPEQ9C8=";
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
          version = "0.3.4";
          hash = "sha256-X+CFRKAZmjzf5dkE/AGd3A/voX/XHfMP5WEt8sJll8U=";
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
          version = "2.15.4";
          hash = "sha256-dyv7GTscj57Uc+HgImXETKW8olGcWpL+FyAHoS36rmk=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/astro-build.astro-vscode/changelog";
          description = "Astro language support for VS Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=astro-build.astro-vscode";
          homepage = "https://github.com/withastro/language-tools";
          license = lib.licenses.mit;
          maintainers = [ ];
        };
      };

      asvetliakov.vscode-neovim = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-neovim";
          publisher = "asvetliakov";
          version = "1.18.24";
          hash = "sha256-oqsqcB2i8zS2pBElTFHh/diffTLFE9IRDjcQv/IcMgU=";
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
          version = "0.3.5";
          hash = "sha256-ff4mqEqO07z/pV2U/R4NsFW7czG+5+M/a2x7vv1ly7E=";
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
          version = "3.0.146";
          hash = "sha256-gvj5vWA8VAy5Ohtkn9vsx7MswgVAcxYOLm+ifKhjLz0=";
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
          version = "0.6.7";
          hash = "sha256-G8zAFEMM+fsndBjySkQpRlEj9+EGmMNTTI9AUIoMWR0=";
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
          version = "1.15.0";
          hash = "sha256-WBZsZNcq9OY30uaksfcRmCvHcugemMhsJ6d6/IncR5s=";
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
          version = "0.12.0";
          sha256 = "sha256-H0MAoqEQcT/tuDbiubCf9DCHt55M5Nx6IxzU5a3l5bo=";
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

      bierner.color-info = callPackage ./bierner.color-info { };

      bierner.docs-view = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "docs-view";
          publisher = "bierner";
          version = "0.1.0";
          hash = "sha256-Y5bQVb0OuhHvpvZPXlJRe17qSN3tzqm8JwS6nO2tG7g=";
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
          description = "VSCode extension that changes the markdown preview to support GitHub markdown features";
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
          version = "0.3.1";
          hash = "sha256-gfdEwKXLSu54M1gApM1Y1jofAtTdmg5UuBT8f/TUCRA=";
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
          maintainers = [ ];
        };
      };

      bierner.markdown-mermaid = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "markdown-mermaid";
          publisher = "bierner";
          version = "1.29.0";
          hash = "sha256-qjfZ2/otO2BAIbhjqicHI2H0KKdpji55K+2XfOrzUIw=";
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
          version = "2.2.0";
          hash = "sha256-Jg8XpMoSVZA/VpQhLY3bmmG9pb0XL2CRlhlemcWvzSg=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/bierner.markdown-preview-github-styles/changelog";
          description = "Changes VS Code's built-in markdown preview to match GitHub's styling";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=bierner.markdown-preview-github-styles";
          homepage = "https://github.com/mjbvz/vscode-github-markdown-preview-style";
          license = lib.licenses.mit;
          maintainers = [ ];
        };
      };

      biomejs.biome = callPackage ./biomejs.biome { };

      bmalehorn.vscode-fish = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "bmalehorn";
          name = "vscode-fish";
          version = "1.0.39";
          hash = "sha256-T5wD4btQ2HSq3vB1m/qHM7VcvHfZmMD9OV93ZwxXcQg=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/bmalehorn.vscode-fish/changelog";
          description = "Fish syntax highlighting and formatting for VS Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=bmalehorn.vscode-fish";
          homepage = "https://github.com/bmalehorn/vscode-fish";
          license = lib.licenses.mit;
          maintainers = [ ];
        };
      };

      bmewburn.vscode-intelephense-client = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-intelephense-client";
          publisher = "bmewburn";
          version = "1.14.4";
          hash = "sha256-WBtaRLAdE2Ttlq4fAS2kI3d0dUAVB+CTdksiSILJ4hY=";
        };
        meta = {
          description = "PHP code intelligence for Visual Studio Code";
          license = lib.licenses.unfree;
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=bmewburn.vscode-intelephense-client";
          maintainers = [ ];
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

      bodil.blueprint-gtk = callPackage ./bodil.blueprint-gtk { };

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
          version = "0.14.28";
          hash = "sha256-xq12b0i0TsYZ5XxF1t9c2YrV7wAROjEjdLgBg3ZaLi0=";
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
          description = "Solarized-palenight theme for vscode";
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

      budparr.language-hugo-vscode = callPackage ./budparr.language-hugo-vscode { };

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

      capatech.betacode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "betacode";
          publisher = "capatech";
          version = "0.1.10";
          hash = "sha256-Sq+s1dM+gZo73VaGEAX88fgVRAhWklg0LKv+yH46Jfw=";
        };
        meta = {
          description = "VSCode extension for writing polytonic Greek";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=Capatech.betacode";
          homepage = "https://github.com/kugland/vscode-extension-betacode";
          license = lib.licenses.gpl3;
          maintainers = with lib.maintainers; [ thtrf ];
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

      castwide.solargraph = callPackage ./castwide.solargraph { };

      catppuccin = {
        catppuccin-vsc = buildVscodeMarketplaceExtension {
          mktplcRef = {
            name = "catppuccin-vsc";
            publisher = "catppuccin";
            version = "3.18.0";
            hash = "sha256-57c0HRdEABLz03qozeQgFJH1NaWUbA+7tDJv0V4At8M=";
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
            version = "1.26.0";
            hash = "sha256-V1ZhNtCouo0EDrblvoZsiMy7BPPSGdOn5SoZl4kA/z0=";
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

      chanhx.crabviz = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "crabviz";
          publisher = "chanhx";
          version = "0.5.0";
          hash = "sha256-YLNx/9jmHc0HDm/yHquOlMDPmAbpIdd6UZn0JZQVJko=";
        };
        meta = {
          description = "VSCode extension for generating call graphs based on LSP";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=chanhx.crabviz";
          homepage = "https://github.com/chanhx/crabviz";
          license = lib.licenses.asl20;
          maintainers = with lib.maintainers; [ thtrf ];
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

      chrischinchilla.vscode-pandoc = callPackage ./chrischinchilla.vscode-pandoc { };

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
          maintainers = [ ];
        };
        mktplcRef = {
          name = "chatgpt-reborn";
          publisher = "chris-hayes";
          version = "3.27.0";
          sha256 = "sha256-52SvGb9TsvDQey5cjw+ZIQBP/1dyWcHKNjqCCCyM6k4=";
        };
      };

      christian-kohler.path-intellisense = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "path-intellisense";
          publisher = "christian-kohler";
          version = "2.10.0";
          sha256 = "sha256-bE32VmzZBsAqgSxdQAK9OoTcTgutGEtgvw6+RaieqRs=";
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
          version = "1.11.2";
          hash = "sha256-7peB8y2cNPCYXbdey4POzFcdra/j/RNzSF2gO3SLlGA=";
        };
        meta = {
          description = "Extension for Visual Studio Code to open any Coder workspace in VS Code with a single click";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=coder.coder-remote";
          homepage = "https://github.com/coder/vscode-coder";
          license = lib.licenses.mit;
          maintainers = [ ];
        };
      };

      codezombiech.gitignore = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "gitignore";
          publisher = "codezombiech";
          version = "0.10.0";
          hash = "sha256-WTKVHrhBeAocP+stskFsSFtd0aR3u1TTEMYtdxj1tlY=";
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

      continue.continue = callPackage ./continue.continue { };

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
          version = "2.0.8";
          hash = "sha256-rMc5ywTxVu6Dtxkzai4XQk1W2slCuT2j93p1zc6qtOI=";
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
          version = "1.4.6";
          hash = "sha256-989egeJlpJ2AfZra9VSQDQ8e+nQCa2sfoUeti674ecA=";
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
          version = "8.4.2";
          hash = "sha256-SfvpR1ldrvo/q0nt0cLu55bzNXjwNNdqdSwBORN2Bjw=";
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
          version = "0.1.44";
          hash = "sha256-b8zf6p5N51VHSgyFWsFBmCd3GvRgBeFpikt8GfoG7J0=";
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
          version = "3.14.135";
          hash = "sha256-y7qfBzXqyGrZXrpIkbMA1TDEQsKcfPCLmllypNu51G0=";
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
          version = "0.3.1";
          hash = "sha256-DentLM/XT7b7O4vptVcja9E8pQjiDPOLilo8wjTH0IE=";
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
          version = "3.120.0";
          hash = "sha256-YXQhdn9bOpVGeG0mKPazMvsZecx4sd1ZpSdHfH3eNOY=";
        };

        meta.license = lib.licenses.mit;
      };

      dart-code.flutter = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "flutter";
          publisher = "dart-code";
          version = "3.120.0";
          hash = "sha256-P3kn4hqmIamEH6c+TAq9fAQmSomRLSRghJ4uhKnWqn4=";
        };

        meta.license = lib.licenses.mit;
      };

      databricks.databricks = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "databricks";
          publisher = "databricks";
          version = "2.10.3";
          hash = "sha256-t3PZiKvctJEzABuX5p1AdNXj8bYDhfFMJnYVnpbDyqk=";
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
          version = "0.60.0";
          hash = "sha256-Buwa63HahT96qhhuvARW7p1u9kbkoEyA9usoh60m3KE=";
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
          version = "0.25.1";
          hash = "sha256-rfBIHGRxCAzGZXSeWpMJzDsJxkBYYLpwdmUdEkwbM9I=";
        };
        meta = {
          description = "LanguageTool integration for VS Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=davidlday.languagetool-linter";
          homepage = "https://github.com/davidlday/vscode-languagetool-linter";
          license = lib.licenses.asl20;
          maintainers = [ lib.maintainers.ebbertd ];
        };
      };

      dbaeumer.vscode-eslint = callPackage ./dbaeumer.vscode-eslint { };

      dendron.adjust-heading-level = callPackage ./dendron.adjust-heading-level { };

      dendron.dendron = callPackage ./dendron.dendron { };

      dendron.dendron-paste-image = callPackage ./dendron.dendron-paste-image { };

      dendron.dendron-snippet-maker = callPackage ./dendron.dendron-snippet-maker { };

      denoland.vscode-deno = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "denoland";
          name = "vscode-deno";
          version = "3.45.2";
          hash = "sha256-U83RWIIorJdFuhr0/l2bIo5JthTFIvedWq52dsSGOx8=";
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

      detachhead.basedpyright = callPackage ./detachhead.basedpyright { };

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
          version = "2.27.9";
          hash = "sha256-6+sAbjpwWTLGZ7uH6rl7LZcNmOnAftiYGithbBlvIak=";
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
          version = "0.0.14";
          hash = "sha256-dnHaJRlFd535Gi3T1+0YBOnytmf2W15Vta5H6HhzYZI=";
        };
        meta = {
          license = lib.licenses.asl20;
        };
      };

      divyanshuagrawal.competitive-programming-helper = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "competitive-programming-helper";
          publisher = "DivyanshuAgrawal";
          version = "2025.7.1752155836";
          hash = "sha256-vI30wuv8833sG0RZdStBSSYTPbtt5ZrsRX+1iAVI7yg=";
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

      docker.docker = callPackage ./docker.docker { };

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
          version = "0.28.1";
          hash = "sha256-Ye3T/u/2mmezAi1ErtJBX7M/3rAb7Mc3wvMGJaX3r5s=";
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
          version = "2.25.1";
          hash = "sha256-ijGbdiqbDQmZYVqZCx2X4W7KRNV3UDddWvz+9x/vfcA=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/dracula-theme.theme-dracula/changelog";
          description = "Dark theme for many editors, shells, and more";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=dracula-theme.theme-dracula";
          homepage = "https://draculatheme.com/";
          license = lib.licenses.mit;
        };
      };

      eamodio.gitlens = callPackage ./eamodio.gitlens { };

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
          version = "2.0.13";
          hash = "sha256-2BtvIyeUaABsWjQNCSAk0WaGD75ecRA6yWbM/OiMyM0=";
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
          publisher = "editorconfig";
          name = "editorconfig";
          version = "0.17.4";
          hash = "sha256-MYPYhSKAxgaZ0UijxU+xiO4HDPLtXGymhN+2YmTev8M=";
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
          version = "0.0.124";
          hash = "sha256-a59xTFbLoy13V4DUqd7vIJWcJ9+eoBM0SOo51rR1r+Y=";
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

      egirlcatnip.adwaita-github-theme = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "adwaita-github-theme";
          publisher = "egirlcatnip";
          version = "1.0.6";
          hash = "sha256-6xooF8petGLn8Zlh8rCXG2RJdAcdt8t8GPwhfgc5Gxs=";
        };
        meta = {
          description = "Adwaita VS Code theme with Github syntax highlighting";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=egirlcatnip.adwaita-github-theme";
          homepage = "https://github.com/egirlcatnip/adwaita-github-theme";
          license = lib.licenses.gpl3;
          maintainers = with lib.maintainers; [ thtrf ];
        };
      };

      elijah-potter.harper = callPackage ./elijah-potter.harper { };

      elixir-lsp.vscode-elixir-ls = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "elixir-ls";
          publisher = "JakeBecker";
          version = "0.29.3";
          hash = "sha256-cghDjgv3FWsNpnH6Pa9iPuiPOlLI/iucGH+fzF35ERk=";
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
          version = "2.8.0";
          hash = "sha256-81tHgNjYc0LJjsgsQfo5xyh20k/i3PKcgYp9GZTvwfs=";
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
          version = "2.1.120";
          hash = "sha256-m5CPmilGF1jguhTZhPAUMrfzU4HU5SkiWeGOMAD+D/Y=";
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
          version = "1.1.2";
          hash = "sha256-oW0bkLKimpcjzxTb/yjShagjyVTUFEg198oPbY5J2hM=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/enkia.tokyo-night/changelog";
          description = "Clean Visual Studio Code theme that celebrates the lights of Downtown Tokyo at night";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=enkia.tokyo-night";
          homepage = "https://github.com/enkia/tokyo-night-vscode-theme";
          license = lib.licenses.mit;
        };
      };

      esbenp.prettier-vscode = callPackage ./esbenp.prettier-vscode { };

      ethansk.restore-terminals = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "restore-terminals";
          publisher = "ethansk";
          version = "1.1.8";
          hash = "sha256-pZK/QNomQoFRsL6LRIKvWQj8/SYo2ZdVU47Gsmb9MXo=";
        };
      };

      ethersync.ethersync = callPackage ./ethersync.ethersync { };

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
          version = "2.3.1";
          hash = "sha256-wqY8AArlTpQzoZ9OfV9MzlHIr9M/Ac4QUZL99n327EI=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/fabiospampinato.vscode-open-in-github/changelog";
          description = "VS Code extension to open the current project or file in github.com";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=fabiospampinato.vscode-open-in-github";
          homepage = "https://github.com/fabiospampinato/vscode-open-in-github";
          license = lib.licenses.mit;
          maintainers = [ ];
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
          version = "1.1.0";
          sha256 = "sha256-vtYERwOvWqJ0NifeSBTn+jzwJTDmMPRyHbPq6I1lW0w=";
        };
      };

      fill-labs.dependi = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "dependi";
          publisher = "fill-labs";
          version = "0.7.15";
          hash = "sha256-BXilurHO9WATC0PhT/scpZWEiRhJ9cSlq59opEM6wlE=";
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
          publisher = "firefox-devtools";
          name = "vscode-firefox-debug";
          version = "2.15.0";
          hash = "sha256-hBj0V42k32dj2gvsNStUBNZEG7iRYxeDMbuA15AYQqk=";
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
          version = "0.4.84";
          hash = "sha256-x4CaSa/CRZgs7vGthFcn8UXYrbQhQXkULPBbGnj3zpw=";
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
          version = "0.28.3";
          hash = "sha256-rRJrzCle1/epqJL+gaUb3QZwrmdaLvagUwxRx1Aq1ZY=";
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
          version = "0.5.15";
          hash = "sha256-8lRdNGa7Shhmko8lhKxexNj4mkGEwPihBrsQrm5a1kA=";
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
          version = "0.12.2";
          hash = "sha256-TI5K6n3QfJwgFz5xhpdZ+yzi9VuYGcSzdBckZ68DsUQ=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      fortran-lang.linter-gfortran = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "linter-gfortran";
          publisher = "fortran-lang";
          version = "3.4.2025030111";
          hash = "sha256-8gw7VAgT4+724cCjQcYESPTsnckd02vdBsCzskiZLKY=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/fortran-lang.linter-gfortran/changelog";
          description = "Fortran language support for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=fortran-lang.linter-gfortran";
          homepage = "https://github.com/fortran-lang/vscode-fortran-support";
          license = lib.licenses.mit;
          maintainers = [ ];
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

      fstarlang.fstar-vscode-assistant = callPackage ./fstarlang.fstar-vscode-assistant { };

      funkyremi.vscode-google-translate = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "funkyremi";
          name = "vscode-google-translate";
          version = "1.5.0";
          hash = "sha256-t6USs2mZE3g802BRwP56eH/Wj/cyAcA+h/V+++NtHnA=";
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
          description = "VSCode extension that adds syntax highlighting for Pandoc-flavored Markdown";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=garlicbreadcleric.pandoc-markdown-syntax";
          homepage = "https://github.com/garlicbreadcleric/vscode-pandoc-markdown";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.pandapip1 ];
        };
      };

      geequlim.godot-tools = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "godot-tools";
          publisher = "geequlim";
          version = "2.5.1";
          hash = "sha256-kAzRSNZw1zaECblJv7NzXnE2JXSy9hzdT2cGX+uwleY=";
        };
        meta = {
          description = "VS Code extension for game development with Godot Engine and GDScript";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=geequlim.godot-tools";
          homepage = "https://github.com/godotengine/godot-vscode-plugin";
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [ thtrf ];
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
          maintainers = [ ];
        };
        mktplcRef = {
          name = "chatgpt-vscode";
          publisher = "genieai";
          version = "0.0.13";
          sha256 = "sha256-aoVICzU5sfA96FCU4ysUGmULruGWLaVo2lFpiPhdtGA=";
        };
      };

      github.codespaces = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "github";
          name = "codespaces";
          version = "1.17.4";
          hash = "sha256-0fhPOtHpjafuo+oCCRmLKYI7Q22eE3vliH9q//ab6Ag=";
        };

        meta = {
          description = "VSCode extensions that provides cloud-hosted development environments for any activity";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=GitHub.codespaces";
          homepage = "https://github.com/features/codespaces";
          license = lib.licenses.unfree;
          maintainers = [ lib.maintainers.therobot2105 ];
        };
      };

      github.copilot = callPackage ./github.copilot { };

      github.copilot-chat = callPackage ./github.copilot-chat { };

      github.github-vscode-theme = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "github-vscode-theme";
          publisher = "github";
          version = "6.3.5";
          hash = "sha256-dOadoYBPcYrpzmqOpJwG+/nPwTfJtlsOFDU3FctdR0o=";
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
          version = "0.28.0";
          hash = "sha256-9DUS1wUeK4vBw/QIqOW8R7T7ho9hmTKuu7gRnM35Ahw=";
        };
        meta = {
          description = "Visual Studio Code extension for GitHub Actions workflows and runs for github.com hosted repositories";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=github.vscode-github-actions";
          homepage = "https://github.com/github/vscode-github-actions";
          license = lib.licenses.mit;
          maintainers = [ ];
        };
      };

      github.vscode-pull-request-github = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "github";
          name = "vscode-pull-request-github";
          version = "0.120.0";
          hash = "sha256-zBc6xLUKueT7hgyjZ9b/UHG7kbvUmWLEB0bngXZ8Rd4=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      gitlab.gitlab-workflow = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "gitlab-workflow";
          publisher = "gitlab";
          version = "6.49.7";
          hash = "sha256-jvVQFaHcXcZeg1xli5PCTo5RDouUBMFjMpJ3HC8GF4c=";
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
          version = "2.12.1";
          hash = "sha256-zU/iwaJ6ShEHYq7OeM6+RF/RVIx6SmJJKxtebN/tSGI=";
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
          version = "0.50.0";
          hash = "sha256-e0O5EXStxHw7sKozH6qzLSMzy00S+6Q7p9KtP+NbB6Y=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/golang.Go/changelog";
          description = "Go extension for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=golang.Go";
          homepage = "https://github.com/golang/vscode-go";
          license = lib.licenses.mit;
        };
      };

      Google.gemini-cli-vscode-ide-companion = callPackage ./Google.gemini-cli-vscode-ide-companion { };

      grapecity.gc-excelviewer = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "gc-excelviewer";
          publisher = "grapecity";
          version = "4.2.64";
          hash = "sha256-bHxU/u6T6r4rSfl9olBZZVI8NTttJFzJw3dgYlvavxw=";
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
          version = "0.13.2";
          hash = "sha256-9G6iIYjZE6s5EGRTc0Y6gUN1cK9Gm2ohnl3oYqBWGqs=";
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
          version = "1.3.8";
          hash = "sha256-10x2kX9Gc7O/tGRDPZfy1cKdCIvGTCXcD2bDokIz7TU=";
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
          maintainers = [ ];
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
          version = "0.6.0";
          hash = "sha256-Za2ODrsHR/y0X/FOhVEtbg6bNs439G6rlBHW84EZS60=";
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
          publisher = "haskell";
          name = "haskell";
          version = "2.6.1";
          hash = "sha256-44pQBHz8e1dCqZaa5+GhPr0/SUsHlaqdNMPZklKdY+Q=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      hbenl.vscode-test-explorer = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-test-explorer";
          publisher = "hbenl";
          version = "2.22.1";
          hash = "sha256-+vW/ZpOQXI7rDUAdWfNOb2sAGQQEolXjSMl2tc/Of8M=";
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
          version = "1.9.0";
          hash = "sha256-gi3+mMJcUnkb0FFb6gmx9eI8BRLX3z/kTr7Rk0hudP4=";
        };
        meta = {
          description = "This unofficial extension integrates Draw.io into VS Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=hediet.vscode-drawio";
          homepage = "https://github.com/hediet/vscode-drawio";
          license = lib.licenses.gpl3Only;
          maintainers = [ lib.maintainers.themaxmur ];
        };
      };

      hirse.vscode-ungit = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-ungit";
          publisher = "hirse";
          version = "2.5.2";
          hash = "sha256-0CFYL6rBecB8rNnk4IAtg03ZPdSJ9qxwnVdhdQedxsQ=";
        };
        meta = {
          description = "Ungit in Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=Hirse.vscode-ungit";
          homepage = "https://github.com/hirse/vscode-ungit";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.therobot2105 ];
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

      huacnlee.autocorrect = callPackage ./huacnlee.autocorrect { };

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
          version = "1.1.7";
          hash = "sha256-3/rsYq+HZgRW2Vd91ZW9rkXWUTUFzG/mCWD0pm++WA4=";
        };
        meta = {
          description = "ANSI color styling for text documents";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=iliazeus.vscode-ansi";
          homepage = "https://github.com/iliazeus/vscode-ansi";
          license = lib.licenses.mit;
        };
      };

      illixion.vscode-vibrancy-continued = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-vibrancy-continued";
          publisher = "illixion";
          version = "1.1.60";
          hash = "sha256-GHAyC9ScrBV/huVXXrgbubrBmKIzUhYmCL2+GqoOjqc=";
        };
        meta = {
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=illixion.vscode-vibrancy-continued";
          changelog = "https://marketplace.visualstudio.com/items/illixion.vscode-vibrancy-continued/changelog";
          homepage = "https://github.com/illixion/vscode-vibrancy-continued#readme";
          description = "Vibrancy Effect for Visual Studio Code";
          maintainers = with lib.maintainers; [ _2hexed ];
          license = lib.licenses.mit;
        };
      };

      influxdata.flux = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "influxdata";
          name = "flux";
          version = "1.0.5";
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
          version = "3.0.0";
          hash = "sha256-AtM56NkivTK4cGyKBsaZTHYvDwiJb4CrEuiJiw5hTcI=";
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

      ionic.ionic = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "ionic";
          publisher = "ionic";
          version = "1.105.0";
          hash = "sha256-wUYX7TmCyzKGPnl7LycfxN5axCGzq/T2/+XnSdPJJEI=";
        };
        meta = {
          description = "Official VSCode extension for Ionic and Capacitor development";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ionic.ionic";
          homepage = "https://github.com/ionic-team/vscode-ionic";
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [ thtrf ];
        };
      };

      ionide.ionide-fsharp = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "Ionide-fsharp";
          publisher = "Ionide";
          version = "7.28.0";
          hash = "sha256-d6AucdoKeVAobTj1cbELce2vcXsZW5TX74mkcnHPtkA=";
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

      james-yu.latex-workshop = callPackage ./james-yu.latex-workshop { };

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
          maintainers = [ ];
        };
      };

      jasew.anki = callPackage ./jasew.anki { };

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
          maintainers = [ ];
        };
      };

      jdinhlife.gruvbox = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "gruvbox";
          publisher = "jdinhlife";
          version = "1.29.0";
          hash = "sha256-LDbeCwuUxvyuacuvikZbV25iEtXWPRJ/ihnqpuM8Ky4=";
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
          version = "2.2.3";
          hash = "sha256-KhmkCMBWagi0JjZvupgaU7LA6hsGRE6SiHqdJlXyyX8=";
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

      jetmartin.bats = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "bats";
          publisher = "jetmartin";
          version = "0.1.10";
          hash = "sha256-WD1YTRgzSVElixnNGtg6mMlcLCIaI6IBb+uh4cfzuBs=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/jetmartin.bats/changelog";
          description = "VSCode extension for full language support for the Bats (Bash Automated Testing System) testing framework";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=jetmartin.bats";
          homepage = "https://github.com/bats-core/bats-vscode";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.dotmobo ];
        };
      };

      jkillian.custom-local-formatters = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "jkillian";
          name = "custom-local-formatters";
          version = "0.1.1";
          hash = "sha256-Yxui136wK+C5d0h79nXpGQ+lEclmne8XNNxDgUEG6kM=";
        };
        meta = {
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.kamadorueda ];
        };
      };

      jnoortheen.nix-ide = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "jnoortheen";
          name = "nix-ide";
          version = "0.5.0";
          hash = "sha256-jVuGQzMspbMojYq+af5fmuiaS3l3moG8L8Kyf40vots=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/jnoortheen.nix-ide/changelog";
          description = "Nix language support with formatting and error report";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=jnoortheen.nix-ide";
          homepage = "https://github.com/nix-community/vscode-nix-ide";
          license = lib.licenses.mit;
          maintainers = [ ];
        };
      };

      jock.svg = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "svg";
          publisher = "jock";
          version = "1.5.4";
          hash = "sha256-LZLKUmYSnlgypLXKFOGezMepV10t35unpEnCMaLRjeU=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      johnpapa.vscode-peacock = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-peacock";
          publisher = "johnpapa";
          version = "4.2.3";
          sha256 = "sha256-SVjuWjvQogtT74QRDxGJVvlXU035VMWtLiDz395URRE=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      johnpapa.winteriscoming = callPackage ./johnpapa.winteriscoming { };

      jgclark.vscode-todo-highlight = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-todo-highlight";
          publisher = "jgclark";
          version = "2.0.8";
          hash = "sha256-/CctaLcG+dA2Cf69/ACeDKdRLsu/VUGbAxUbyhI0VyA=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/wayou.vscode-todo-highlight/changelog";
          description = "Highlight TODOs, FIXMEs, and any keywords, annotations...";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=jgclark.vscode-todo-highlight";
          homepage = "https://github.com/jgclark/vscode-todo-highlight";
          license = lib.licenses.mit;
        };
      };

      jroesch.lean = buildVscodeMarketplaceExtension rec {
        mktplcRef = {
          name = "lean";
          publisher = "jroesch";
          version = "0.16.60";
          hash = "sha256-z0mOnbqpKMH5d78jAMgDIgO+5sk4xHOWAfa4kzXYISs=";
        };
        meta = {
          changelog = "https://github.com/leanprover/vscode-lean/blob/v${mktplcRef.version}/README.md#release-notes";
          description = "Lean 3 language support for VS Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=jroesch.lean";
          homepage = "https://github.com/leanprover/vscode-lean";
          license = lib.licenses.asl20;
          maintainers = with lib.maintainers; [ dotlambda ];
        };
      };

      julialang.language-julia = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "language-julia";
          publisher = "julialang";
          version = "1.149.2";
          hash = "sha256-4IScbHi9iKd4zn0J5HG6FAdIXESwMrh0u07gw9TZJJ4=";
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
          publisher = "justusadam";
          name = "language-haskell";
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
          version = "1.7.5";
          hash = "sha256-DOSe0UhNMj6FRyHylnKYQsyhSLQQFvGfcmOBZSw+nVo=";
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
          version = "0.6.67";
          hash = "sha256-cevda4fpNcZqnkN80Cjw4mDAzCvG2yWp95cr4i9zNKU=";
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
          version = "0.17.1";
          sha256 = "sha256-JygJj2oZSOqklwfqMr+zwOYmaDp+3mh+jWMNOx6ccms=";
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
            version = "0.26.6";
            hash = "sha256-83hvz4nqpOxou5tFmiXyuUgWjRnTrOu42R+pRJdNbwU=";
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

      kilocode.kilo-code = callPackage ./kilocode.kilo-code { };

      kravets.vscode-publint = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-publint";
          publisher = "Kravets";
          version = "0.1.0";
          hash = "sha256-GfIbQajdBpC0i8x7YlKYgpBwweWop4OBUU7dIDi9Yvk=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/Kravets.vscode-publint/changelog";
          description = "Lint packaging errors in VS Code with publint";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=Kravets.vscode-publint";
          homepage = "https://github.com/kravetsone/vscode-publint";
          license = lib.licenses.mit;
          maintainers = [ ];
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
          version = "0.2.2";
          hash = "sha256-U1mvxDqyNbTalKgxtCLxLOMT3ZxVGC2KXWW47khtQKA=";
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
          version = "5.3.5";
          hash = "sha256-b5osn7UeSkr8gnLZ/PkrxS0WmgHUwfS0jnwTc1Uw0Sg=";
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

      llvm-vs-code-extensions.lldb-dap = callPackage ./llvm-vs-code-extensions.lldb-dap { };

      llvm-vs-code-extensions.vscode-clangd = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "llvm-vs-code-extensions";
          name = "vscode-clangd";
          version = "0.2.0";
          hash = "sha256-I5cvu+DKtpE0s9IzLl487FnqfGeBsueHY9CTP/o2XyU=";
        };
        meta = {
          description = "C/C++ completion, navigation, and insights";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=llvm-vs-code-extensions.vscode-clangd";
          homepage = "https://github.com/clangd/vscode-clangd";
          changelog = "https://marketplace.visualstudio.com/items/llvm-vs-code-extensions.vscode-clangd/changelog";
          license = lib.licenses.mit;
          maintainers = [ ];
        };
      };

      lokalise.i18n-ally = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "i18n-ally";
          publisher = "Lokalise";
          version = "2.13.1";
          hash = "sha256-Qraxg8FrMnBqbvR6ww3cJPFauY5zqe8P2hANqE1z95c=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ltex-plus.vscode-ltex-plus = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-ltex-plus";
          publisher = "ltex-plus";
          version = "15.5.1";
          hash = "sha256-BzIJ7gsjcMimLYeVxcvdP0fyIEmwCXxTxqil5o+810w=";
        };
        meta = {
          description = "VS Code extension for grammar/spell checking using LanguageTool with support for LaTeX, Markdown, and others";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ltex-plus.vscode-ltex-plus";
          homepage = "https://github.com/ltex-plus/vscode-ltex-plus";
          license = lib.licenses.mpl20;
          maintainers = with lib.maintainers; [ thtrf ];
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
          version = "1.43.0";
          hash = "sha256-IpJCzoYZ+L39HqBts487E00RfVnZhLa9wUYs2FIV9pQ=";
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
          version = "3.3.0";
          hash = "sha256-Z/dhVvmyhyjEM3QUswLA2ExXeFIRzNOUn7Kd6s/C50k=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      marus25.cortex-debug = callPackage ./marus25.cortex-debug { };

      matangover.mypy = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "matangover";
          name = "mypy";
          version = "0.4.2";
          hash = "sha256-T0H2JGr1WgSgXbf3aLvjKK0OOh9O+eg9YLs/ydblb9U=";
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
          version = "0.4.0";
          hash = "sha256-J4O112VM3Ullyy39ZLw9ieBxVCJQ6yBxdiKtvXyOULo=";
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
          version = "2.2.6";
          hash = "sha256-QBUTOFhdksHGkpYqgQIF2u+WodYH5PmMMvGFHwEEEIk=";
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
          version = "3.23.0";
          hash = "sha256-HEbx7vjuVFjAG0koFI/JRehivRiLBF0cgx24LhdwCBc=";
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
          maintainers = [ ];
        };
      };

      mesonbuild.mesonbuild = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "mesonbuild";
          name = "mesonbuild";
          version = "1.27.0";
          hash = "sha256-dEDDw8fDBkRYE09mrOzQNzAhWZEczTTahBZT4nhrClw=";
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
          license = lib.licenses.unfree;
        };
      };

      miguelsolorio.min-theme = callPackage ./miguelsolorio.min-theme { };

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
          version = "0.0.10";
          sha256 = "sha256-mRPWEU/M5uhiDUl9KwQi6w5hfzIZxKMhO48ssVfICoQ=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      mkhl.direnv = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "mkhl";
          name = "direnv";
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

      mkhl.shfmt = callPackage ./mkhl.shfmt { };

      mongodb.mongodb-vscode = callPackage ./mongodb.mongodb-vscode { };

      moshfeu.compare-folders = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "compare-folders";
          publisher = "moshfeu";
          version = "0.25.3";
          hash = "sha256-QrSh8/AycC5nKbZ1+E3V/lJu/7Skket8b05yPnZg68s=";
        };

        meta = {
          changelog = "https://github.com/moshfeu/vscode-compare-folders/releases";
          description = "Extension allows you to compare folders, show the diffs in a list and present diff in a splitted view side by side";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=moshfeu.compare-folders";
          homepage = "https://github.com/moshfeu/vscode-compare-folders";
          license = lib.licenses.mit;
        };
      };

      ms-azuretools.vscode-bicep = callPackage ./ms-azuretools.vscode-bicep { };

      ms-azuretools.vscode-containers = callPackage ./ms-azuretools.vscode-containers { };

      ms-azuretools.vscode-docker = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "ms-azuretools";
          name = "vscode-docker";
          version = "2.0.0";
          hash = "sha256-Yxysekp9nC91g7M5oXppOF+Rf4Jf/PD+X3inmdVfVmo=";
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
          version = "2.3.7";
          hash = "sha256-Pe0rgs1vDbaOO178lB5P/Z+gqmf6LALIIZB3DntkmOc=";
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
                hash = "sha256-pmA7BNwyHiaU93j61/MyrBV5kH0DlW+7BA6HNlKGnso=";
              };
              "x86_64-darwin" = {
                arch = "darwin-x64";
                hash = "sha256-E2KRzjIxLFmwArzEKittjejacrCOFFNNzphWw8v5CpE=";
              };
              "aarch64-linux" = {
                arch = "linux-arm64";
                hash = "sha256-pnQP1OKr3NJgUuXzO1InYqGA49OuMFn2iEf8wpl4PqM=";
              };
              "aarch64-darwin" = {
                arch = "darwin-arm64";
                hash = "sha256-8XIeK5AIFKQaK5YMNSRqxr5p72zXb7ZLPq6PbeWO864=";
              };
            };
          in
          {
            name = "vscodeintellicode-csharp";
            publisher = "ms-dotnettools";
            version = "2.2.3";
          }
          // sources.${stdenv.system} or (throw "Unsupported system: ${stdenv.system}");
        nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
        buildInputs = [
          (lib.getLib stdenv.cc.cc)
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
          version = "1.3.26";
          hash = "sha256-wiRV8FQw9TPNYvsgoVy8nAvCA9eosxXTaXs7YjdoBFs=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ms-pyright.pyright = callPackage ./ms-pyright.pyright { };

      ms-python.black-formatter = callPackage ./ms-python.black-formatter { };

      ms-python.flake8 = callPackage ./ms-python.flake8 { };

      ms-python.isort = callPackage ./ms-python.isort { };

      ms-python.pylint = callPackage ./ms-python.pylint { };

      ms-python.mypy-type-checker = callPackage ./ms-python.mypy-type-checker { };

      ms-python.python = callPackage ./ms-python.python { };

      ms-python.debugpy = callPackage ./ms-python.debugpy { };

      ms-python.vscode-pylance = callPackage ./ms-python.vscode-pylance { };

      ms-toolsai.datawrangler = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "datawrangler";
          publisher = "ms-toolsai";
          version = "1.22.0";
          hash = "sha256-gUlb48g12RW4j2HS9jfpZROgtFM9zEPg4ozLM7hOaLk=";
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
          version = "1.1.2";
          hash = "sha256-9BLyBZzZ0Z6QQ05QSxFJYNZmZDc5O3eYkCxe/UsmKws=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ms-toolsai.jupyter-renderers = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "ms-toolsai";
          name = "jupyter-renderers";
          version = "1.3.0";
          hash = "sha256-GBqHvXikCgLGW7Xm05Iq1xqs8j9H9k9c8iASsAjA87I=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ms-toolsai.vscode-jupyter-cell-tags = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "ms-toolsai";
          name = "vscode-jupyter-cell-tags";
          version = "0.1.9";
          hash = "sha256-XODbFbOr2kBTzFc0JtjiDUcCDBX1Hd4uajlil7mhqPY=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ms-toolsai.vscode-jupyter-slideshow = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "ms-toolsai";
          name = "vscode-jupyter-slideshow";
          version = "0.1.6";
          hash = "sha256-fnsMrrcYdz6BzUWMd9pAOQGTjmtEbQeoVYG20VWxCsM=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ms-vscode.anycode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "anycode";
          publisher = "ms-vscode";
          version = "0.0.74";
          hash = "sha256-rTWAOvIsrl0DSqxoQy5eU6EREJovU1oRMC8/2Q6x4Hk=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ms-vscode.cmake-tools = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "ms-vscode";
          name = "cmake-tools";
          version = "1.21.36";
          hash = "sha256-IqgYnesIz46WmJ7kR8LYnr2kkD33oiupi7CrcV6rGRg=";
        };
        meta.license = lib.licenses.mit;
      };

      ms-vscode.cpptools = callPackage ./ms-vscode.cpptools { };

      ms-vscode.cpptools-extension-pack = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "cpptools-extension-pack";
          publisher = "ms-vscode";
          version = "1.3.1";
          hash = "sha256-HbI0UdN8uwHS2MPH1SGZhxNaN18cWzjMyWYcgVE7FjY=";
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
          publisher = "ms-vscode";
          name = "hexeditor";
          version = "1.11.1";
          hash = "sha256-RB5YOp30tfMEzGyXpOwPIHzXqZlRGc+pXiJ3foego7Y=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ms-vscode.live-server = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "live-server";
          publisher = "ms-vscode";
          version = "0.5.2024091601";
          hash = "sha256-cwntFW5McTAcFs0f+vTlLpZffz3ApYGxu0ctJ2X6EuY=";
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
          publisher = "ms-vscode";
          name = "makefile-tools";
          version = "0.12.17";
          hash = "sha256-chHyYzKNEpyYMQX14pbQ/d9WKC+1QWtm8iKe6M8ZWWI=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ms-vscode.powershell = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "PowerShell";
          publisher = "ms-vscode";
          version = "2025.2.0";
          hash = "sha256-f/qWKuvPGIEGuSugzafCIoYU02b3oRcg7UTL+pEZtVo=";
        };
        meta = {
          description = "Visual Studio Code extension for PowerShell language support";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell";
          homepage = "https://github.com/PowerShell/vscode-powershell";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.rhoriguchi ];
        };
      };

      ms-vscode.remote-explorer = callPackage ./ms-vscode.remote-explorer { };

      ms-vscode.test-adapter-converter = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "test-adapter-converter";
          publisher = "ms-vscode";
          version = "0.2.1";
          hash = "sha256-gyyl379atZLgtabbeo26xspdPjLvNud3cZ6kEmAbAjU=";
        };
        meta = {
          description = "Visual Studio Code extension that converts from the Test Explorer UI API into native VS Code testing";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-vscode.test-adapter-converter";
          homepage = "https://github.com/microsoft/vscode-test-adapter-converter";
          license = lib.licenses.mit;
        };
      };

      ms-vscode-remote.remote-containers = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "remote-containers";
          publisher = "ms-vscode-remote";
          version = "0.427.0";
          hash = "sha256-aSwC8NLJxelv2B+FnF8rmA5pnowugmdF+gnm+A0qSiE=";
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
          version = "0.87.0";
          hash = "sha256-yeX6RAJl07d+SuYyGQFLZNcUzVKAsmPFyTKEn+y3GuM=";
        };
        meta = {
          description = "Visual Studio Code extension that complements the Remote SSH extension with syntax colorization, keyword intellisense, and simple snippets when editing SSH configuration files";
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
          version = "0.104.3";
          hash = "sha256-IlNBcrgJ2qkbJtNOonZGkuJHYL8Ho7EVb2HlbMimxK8=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/ms-vscode-remote.remote-wsl/changelog";
          description = "Windows Subsystem for Linux support for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl";
          homepage = "https://code.visualstudio.com/docs/remote/wsl";
          license = lib.licenses.unfree;
          maintainers = [ ];
        };
      };

      ms-vscode-remote.vscode-remote-extensionpack =
        callPackage ./ms-vscode-remote.vscode-remote-extensionpack
          { };

      ms-vsliveshare.vsliveshare = callPackage ./ms-vsliveshare.vsliveshare { };

      ms-windows-ai-studio.windows-ai-studio = callPackage ./ms-windows-ai-studio.windows-ai-studio { };

      mshr-h.veriloghdl = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "veriloghdl";
          publisher = "mshr-h";
          version = "1.16.1";
          hash = "sha256-GsUNvBUlGZ5gRk6GnAfT0eUKHK+D+cPtdAhuYtxe3w8=";
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
          version = "1.14.3";
          hash = "sha256-AYOX6I1R34HdNNdY9LpLkM/JHm/f1h+Q9HTtEnKMhdU=";
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
          version = "2.14.0";
          hash = "sha256-bjYumipeZM5tNl/cTHLcm/EyX4FU1AzQU3W53e0cGfc=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      myriad-dreamin.tinymist = callPackage ./myriad-dreamin.tinymist { };

      natqe.reload = callPackage ./natqe.reload { };

      naumovs.color-highlight = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "color-highlight";
          publisher = "naumovs";
          version = "2.8.0";
          hash = "sha256-mT2P1lEdW66YkDRN6fi0rmmvvyBfXiJjAUHns8a8ipE=";
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

      ndonfris.fish-lsp = callPackage ./ndonfris.fish-lsp { };

      nefrob.vscode-just-syntax = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-just-syntax";
          publisher = "nefrob";
          version = "0.8.0";
          hash = "sha256-zuDfIxhiUKRpVRxp9BceW6WPBq5NNCuS1Si0/6kfqF8=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/nefrob.vscode-just-syntax/changelog";
          description = "Justfile syntax support for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=nefrob.vscode-just-syntax";
          homepage = "https://github.com/nefrob/vscode-just";
          license = lib.licenses.mit;
          maintainers = [ ];
        };
      };

      nhoizey.gremlins = callPackage ./nhoizey.gremlins { };

      nimlang.nimlang = callPackage ./nimlang.nimlang { };

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
          version = "1.0.8";
          hash = "sha256-GQNv3QWzb0xSnaR8GOnAOZF/wOg0LaWHN3goIYq7JmI=";
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
          version = "1.32.3";
          hash = "sha256-KUzLrt7y3I6szpWVGk0NtBfXncw6ovNAkm1HyHj+MDk=";
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

      oliver-ni.scheme-fmt = callPackage ./oliver-ni.scheme-fmt { };

      oops418.nix-env-picker = callPackage ./oops418.nix-env-picker { };

      ph-hawkins.arc-plus = callPackage ./ph-hawkins.arc-plus { };

      phind.phind = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "phind";
          publisher = "phind";
          version = "0.25.4";
          hash = "sha256-qiUjDPJ35RZA4JYwFpQ//zwh9TKJ4RMtZmIzm3uThC0=";
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
          version = "0.1.3";
          hash = "sha256-UuGqYLz/4lc5WngrRLkAbEXnOW5pvTlDhHO0aB+LRgk=";
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

      pkief.material-icon-theme = callPackage ./pkief.material-icon-theme { };

      pkief.material-product-icons = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "material-product-icons";
          publisher = "PKief";
          version = "1.7.1";
          hash = "sha256-knYRG4j8cU6frLXSpwvaSyE+EWFd1ne/ctYa5kqp5bw=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      platformio.platformio-vscode-ide = callPackage ./platformio.platformio-vscode-ide { };

      pollywoggames.pico8-ls = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "pico8-ls";
          publisher = "PollywogGames";
          version = "0.6.1";
          hash = "sha256-TlULqIKb3R+bvjN3f4Bwha0bewqCHpPVFiePHNV2kmE=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/PollywogGames.pico8-ls/changelog";
          description = "VSCode extension for full language support for the PICO-8 dialect of Lua";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=PollywogGames.pico8-ls";
          homepage = "https://github.com/japhib/pico8-ls";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.dotmobo ];
        };
      };

      prince781.vala = callPackage ./prince781.vala { };

      prisma.prisma = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "prisma";
          publisher = "Prisma";
          version = "6.17.0";
          hash = "sha256-GaIxrtO+vXjQdDgY5BhVrZjIt8L4X03CNYGh34nbB9E=";
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

      pylyzer.pylyzer = callPackage ./pylyzer.pylyzer { };

      pythagoratechnologies.gpt-pilot-vs-code = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "gpt-pilot-vs-code";
          publisher = "PythagoraTechnologies";
          version = "0.2.32";
          hash = "sha256-7wwvx1uvx2sJymCR/VYppyjDTmcF1eGJSvXTiND2fQs=";
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
          version = "23.0.170";
          hash = "sha256-lK50+WXPXHgqryhlsMb+65yoebX0Rh3PNKmlUjfwlOc=";
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
          version = "25.9.0";
          hash = "sha256-Z0oUhqoHfVALG5k1dbSBpJiq0AEjaqeh8yLJ8FjvfcY=";
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
          publisher = "redhat";
          name = "java";
          version = "1.46.0";
          hash = "sha256-i7Nac47aJVdxxRgM8KCCI8zmwTCGxxy0PrejgjOCYXE=";
        };
        buildInputs = [ jdk ];
        meta = {
          description = "Java language support for VS Code via the Eclipse JDT Language Server";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=redhat.java";
          homepage = "https://github.com/redhat-developer/vscode-java";
          changelog = "https://marketplace.visualstudio.com/items/redhat.java/changelog";
          license = lib.licenses.epl20;
          maintainers = [ ];
          broken = lib.versionOlder jdk.version "17";
        };
      };

      redhat.vscode-xml = callPackage ./redhat.vscode-xml { };

      redhat.vscode-yaml = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "redhat";
          name = "vscode-yaml";
          version = "1.19.1";
          hash = "sha256-ZLuGtB7DjIVrcYomcwptwJxGmIjz0Vu1fCFqYb2XLk4=";
        };
        meta = {
          description = "YAML Language Support by Red Hat, with built-in Kubernetes syntax support";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml";
          homepage = "https://github.com/redhat-developer/vscode-yaml";
          license = lib.licenses.mit;
          maintainers = [ ];
        };
      };

      reditorsupport.r = callPackage ./reditorsupport.r { };

      reditorsupport.r-syntax = callPackage ./reditorsupport.r-syntax { };

      release-candidate.vscode-scheme-repl = callPackage ./release-candidate.vscode-scheme-repl { };

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

      rioj7.commandonallfiles = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "commandOnAllFiles";
          publisher = "rioj7";
          version = "0.5.1";
          hash = "sha256-sv42eRZV32KW51KVadzlrScHQ6snNkBDTzAJ8BDtAvU=";
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

      robocorp.robotframework-lsp = callPackage ./robocorp.robotframework-lsp { };

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

      rooveterinaryinc.roo-cline = callPackage ./rooveterinaryinc.roo-cline { };

      RoweWilsonFrederiskHolme.wikitext = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "wikitext";
          publisher = "RoweWilsonFrederiskHolme";
          version = "4.0.2";
          hash = "sha256-M3TurR7EW1485yzn9q6yvBPCyCE9i7Tuhxl46XcBvHQ=";
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

      saoudrizwan.claude-dev = callPackage ./saoudrizwan.claude-dev { };

      sainnhe.gruvbox-material = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "gruvbox-material";
          publisher = "sainnhe";
          version = "6.5.2";
          hash = "sha256-D+SZEQQwjZeuyENOYBJGn8tqS3cJiWbEkmEqhNRY/i4=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/sainnhe.gruvbox-material/changelog";
          description = "Gruvbox Material theme VSCode extension with Material palette";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=sainnhe.gruvbox-material";
          homepage = "https://github.com/sainnhe/gruvbox-material-vscode";
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [ thtrf ];
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

      sas.sas-lsp = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "sas-lsp";
          publisher = "SAS";
          version = "1.17.0";
          hash = "sha256-lhvSAPbvRmNwrAB0Lk4oKVu7+o3H7TJSQbBlURH2SCA=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/SAS.sas-lsp/changelog";
          description = "Official SAS Language Extension";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=SAS.sas-lsp";
          homepage = "https://github.com/sassoftware/vscode-sas-extension";
          license = lib.licenses.asl20;
          maintainers = [ lib.maintainers.scraptux ];
        };
      };

      scala-lang.scala = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "scala";
          publisher = "scala-lang";
          version = "0.5.9";
          hash = "sha256-zgCqKwnP7Fm655FPUkD5GL+/goaplST8507X890Tnhc=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      scalameta.metals = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "metals";
          publisher = "scalameta";
          version = "1.55.0";
          hash = "sha256-HdD8D8oy/VtIhDj+BQNIDx2YhZXX7VsR2+U1WrKIOoc=";
        };
        meta = {
          license = lib.licenses.asl20;
        };
      };

      sdras.night-owl = buildVscodeMarketplaceExtension rec {
        mktplcRef = {
          name = "night-owl";
          publisher = "sdras";
          version = "2.1.1";
          hash = "sha256-mTvnUw/018p/1lJTje9rZ1JJXq4NiaI0d4UnRthnZtg=";
        };
        meta = {
          changelog = "https://github.com/sdras/night-owl-vscode-theme/blob/main/CHANGELOG.md#${
            builtins.replaceStrings [ "." ] [ "" ] mktplcRef.version
          }";
          description = "Visual Studio Code theme named Light Owl for daytime usage";
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
          version = "1.3.0";
          hash = "sha256-vr6UKd+7g6J8XEY57sCqPpLuxNC4KOvf7nddDKaceaU=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/seatonjiang.gitmoji-vscode/changelog";
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
          version = "0.6.7";
          hash = "sha256-FVZxMZ0QpCKLD0vX7LPvBywZgQ4kptjnCW9jCefwgJo=";
        };
        meta = {
          license = lib.licenses.mit;
          maintainers = [ ];
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
          version = "0.8.19";
          hash = "sha256-F87YInLUkPUpB2oifCCq1xWD41LUdqg8cusGw2wEYg0=";
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
          version = "0.9.32";
          hash = "sha256-b8VFojeIkplnr48D8el0HeEtN47al/tgqgq52ozjw9M=";
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
          version = "0.9.2";
          hash = "sha256-qlFD8sMvdKpLkXiYT9UybgCvxUJrbXpAcnmPxk91Tbs=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/signageos.signageos-vscode-sops/changelog";
          description = "Visual Studio Code extension for SOPS support";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=signageos.signageos-vscode-sops";
          homepage = "https://github.com/signageos/vscode-sops";
          license = lib.licenses.mit;
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
          version = "1.0.0";
          hash = "sha256-bS7HnO2avXkSwXmuZ0oe2Sj/q3YYLOV4ldaAak9w9RY=";
        };
        meta = {
          changelog = "https://github.com/smcpeak/vscode-default-keys-windows/blob/master/CHANGELOG.md";
          description = "VSCode extension that provides default Windows keybindings on any platform";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=smcpeak.default-keys-windows";
          homepage = "https://github.com/smcpeak/vscode-default-keys-windows";
          license = lib.licenses.mit;
          maintainers = [ lib.maintainers.ttschnz ];
        };
      };

      sonarsource.sonarlint-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "sonarsource";
          name = "sonarlint-vscode";
          version = "4.31.0";
          hash = "sha256-Zw5Dy6VaMkt2zyEy8wZs2e92hA2j7u+moRSONHCDkgw=";
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
          publisher = "sswg";
          name = "swift-lang";
          version = "1.12.0";
          hash = "sha256-Dzf8mJCDWT2pHPJcTywEqnki8aVsMO92+wLQ4fjHzb8=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/sswg.swift-lang/changelog";
          description = "Swift Language Support for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=sswg.swift-lang";
          homepage = "https://github.com/swiftlang/vscode-swift";
          license = lib.licenses.asl20;
          maintainers = [ ];
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
          version = "1.0.0";
          hash = "sha256-ZV5iyZ8pkTG9RPGObFtGbU5Iq7w/cDlUMuOVskg/39g=";
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
          publisher = "streetsidesoftware";
          name = "code-spell-checker";
          version = "4.2.6";
          hash = "sha256-veP2G/5vcaimjd98ur6Mhl4x1NKuvS21oO+HFJLHN+I=";
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

      streetsidesoftware.code-spell-checker-french =
        callPackage ./streetsidesoftware.code-spell-checker-french
          { };

      streetsidesoftware.code-spell-checker-german =
        callPackage ./streetsidesoftware.code-spell-checker-german
          { };

      styled-components.vscode-styled-components = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-styled-components";
          publisher = "styled-components";
          version = "1.7.8";
          hash = "sha256-VoLAjBcAizTxd+BHwXoNSlSxqXno3PjVxaickLCtnsw=";
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
          version = "1.5.3";
          hash = "sha256-fgMs9/gYhhHCkiKJX5rDRbiXy6gxvmLhU6blNxEoNc8=";
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
          hash = "sha256-/fZungx+wdtKo80KCGZa4WfHMTT6Imb5MBgQ8gAGhfQ=";
          name = "supermaven";
          publisher = "supermaven";
          version = "1.1.12";
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
          version = "109.11.2";
          hash = "sha256-ANeFsYvvOFvoQh59gfMrXRV8l1H8lKjNjjk5byruMno=";
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
          version = "3.320.0";
          hash = "sha256-CFkLAMSMWGSHQwD0diSTn3z+U95Y4uCSnHNMTOj+iAo=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      tailscale.vscode-tailscale = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-tailscale";
          publisher = "tailscale";
          version = "1.1.0";
          sha256 = "sha256-kDvA4Yw+iFoBwHKrmQCwrPZRRSDvDyxTFc1Z1vAJwc0=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/tailscale.vscode-tailscale/changelog";
          description = "VSCode extension to share a port over the internet with Tailscale Funnel";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=Tailscale.vscode-tailscale";
          homepage = "https://github.com/tailscale-dev/vscode-tailscale";
          license = lib.licenses.mit;
          maintainers = [ ];
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
          publisher = "tamasfe";
          name = "even-better-toml";
          version = "0.21.2";
          hash = "sha256-IbjWavQoXu4x4hpEkvkhqzbf/NhZpn8RFdKTAnRlCAg=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      tauri-apps.tauri-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "tauri-vscode";
          publisher = "tauri-apps";
          version = "0.2.9";
          hash = "sha256-ySfsmKAReKTLl6lHax2fnPu9paQ2pBSEMUoeGtGJelA=";
        };
        meta = {
          description = "Enhances the experience of Tauri apps development";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=tauri-apps.tauri-vscode";
          homepage = "https://github.com/tauri-apps/tauri-vscode";
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
          version = "0.2.3";
          hash = "sha256-JEFNYSyGCsmsiJ89R4fWy/cUU6pDW1HA2P1Sr90QJHU=";
        };
        meta = {
          description = "VSCode extension that provides some language features for Yew's html macro syntax";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=TechTheAwesome.rust-yew";
          homepage = "https://github.com/TechTheAwesome/code-yew-server";
          license = lib.licenses.gpl3Only;
          maintainers = [ lib.maintainers.CardboardTurkey ];
        };
      };

      tecosaur.latex-utilities = callPackage ./tecosaur.latex-utilities { };

      tekumara.typos-vscode = callPackage ./tekumara.typos-vscode { };

      teros-technology.teroshdl = callPackage ./teros-technology-teroshdl { };

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
          publisher = "thenuprojectcontributors";
          name = "vscode-nushell-lang";
          version = "1.10.0";
          hash = "sha256-AfClskNZwQIC67VrM8XKxF6nIbXPp576CRmls0WCKwU=";
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
          version = "0.15.0";
          hash = "sha256-Tl0X2jtgTsjf2tvyAJLGxEGrmLXACYWWErcDJuQYg+o=";
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

      tboby.cwtools-vscode = callPackage ./tboby.cwtools-vscode { };

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
          version = "0.19.0";
          hash = "sha256-jRwZD4TwLMdwBdV59HonMkF2ds4heXHPtpw1sxq1RsA=";
        };
        meta = {
          changelog = "https://github.com/open-policy-agent/vscode-opa/blob/master/CHANGELOG.md";
          description = "Extension for VS Code which provides support for OPA";
          homepage = "https://github.com/open-policy-agent/vscode-opa";
          license = lib.licenses.asl20;
          maintainers = [ lib.maintainers.msanft ];
        };
      };

      tsyesika.guile-scheme-enhanced = callPackage ./tsyesika.guile-scheme-enhanced { };

      tuttieee.emacs-mcx = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "emacs-mcx";
          publisher = "tuttieee";
          version = "0.91.0";
          hash = "sha256-nvcISWilvPXIm/er3QnM2aOhrWn2BgOL0aXpGHpDw9M=";
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
          version = "0.0.7";
          hash = "sha256-M7uowipFpEVqY6foLbOLMB0AI+DrXj/h25+EceiwlMw=";
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
          publisher = "twxs";
          name = "cmake";
          version = "0.0.17";
          hash = "sha256-CFiva1AO/oHpszbpd7lLtDzbv1Yi55yQOQPP/kCTH4Y=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      tyriar.sort-lines = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "sort-lines";
          publisher = "Tyriar";
          version = "1.12.0";
          hash = "sha256-/uzwBLQMmp5zuoE0fWG2m7Ix8k33LQG2uaF0NVQt7sk=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ufo5260987423.magic-scheme = callPackage ./ufo5260987423.magic-scheme { };

      uiua-lang.uiua-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "uiua-vscode";
          publisher = "uiua-lang";
          version = "0.0.66";
          hash = "sha256-eFdRzkoYJeQdpebKcSFhhnZZXFcA3oKURvqjBx5hReQ=";
        };
        meta = {
          description = "VSCode language extension for Uiua";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=uiua-lang.uiua-vscode";
          homepage = "https://github.com/uiua-lang/uiua-vscode";
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [
            tomasajt
            defelo
          ];
        };
      };

      uloco.theme-bluloco-light = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "theme-bluloco-light";
          publisher = "uloco";
          version = "3.7.5";
          sha256 = "sha256-MDrw0JWioLyg+H0XOCpULsmtM/y7RfV9ruDtskRiT3A=";
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
          version = "1.8.17";
          hash = "sha256-DTbgGVBnT6t++AFq08QmWNCKbbjvNPXMKoHgSL+UzyE=";
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
          version = "3.26.0";
          hash = "sha256-pAkk3QURnlLNMZ2cFBks2lAEl/Hk8Z2i/QgvjUv+u2Y=";
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

      vadimcn.vscode-lldb = callPackage ./vadimcn.vscode-lldb { };

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

      visualjj.visualjj = callPackage ./visualjj.visualjj { };

      visualstudioexptteam.intellicode-api-usage-examples = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "intellicode-api-usage-examples";
          publisher = "VisualStudioExptTeam";
          version = "0.2.9";
          hash = "sha256-8xBD+WLBaxYt8v3+8lvV2SiqV89iE4jeQod2kH7LNHU=";
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
          version = "1.3.2";
          hash = "sha256-2zexyX1YKD5jgtsvDx7/z3luh5We71ys+XRlVcNywfs=";
        };
        meta = {
          description = "AI-assisted development";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=VisualStudioExptTeam.vscodeintellicode";
          homepage = "https://github.com/MicrosoftDocs/intellicode";
          license = lib.licenses.cc-by-40;
          maintainers = [ lib.maintainers.themaxmur ];
        };
      };

      visualstudiotoolsforunity.vstuc = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vstuc";
          publisher = "VisualStudioToolsForUnity";
          version = "1.1.3";
          hash = "sha256-MQ7XW45NFhpx0kH3+O3nWXGKUzE9z+axYYQs7rER9ns=";
        };
        meta = {
          description = "Integrates Visual Studio Code for Unity";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=visualstudiotoolsforunity.vstuc";
          homepage = "https://github.com/MicrosoftDocs/vscode-dotnettools";
          license = lib.licenses.unfree;
          maintainers = [ lib.maintainers.mib ];
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
          maintainers = [ ];
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

      vscjava.vscode-gradle = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-gradle";
          publisher = "vscjava";
          version = "3.17.0";
          hash = "sha256-SZRSSgi4/8cEHGvhoGf9J8hrSIQWn1sFTh4NSsJcMDg=";
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
          publisher = "vscjava";
          name = "vscode-java-debug";
          version = "0.58.2025022807";
          hash = "sha256-8bzDbCF03U5P15tkVkieOGuuLetUFXjZNrQKZTcKNFA=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vscjava.vscode-java-dependency = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "vscjava";
          name = "vscode-java-dependency";
          version = "0.25.2025092303";
          hash = "sha256-GU33NuhgNZdTFGkRQ6aJHs9nbvoOuJlf323mYf6TPOs=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vscjava.vscode-java-test = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "vscjava";
          name = "vscode-java-test";
          version = "0.43.1";
          hash = "sha256-yiKBG1A5ahvB6iTqh2yzFzcKJlU1lu4dqd+4cygWVQ4=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vscjava.vscode-java-pack = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-java-pack";
          publisher = "vscjava";
          version = "0.30.2";
          hash = "sha256-uC3hf2OjncMqTRc9KTfrVvTwZOoPT0QXX7HCBTdblnQ=";
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
          publisher = "vscjava";
          name = "vscode-maven";
          version = "0.44.2024072906";
          hash = "sha256-9S8Zzefg9i3nZiPZAtW5aT07dpZnhV0w9DP5vdnEtFc=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vscjava.vscode-spring-initializr = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-spring-initializr";
          publisher = "vscjava";
          version = "0.11.2024112703";
          hash = "sha256-5GLgU3hqfsBCmv0ltWcxWrQIyR0rjh7aiixXFQEzV/s=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vscode-icons-team.vscode-icons = callPackage ./vscode-icons-team.vscode-icons { };

      vscodevim.vim = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vim";
          publisher = "vscodevim";
          version = "1.31.0";
          hash = "sha256-97dQeCFm2i5uRF45k1tVMWiXNh5xBw3MVYM8MSIeDFE=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vspacecode.vspacecode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vspacecode";
          publisher = "VSpaceCode";
          version = "0.10.20";
          hash = "sha256-UlEuCvsGgtKl1IaRuMn5ODm4NDe8NTbaMN8c476Z0g0=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vue.volar = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "volar";
          publisher = "Vue";
          version = "3.1.1";
          hash = "sha256-l5x7fLznJGm2dPAbJlz4/5BDikM45h1W9GkmoC4Sv7k=";
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
          version = "0.11.4";
          hash = "sha256-mgvI/8Y3naw3Zmud73UYcAEKz6B0Q4tf+0uL3UWcAD0=";
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

      vytautassurvila.csharp-ls = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "csharp-ls";
          publisher = "vytautassurvila";
          version = "0.0.27";
          hash = "sha256-kl6W1UQ36cNQNj3cOsMyZbxD6glaRm3W0Z1W+xuEcjs=";
        };
        meta = {
          changelog = "https://github.com/vytautassurvila/vscode-csharp-ls/blob/master/CHANGELOG.md";
          description = "Visual Studio Code Extension - C# LSP client for csharp-language-server";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=vytautassurvila.csharp-ls";
          homepage = "https://github.com/vytautassurvila/vscode-csharp-ls";
          license = lib.licenses.mit;
        };
      };

      waderyan.gitblame = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "gitblame";
          publisher = "waderyan";
          version = "11.2.0";
          sha256 = "sha256-NEsw5Z0k6AYpDcz6pVl2p0Zayd4qC1VODlcaVEOVoHg=";
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

      wgsl-analyzer.wgsl-analyzer = callPackage ./wgsl-analyzer.wgsl-analyzer { };

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

      woberg.godot-dotnet-tools = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "woberg";
          name = "godot-dotnet-tools";
          version = "0.5.1";
          hash = "sha256-qZdQiW1RvzUR5+5QlVdMPBY82IOPUPs3GNOl6bOhnWM=";
        };
        meta = {
          description = "VSCode extension for Godot 4 Mono supporting C# language";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=woberg.godot-dotnet-tools";
          homepage = "https://github.com/williamoberg/godot-dotnet-tools";
          license = lib.licenses.mit;
          # For instructions on configuring this extension see:
          # https://wiki.nixos.org/wiki/Godot-Mono
        };
      };

      xadillax.viml = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "viml";
          publisher = "xadillax";
          version = "2.2.0";
          hash = "sha256-WNwTWJ3fDdIc9gsfOdtAd6Rg3xH0sbs6ONo7fKjtJuI=";
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
          version = "1.37.0";
          hash = "sha256-7Dz8i66tWPStk2fgFdZPY2Jz3j4IquJVyQbSnV+SVpk=";
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
          version = "0.6.1";
          hash = "sha256-LvX21nEjgayNd9q+uXkahmdYwzfWBZOhQaF+clFUUF4=";
        };
        meta = {
          description = "Make TypeScript errors prettier and human-readable in VSCode";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=yoavbls.pretty-ts-errors";
          homepage = "https://github.com/yoavbls/pretty-ts-errors";
          license = lib.licenses.mit;
          maintainers = [ ];
        };
      };

      yy0931.vscode-sqlite3-editor = callPackage ./yy0931.vscode-sqlite3-editor { };

      yzane.markdown-pdf = callPackage ./yzane.markdown-pdf { };

      yzhang.dictionary-completion = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "yzhang";
          name = "dictionary-completion";
          version = "1.3.1";
          hash = "sha256-sin2kTx7aXFPhtraKUjsowuV8Z2z237RIePL4F/JiPM=";
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
          version = "3.6.3";
          sha256 = "sha256-xJhbFQSX1DDDp8iE/R8ep+1t5IRusBkvjHcNmvjrboM=";
        };
        meta = {
          description = "All you need to write Markdown (keyboard shortcuts, table of contents, auto preview and more)";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one";
          homepage = "https://github.com/yzhang-gh/vscode-markdown";
          license = lib.licenses.mit;
          maintainers = [ ];
        };
      };

      zaaack.markdown-editor = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "markdown-editor";
          publisher = "zaaack";
          version = "0.1.13";
          hash = "sha256-Si8/piNNktcyRY8o8o9my9sP9NEwrNuySVjlyadDjtU=";
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
          version = "0.3.7";
          hash = "sha256-zBMsEovKBFl5LTcYWMHMep1D/4vP8jba3mFRZZP41RU=";
        };
        meta = {
          description = "Tabler product icon theme for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=zguolee.tabler-icons";
          homepage = "https://github.com/zguolee/vscode-tabler-icons";
          license = lib.licenses.mit;
          maintainers = [ ];
        };
      };

      zhuangtongfa.material-theme = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "material-theme";
          publisher = "zhuangtongfa";
          version = "3.19.0";
          sha256 = "sha256-K0eXeAEn4s3YZHJJU9jxtytNQTgaGwvd3fBUsZiKfPw=";
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
          version = "0.6.14";
          hash = "sha256-Bp0WdHTew+AZVtlHY/BBngtWJ9F4MjPx5tcR4HgXBio=";
        };
        meta = {
          changelog = "https://marketplace.visualstudio.com/items/ziglang.vscode-zig/changelog";
          description = "Zig support for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ziglang.vscode-zig";
          homepage = "https://github.com/ziglang/vscode-zig";
          license = lib.licenses.mit;
          maintainers = [ ];
        };
      };

      zxh404.vscode-proto3 = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-proto3";
          publisher = "zxh404";
          version = "0.5.5";
          sha256 = "sha256-Em+w3FyJLXrpVAe9N7zsHRoMcpvl+psmG1new7nA8iE=";
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
    dendron.dendron-markdown-preview-enhanced = throw "dendron.dendron-markdown-preview-enhanced has been removed from the VSCode marketplace."; # Added 2025-08-21
    equinusocio.vsc-material-theme = throw "'equinusocio.vsc-material-theme' has been removed due to security concerns. The extension contained potentially malicious code and was taken down."; # Added 2025-02-28
    equinusocio.vsc-material-theme-icons = throw "'equinusocio.vsc-material-theme-icons' has been removed due to security concerns. The extension contained potentially malicious code and was taken down."; # Added 2025-02-28
    jakebecker.elixir-ls = throw "jakebecker.elixir-ls is deprecated in favor of elixir-lsp.vscode-elixir-ls"; # Added 2024-05-29
    jpoissonnier.vscode-styled-components = throw "jpoissonnier.vscode-styled-components is deprecated in favor of styled-components.vscode-styled-components"; # Added 2024-05-29
    matklad.rust-analyzer = throw "matklad.rust-analyzer is deprecated in favor of rust-lang.rust-analyzer"; # Added 2024-05-29
    mgt19937.typst-preview = throw "The features of 'typst-preview' have been consolidated to 'tinymist', an all-in-one language server for typst"; # Added 2024-07-07
    ms-vscode.go = throw "ms-vscode.go is deprecated in favor of golang.go"; # Added 2024-05-29
    ms-vscode.PowerShell = throw "ms-vscode.PowerShell is deprecated in favor of super.ms-vscode.powershell"; # Added 2024-05-29
    ms-vscode.theme-tomorrowkit = throw "ms-vscode.theme-tomorrowkit is deprecated"; # Added 2025-08-30
    richie5um2.snake-trail = throw "richie5um2.snake-trail is deprecated"; # Added 2025-09-04
    rioj7.commandOnAllFiles = throw "rioj7.commandOnAllFiles is deprecated in favor of rioj7.commandonallfiles"; # Added 2024-05-29
    WakaTime.vscode-wakatime = throw "WakaTime.vscode-wakatime is deprecated in favor of wakatime.vscode-wakatime"; # Added 2024-05-29
  };

  # TODO: add overrides overlay, so that we can have a generated.nix
  # then apply extension specific modifications to packages.

  # overlays will be applied left to right, overrides should come after aliases.
  overlays = lib.optionals config.allowAliases [
    (self: super: lib.recursiveUpdate super (aliases super))
  ];

  toFix = lib.foldl' (lib.flip lib.extends) baseExtensions overlays;
in
lib.fix toFix
