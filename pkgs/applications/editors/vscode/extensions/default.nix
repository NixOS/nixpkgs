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
}:

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;

  #
  # Unless there is a good reason not to, we attempt to use the same name as the
  # extension's unique identifier (the name the extension gets when installed
  # from vscode under `~/.vscode`) and found on the marketplace extension page.
  # So an extension's attribute name should be of the form:
  # "${mktplcRef.publisher}.${mktplcRef.name}".
  #
  baseExtensions = self: lib.mapAttrs (_n: lib.recurseIntoAttrs)
    {
      _1Password.op-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "1Password";
          name = "op-vscode";
          version = "1.0.1";
          sha256 = "sha256-0SsHf1zZgmrb7oIsRU6Xpa3AvR8bSfANz5ZlRogjiS0=";
        };
        meta = with lib; {
          changelog = "https://github.com/1Password/op-vscode/releases";
          description = "A VSCode extension that integrates your development workflow with 1Password service";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=1Password.op-vscode";
          homepage = "https://github.com/1Password/op-vscode";
          license = licenses.mit;
          maintainers = with maintainers; [ _2gn ];
        };
      };

      _2gua.rainbow-brackets = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "2gua";
          name = "rainbow-brackets";
          version = "0.0.6";
          sha256 = "TVBvF/5KQVvWX1uHwZDlmvwGjOO5/lXbgVzB26U8rNQ=";
        };
        meta = with lib; {
          description = "A Visual Studio Code extension providing rainbow brackets";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=2gua.rainbow-brackets";
          homepage = "https://github.com/lcultx/rainbow-brackets";
          license = licenses.mit;
          maintainers = with maintainers; [ CompEng0001 ];
        };
      };

      _4ops.terraform = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "4ops";
          name = "terraform";
          version = "0.2.1";
          sha256 = "196026a89pizj8p0hqdgkyllj2spx2qwpynsaqjq17s8v15vk5dg";
        };
        meta = {
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [ kamadorueda ];
        };
      };

      a5huynh.vscode-ron = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-ron";
          publisher = "a5huynh";
          version = "0.9.0";
          sha256 = "0d3p50mhqp550fmj662d3xklj14gvzvhszm2hlqvx4h28v222z97";
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

      alefragnani.bookmarks = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "bookmarks";
          publisher = "alefragnani";
          version = "13.0.1";
          sha256 = "sha256-4IZCPNk7uBqPw/FKT5ypU2QxadQzYfwbGxxT/bUnKdE=";
        };
        meta = {
          license = lib.licenses.gpl3;
        };
      };

      alefragnani.project-manager = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "project-manager";
          publisher = "alefragnani";
          version = "12.1.0";
          sha256 = "sha256-fYBKmWn9pJh2V0fGdqVrXj9zIl8oTrZcBycDaMOXL/8=";
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
          version = "13.3.4";
          sha256 = "sha256-odFh4Ms60tW+JOEbzzglgKe7BL1ccv3TKGir5NlvIrQ=";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/Angular.ng-template/changelog";
          description = "Editor services for Angular templates";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=Angular.ng-template";
          homepage = "https://github.com/angular/vscode-ng-language-service";
          license = licenses.mit;
          maintainers = with maintainers; [ ratsclub ];
        };
      };

      antfu = {
        icons-carbon = buildVscodeMarketplaceExtension {
          mktplcRef = {
            name = "icons-carbon";
            publisher = "antfu";
            version = "0.2.2";
            sha256 = "0mfap16la09mn0jhvy8s3dainrmjz64vra7d0d4fbcpgg420kv3f";
          };
          meta = with lib; {
            license = licenses.mit;
          };
        };

        slidev = buildVscodeMarketplaceExtension {
          mktplcRef = {
            publisher = "antfu";
            name = "slidev";
            version = "0.3.3";
            sha256 = "0pqiwcvn5c8kwqlmz4ribwwra69gbiqvz41ig4fh29hkyh078rfk";
          };
          meta = with lib; {
            license = licenses.mit;
          };
        };
      };

      antyos.openscad = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "openscad";
          publisher = "Antyos";
          version = "1.1.1";
          sha256 = "1adcw9jj3npk3l6lnlfgji2l529c4s5xp9jl748r9naiy3w3dpjv";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/Antyos.openscad/changelog";
          description = "OpenSCAD highlighting, snippets, and more for VSCode";
          homepage = "https://github.com/Antyos/vscode-openscad";
          license = licenses.gpl3;
        };
      };

      apollographql.vscode-apollo = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-apollo";
          publisher = "apollographql";
          version = "1.19.11";
          sha256 = "sha256-EixefDuJiw/p5yAR/UQLK1a1RXJLXlTmOlD34qpAN+U=";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/apollographql.vscode-apollo/changelog";
          description = "Rich editor support for GraphQL client and server development that seamlessly integrates with the Apollo platform";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=apollographql.vscode-apollo";
          homepage = "https://github.com/apollographql/vscode-graphql";
          license = licenses.mit;
          maintainers = with maintainers; [ datafoo ];
        };
      };

      arcticicestudio.nord-visual-studio-code = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "nord-visual-studio-code";
          publisher = "arcticicestudio";
          version = "0.19.0";
          sha256 = "sha256-awbqFv6YuYI0tzM/QbHRTUl4B2vNUdy52F4nPmv+dRU=";
        };
        meta = with lib; {
          description = "An arctic, north-bluish clean and elegant Visual Studio Code theme.";
          downloadPage =
            "https://marketplace.visualstudio.com/items?itemName=arcticicestudio.nord-visual-studio-code";
          homepage = "https://github.com/arcticicestudio/nord-visual-studio-code";
          license = licenses.mit;
          maintainers = with maintainers; [ imgabe ];
        };
      };

      Arjun.swagger-viewer = buildVscodeMarketplaceExtension {
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

        meta = with lib; {
          license = licenses.mit;
        };
      };

      astro-build.astro-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "astro-vscode";
          publisher = "astro-build";
          version = "0.29.1";
          sha256 = "sha256-fMeEeYCZuORhZRds0A8HjHPncK0+SQbV0+f/zU5AIg4=";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/astro-build.astro-vscode/changelog";
          description = "Astro language support for VSCode";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=astro-build.astro-vscode";
          homepage = "https://github.com/withastro/language-tools";
          license = licenses.mit;
          maintainers = with maintainers; [ wackbyte ];
        };
      };

      asvetliakov.vscode-neovim = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-neovim";
          publisher = "asvetliakov";
          version = "0.0.89";
          sha256 = "sha256-4cCaMw7joaXeq+dk5cPZz6/zXDlxWeP/3IjkgSmmRvs=";
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
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/attilabuti.brainfuck-syntax/changelog";
          description = "VSCode extension providing syntax highlighting support for Brainfuck";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=attilabuti.brainfuck-syntax";
          homepage = "https://github.com/attilabuti/brainfuck-syntax";
          license = licenses.mit;
          maintainers = with maintainers; [  ];
        };
      };

      azdavis.millet = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "Millet";
          publisher = "azdavis";
          version = "0.3.5";
          sha256 = "sha256-lQ7EMs6nsTEgP9BESMpyoZG7QVOe7DXzfg/iZr1+DCQ=";
        };
        nativeBuildInputs = [ jq moreutils ];
        postInstall = ''
          cd "$out/$installPrefix"
          jq '.contributes.configuration.properties."millet.server.path".default = "${millet}/bin/lang-srv"' package.json | sponge package.json
        '';
        meta = with lib; {
          description = "Standard ML support for VS Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=azdavis.millet";
          license = licenses.mit;
          maintainers = with maintainers; [ smasher164 ];
        };
      };

      dart-code.flutter = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "flutter";
          publisher = "dart-code";
          version = "3.50.0";
          sha256 = "sha256-2Mi0BWXfO73BBIZIRJMaQyml+jXBI9d7By+vx9Rg+pE=";
        };

        meta.license = lib.licenses.mit;
      };

      dart-code.dart-code = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "dart-code";
          publisher = "dart-code";
          version = "3.50.0";
          sha256 = "sha256-vdECvW4BfuT3H6GD2cH7lVW0f5591pKjXsWyJzzpHYA=";
        };

        meta.license = lib.licenses.mit;
      };

      ms-python.vscode-pylance = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-pylance";
          publisher = "MS-python";
          version = "2022.7.11";
          sha256 = "sha256-JatjLZXO7iwpBwjL1hrNafBiF81CaozWWANyRm8A36Y=";
        };

        buildInputs = [ nodePackages.pyright ];

        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/ms-python.vscode-pylance/changelog";
          description = "A performant, feature-rich language server for Python in VS Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance";
          homepage = "https://github.com/microsoft/pylance-release";
          license = licenses.unfree;
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
        meta = with lib; {
          license = licenses.mit;
        };
      };

      baccata.scaladex-search = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "scaladex-search";
          publisher = "baccata";
          version = "0.2.0";
          sha256 = "0xbikwlrascmn9nzyl4fxb2ql1dczd00ragp30a3yv8bax173bnz";
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
        meta = with lib; {
          description = "VSCode Extension Formatter for OCaml language";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=badochov.ocaml-formatter";
          homepage = "https://github.com/badochov/ocamlformatter-vscode";
          license = licenses.mit;
          maintainers = with maintainers; [  ];
        };
      };

      bbenoist.nix = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "Nix";
          publisher = "bbenoist";
          version = "1.0.1";
          sha256 = "0zd0n9f5z1f0ckzfjr38xw2zzmcxg1gjrava7yahg5cvdcw6l35b";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      benfradet.vscode-unison = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-unison";
          publisher = "benfradet";
          version = "0.3.0";
          sha256 = "1x80s8l8djchg17553aiwaf4b49hf6awiayk49wyii0i26hlpjk1";
        };
        meta = with lib; {
          license = licenses.asl20;
        };
      };

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

      bodil.file-browser = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "file-browser";
          publisher = "bodil";
          version = "0.2.10";
          sha256 = "sha256-RW4vm0Hum9AeN4Rq7MSJOIHnALU0L1tBLKjaRLA2hL8=";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      bierner.emojisense = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "emojisense";
          publisher = "bierner";
          version = "0.9.0";
          sha256 = "0gpcpwh57lqlynsrkv3smykndb46xjh7r85lb291wdklq5ahmb2j";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      bierner.markdown-checkbox = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "markdown-checkbox";
          publisher = "bierner";
          version = "0.3.1";
          sha256 = "0x57dnr6ksqxi28g1c392k04vxy0vdni9nl4xps3i5zh0pyxizhw";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      bierner.markdown-emoji = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "markdown-emoji";
          publisher = "bierner";
          version = "0.2.1";
          sha256 = "1lcg2b39jydl40wcfrbgshl2i1r58k92c7dipz0hl1fa1v23vj4v";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      bierner.markdown-mermaid = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "markdown-mermaid";
          publisher = "bierner";
          version = "1.14.2";
          sha256 = "RZyAY2d3imnLhm1mLur+wTx/quxrNWYR9PCjC+co1FE=";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      bmalehorn.vscode-fish = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-fish";
          publisher = "bmalehorn";
          version = "1.0.31";
          sha256 = "sha256-jDWW43ozUPIzhK/qQ+a+JSNdDHrjvgosyGe8kzBX6xM=";
        };
        meta.license = lib.licenses.mit;
      };

      bradlc.vscode-tailwindcss = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-tailwindcss";
          publisher = "bradlc";
          version = "0.8.6";
          sha256 = "sha256-v15KuD3eYFCsrworCJ1SZAMkyZKztAwWKmfwmbirleI=";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      brettm12345.nixfmt-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "nixfmt-vscode";
          publisher = "brettm12345";
          version = "0.0.1";
          sha256 = "07w35c69vk1l6vipnq3qfack36qcszqxn8j3v332bl0w6m02aa7k";
        };
        meta = with lib; {
          license = licenses.mpl20;
        };
      };

      bungcip.better-toml = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "better-toml";
          publisher = "bungcip";
          version = "0.3.2";
          sha256 = "sha256-g+LfgjAnSuSj/nSmlPdB0t29kqTmegZB5B1cYzP8kCI=";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/bungcip.better-toml/changelog";
          description = "Better TOML Language support";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=bungcip.better-toml";
          homepage = "https://github.com/bungcip/better-toml/blob/master/README.md";
          license = licenses.mit;
          maintainers = with maintainers; [ datafoo ];
        };
      };

      bmewburn.vscode-intelephense-client = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-intelephense-client";
          publisher = "bmewburn";
          version = "1.8.2";
          sha256 = "OvWdDQfhprQNve017pNSksMuCK3Ccaar5Ko5Oegdiuo=";
        };
        meta = with lib; {
          description = "PHP code intelligence for Visual Studio Code";
          license = licenses.mit;
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=bmewburn.vscode-intelephense-client";
          maintainers = with maintainers; [ drupol ];
        };
      };

      catppuccin.catppuccin-vsc = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "catppuccin-vsc";
          publisher = "catppuccin";
          version = "2.2.1";
          sha256 = "sha256-vS+hz3RxG71F5QoO4LQOgOgFh6GQ8QX/+4mMD0KC1kA=";
        };
        meta = with lib; {
          description = "Soothing pastel theme for VSCode";
          license = licenses.mit;
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=Catppuccin.catppuccin-vsc";
          maintainers = with maintainers; [ nullx76 ];
        };
      };

      chenglou92.rescript-vscode = callPackage ./rescript { };

      christian-kohler.path-intellisense = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "path-intellisense";
          publisher = "christian-kohler";
          version = "2.8.1";
          sha256 = "sha256-lTKzMphkGgOG2XWqz3TW2G9sISBc/kG7oXqcIH8l+Mg=";
        };
        meta = with lib; {
          description = "Visual Studio Code plugin that autocompletes filenames";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=christian-kohler.path-intellisense";
          homepage = "https://github.com/ChristianKohler/PathIntellisense";
          license = licenses.mit;
          maintainers = with maintainers; [ imgabe  ];
        };
      };

      cmschuetz12.wal = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "wal";
          publisher = "cmschuetz12";
          version = "0.1.0";
          sha256 = "0q089jnzqzhjfnv0vlb5kf747s3mgz64r7q3zscl66zb2pz5q4zd";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      codezombiech.gitignore = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "gitignore";
          publisher = "codezombiech";
          version = "0.7.0";
          sha256 = "0fm4sxx1cb679vn4v85dw8dfp5x0p74m9p2b56gqkvdap0f2q351";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      coenraads.bracket-pair-colorizer = buildVscodeMarketplaceExtension {
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/CoenraadS.bracket-pair-colorizer/changelog";
          description = "A customizable extension for colorizing matching brackets";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=CoenraadS.bracket-pair-colorizer";
          homepage = "https://github.com/CoenraadS/BracketPair";
          license = licenses.mit;
          maintainers = with maintainers; [ ];
        };
        mktplcRef = {
          name = "bracket-pair-colorizer";
          publisher = "CoenraadS";
          version = "1.0.61";
          sha256 = "0r3bfp8kvhf9zpbiil7acx7zain26grk133f0r0syxqgml12i652";
        };
      };

      coenraads.bracket-pair-colorizer-2 = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "bracket-pair-colorizer-2";
          publisher = "CoenraadS";
          version = "0.2.2";
          sha256 = "0zcbs7h801agfs2cggk1cz8m8j0i2ypmgznkgw17lcx3zisll9ad";
        };
        meta = with lib; {
          license = licenses.mit;
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
          maintainers = with lib.maintainers; [ kamadorueda ];
        };
      };

      cweijan.vscode-database-client2 = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-database-client2";
          publisher = "cweijan";
          version = "4.3.3";
          sha256 = "06bj23y5rbpz0lw45p1sxssalgn19iqfqbijw2ym22grm0i9hcby";
        };
        meta = {
          description = "Database Client For Visual Studio Code";
          homepage = "https://marketplace.visualstudio.com/items?itemName=cweijan.vscode-mysql-client2";
          license = lib.licenses.mit;
        };
      };

      dbaeumer.vscode-eslint = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-eslint";
          publisher = "dbaeumer";
          version = "2.2.6";
          sha256 = "sha256-1yZeyLrXuubhKzobWcd00F/CdU824uJDTkB6qlHkJlQ=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      daohong-emilio.yash = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "daohong-emilio";
          name = "yash";
          version = "0.2.8";
          sha256 = "ummOEBSXUI78hBb1AUh+x339T7ocB/evOVaz79geHRM=";
        };
        meta = {
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [ kamadorueda ];
        };
      };

      davidanson.vscode-markdownlint = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-markdownlint";
          publisher = "DavidAnson";
          version = "0.48.1";
          sha256 = "sha256-3TpZGvas+pfabHayaA6Yd9nOO2MbfXbCvCiTcbja9Vo=";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/DavidAnson.vscode-markdownlint/changelog";
          description = "Markdown linting and style checking for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=DavidAnson.vscode-markdownlint";
          homepage = "https://github.com/DavidAnson/vscode-markdownlint";
          license = licenses.mit;
          maintainers = with maintainers; [ datafoo ];
        };
      };

      davidlday.languagetool-linter = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "languagetool-linter";
          publisher = "davidlday";
          version = "0.19.0";
          sha256 = "sha256-crq6CTXpzwHJL8FPIBneAGjDgUUNdpBt6rIaMCr1F1U=";
        };
        meta = with lib; {
          description = "LanguageTool integration for VS Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=davidlday.languagetool-linter";
          homepage = "https://github.com/davidlday/vscode-languagetool-linter";
          license = licenses.asl20;
          maintainers = with maintainers; [ ebbertd ];
        };
      };

      denoland.vscode-deno = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-deno";
          publisher = "denoland";
          version = "3.12.0";
          sha256 = "sha256-ZsHCWQtEQKkdZ3uk072ZBfHFRzk4Owf4h7+szHLgIeo=";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/denoland.vscode-deno/changelog";
          description = "A language server client for Deno";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=denoland.vscode-deno";
          homepage = "https://github.com/denoland/vscode_deno";
          license = licenses.mit;
          maintainers = with maintainers; [ ratsclub ];
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
          version = "0.0.2";
          sha256 = "0rdh7b5s7ynsyfrq1r1170g65q9vvvfl3qbfvbh1b38ndvj2f0yq";
        };
        meta = { license = lib.licenses.asl20; };
      };

      divyanshuagrawal.competitive-programming-helper = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "competitive-programming-helper";
          publisher = "DivyanshuAgrawal";
          version = "5.8.5";
          sha256 = "25v2tdAX7fVl2B5nvOIKN9vP1G5rA0G67CiDQn9n9Uc=";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/DivyanshuAgrawal.competitive-programming-helper/changelog";
          description = "Makes judging, compiling, and downloading problems for competitve programming easy. Also supports auto-submit for a few sites.";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=DivyanshuAgrawal.competitive-programming-helper";
          homepage = "https://github.com/agrawal-d/cph";
          license = licenses.gpl3;
          maintainers = with maintainers; [ arcticlimer ];
        };
      };

      donjayamanne.githistory = buildVscodeMarketplaceExtension {
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/donjayamanne.githistory/changelog";
          description = "View git log, file history, compare branches or commits";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=donjayamanne.githistory";
          homepage = "https://github.com/DonJayamanne/gitHistoryVSCode/";
          license = licenses.mit;
          maintainers = with maintainers; [ ];
        };
        mktplcRef = {
          name = "githistory";
          publisher = "donjayamanne";
          version = "0.6.19";
          sha256 = "15s2mva9hg2pw499g890v3jycncdps2dmmrmrkj3rns8fkhjn8b3";
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
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/dracula-theme.theme-dracula/changelog";
          description = "Dark theme for many editors, shells, and more";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=dracula-theme.theme-dracula";
          homepage = "https://draculatheme.com/";
          license = licenses.mit;
        };
      };

      eamodio.gitlens = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "gitlens";
          publisher = "eamodio";
          version = "2022.12.604";
          sha256 = "sha256-yfqGITviASp5ZDEJA+zyVz1LpPWV4FM/4fU4eq52Xng=";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/eamodio.gitlens/changelog";
          description = "GitLens supercharges the Git capabilities built into Visual Studio Code.";
          longDescription = ''
            Supercharge the Git capabilities built into Visual Studio Code — Visualize code authorship at a glance via Git
            blame annotations and code lens, seamlessly navigate and explore Git repositories, gain valuable insights via
            powerful comparison commands, and so much more
          '';
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens";
          homepage = "https://gitlens.amod.io/";
          license = licenses.mit;
          maintainers = with maintainers; [ ratsclub ];
        };
      };

      editorconfig.editorconfig = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "EditorConfig";
          publisher = "EditorConfig";
          version = "0.16.4";
          sha256 = "0fa4h9hk1xq6j3zfxvf483sbb4bd17fjl5cdm3rll7z9kaigdqwg";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/EditorConfig.EditorConfig/changelog";
          description = "EditorConfig Support for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig";
          homepage = "https://github.com/editorconfig/editorconfig-vscode";
          license = licenses.mit;
          maintainers = with maintainers; [ dbirks ];
        };
      };

      edonet.vscode-command-runner = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-command-runner";
          publisher = "edonet";
          version = "0.0.122";
          sha256 = "1lvwvcs18azqhkzyvhf83ckfhfdgcqrw2gxb2myspqj59783hfpg";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      eg2.vscode-npm-script = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-npm-script";
          publisher = "eg2";
          version = "0.3.24";
          sha256 = "sha256-XgdMLecyZQXsgQAUh8V4eFLKaUF4WVlgy9iIGNDnR/I=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      elmtooling.elm-ls-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "elm-ls-vscode";
          publisher = "Elmtooling";
          version = "2.4.0";
          sha256 = "sha256-5hYlkx8hlwS8iWTlfupX8XjTLAY/KUi0bd3jf/tm92o=";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/Elmtooling.elm-ls-vscode/changelog";
          description = "Elm language server";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=Elmtooling.elm-ls-vscode";
          homepage = "https://github.com/elm-tooling/elm-language-client-vscode";
          license = licenses.mit;
          maintainers = with maintainers; [ mcwitt ];
        };
      };

      emmanuelbeziat.vscode-great-icons = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-great-icons";
          publisher = "emmanuelbeziat";
          version = "2.1.79";
          sha256 = "1cr1pxgxlfr643sfxbcr2xd53s1dnzcpacjj0ffkgizfda2psy78";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      esbenp.prettier-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "prettier-vscode";
          publisher = "esbenp";
          version = "9.10.3";
          sha256 = "sha256-BTuTTElPYRtbzQvUC3iMYlj7NDkGSDa/IppOGBXjfUM=";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/esbenp.prettier-vscode/changelog";
          description = "Code formatter using prettier";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode";
          homepage = "https://github.com/prettier/prettier-vscode";
          license = licenses.mit;
          maintainers = with maintainers; [ datafoo  ];
        };
      };

      ethansk.restore-terminals = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "restore-terminals";
          publisher = "ethansk";
          version = "1.1.6";
          sha256 = "sha256-XCgxphXIJ/y85IR/qEQhGsbnqWFRWvbyIDchnVTUqMg=";
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
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/evzen-wybitul.magic-racket/changelog";
          description = "The best coding experience for Racket in VS Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=evzen-wybitul.magic-racket";
          homepage = "https://github.com/Eugleo/magic-racket";
          license = licenses.agpl3Only;
        };
      };

      faustinoaq.lex-flex-yacc-bison = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "lex-flex-yacc-bison";
          publisher = "faustinoaq";
          version = "0.0.3";
          sha256 = "6254f52157dc796eae7bf135ac88c1c9cc19d884625331a1e634f9768722cc3d";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/faustinoaq.lex-flex-yacc-bison/changelog";
          description = "Language support for Lex, Flex, Yacc and Bison.";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=faustinoaq.lex-flex-yacc-bison";
          homepage = "https://github.com/faustinoaq/vscode-lex-flex-yacc-bison";
          license = licenses.mit;
          maintainers = with maintainers; [ emilytrau ];
        };
      };

      file-icons.file-icons = buildVscodeMarketplaceExtension {
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/file-icons.file-icons/changelog";
          description = "File-specific icons in VSCode for improved visual grepping.";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=file-icons.file-icons";
          homepage = "https://github.com/file-icons/vscode";
          license = licenses.mit;
          maintainers = with maintainers; [ ];
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
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/firefox-devtools.vscode-firefox-debug/changelog";
          description = "A Visual Studio Code extension for debugging web applications and browser extensions in Firefox";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=firefox-devtools.vscode-firefox-debug";
          homepage = "https://github.com/firefox-devtools/vscode-firefox-debug";
          license = licenses.mit;
          maintainers = with maintainers; [ felschr ];
        };
      };

      foam.foam-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "foam-vscode";
          publisher = "foam";
          version = "0.18.3";
          sha256 = "sha256-qbF4k3GP7UdQrw0x/egVRkv5TYDwYWoycxY/HJSFTkI=";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/foam.foam-vscode/changelog";
          description = "A personal knowledge management and sharing system for VSCode ";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=foam.foam-vscode";
          homepage = "https://foambubble.github.io/";
          license = licenses.mit;
          maintainers = with maintainers; [ ratsclub ];
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
          version = "0.11.2";
          sha256 = "0qwcxr6m1xwhqmdl4pccjgpikpq1hgi2hgrva5abn8ixa2510hcy";
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

        meta = with lib; {
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=foxundermoon.shell-format";
          homepage = "https://github.com/foxundermoon/vs-shell-format";
          license = licenses.mit;
          maintainers = with maintainers; [ dbirks ];
        };
      };

      freebroccolo.reasonml = buildVscodeMarketplaceExtension {
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/freebroccolo.reasonml/changelog";
          description = "Reason support for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=freebroccolo.reasonml";
          homepage = "https://github.com/reasonml-editor/vscode-reasonml";
          license = licenses.asl20;
          maintainers = with maintainers; [ ];
        };
        mktplcRef = {
          name = "reasonml";
          publisher = "freebroccolo";
          version = "1.0.38";
          sha256 = "1nay6qs9vcxd85ra4bv93gg3aqg3r2wmcnqmcsy9n8pg1ds1vngd";
        };
      };

      gencer.html-slim-scss-css-class-completion = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "html-slim-scss-css-class-completion";
          publisher = "gencer";
          version = "1.7.8";
          sha256 = "18qws35qvnl0ahk5sxh4mzkw0ib788y1l97ijmpjszs0cd4bfsa6";
        };
        meta = with lib; {
          description = "VSCode extension for SCSS";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=gencer.html-slim-scss-css-class-completion";
          homepage = "https://github.com/gencer/SCSS-Everywhere";
          license = licenses.mit;
          maintainers = with maintainers; [  ];
        };
      };

      gitlab.gitlab-workflow = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "gitlab-workflow";
          publisher = "gitlab";
          version = "3.44.2";
          sha256 = "sha256-S2PI+r4LrHA7tW2EMfcAkP5jUnd0mCEV72oTXMa9Xkc=";
        };
        meta = with lib; {
          description = "GitLab extension for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=gitlab.gitlab-workflow";
          homepage = "https://gitlab.com/gitlab-org/gitlab-vscode-extension#readme";
          license = licenses.mit;
          maintainers = with maintainers; [  ];
        };
      };

      grapecity.gc-excelviewer = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "gc-excelviewer";
          publisher = "grapecity";
          version = "4.2.55";
          sha256 = "sha256-yHl6ZTGIKOEsqmyeYtgDUhNAN9uRpoFApA7FKkPWW3E=";
        };
        meta = with lib; {
          description = "Edit Excel spreadsheets and CSV files in Visual Studio Code and VS Code for the Web";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=grapecity.gc-excelviewer";
          homepage = "https://github.com/jjuback/gc-excelviewer";
          license = licenses.mit;
          maintainers = with maintainers; [ kamadorueda ];
        };
      };

      humao.rest-client = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "humao";
          name = "rest-client";
          version = "0.24.6";
          sha256 = "196pm7gv0488bpv1lklh8hpwmdqc4yimz389gad6nsna368m4m43";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      jkillian.custom-local-formatters = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "jkillian";
          name = "custom-local-formatters";
          version = "0.0.4";
          sha256 = "1pmqnc759fq86g2z3scx5xqpni9khcqi5z2kpl1kb7yygsv314gm";
        };
        meta = {
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [ kamadorueda ];
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

      github = {
        codespaces = buildVscodeMarketplaceExtension {
          mktplcRef = {
            publisher = "github";
            name = "codespaces";
            version = "1.10.6";
            sha256 = "04d6lx8s6rwc6ry6flyw59hg9c4814s5wvi8ycxlwq4pl8n0imd7";
          };
          meta = { license = lib.licenses.unfree; };
        };

        copilot = buildVscodeMarketplaceExtension {
          mktplcRef = {
            publisher = "github";
            name = "copilot";
            version = "1.56.7152";
            sha256 = "sha256-9WEvTcVY/yMF00GJVj4h57aWhfBYTSatbw10DjjAaAM=";
          };
          meta = with lib; {
            description = "GitHub Copilot uses OpenAI Codex to suggest code and entire functions in real-time right from your editor.";
            downloadPage = "https://marketplace.visualstudio.com/items?itemName=GitHub.copilot";
            homepage = "https://github.com/features/copilot";
            license = licenses.unfree;
            maintainers = with maintainers; [ Zimmi48 ];
          };
        };

        github-vscode-theme = buildVscodeMarketplaceExtension {
          mktplcRef = {
            name = "github-vscode-theme";
            publisher = "github";
            version = "4.1.1";
            sha256 = "14wz2b0bn1rnmpj28c0mivz2gacla2dgg8ncv7qfx9bsxhf95g68";
          };
          meta = with lib; {
            description = "GitHub theme for VS Code";
            downloadPage =
              "https://marketplace.visualstudio.com/items?itemName=GitHub.github-vscode-theme";
            homepage = "https://github.com/primer/github-vscode-theme";
            license = licenses.mit;
            maintainers = with maintainers; [ hugolgst ];
          };
        };

        vscode-pull-request-github = buildVscodeMarketplaceExtension {
          mktplcRef = {
            name = "vscode-pull-request-github";
            publisher = "github";
            version = "0.55.2022120109";
            sha256 = "036gfgj3iyz4w3j74zhx3zh7m7rmakm2lg0h7mm11lqbpfwwrki1";
          };
          meta = { license = lib.licenses.mit; };
        };
      };

      golang.go = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "Go";
          publisher = "golang";
          version = "0.33.1";
          sha256 = "0dsjxs04dchw1dbzf45ryhxsb5xhalqwy40xw6cngxkp69lhf91g";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      graphql.vscode-graphql = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-graphql";
          publisher = "GraphQL";
          version = "0.3.50";
          sha256 = "1yf6v2vsgmq86ysb6vxzbg2gh6vz03fsz0d0rhpvpghayrjlk5az";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      gruntfuggly.todo-tree = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "todo-tree";
          publisher = "Gruntfuggly";
          version = "0.0.220";
          sha256 = "06kzb4msfdv11lij4dwbn1vxdxhvnpfcjqw0gvydgkqjy7dridjk";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      haskell.haskell = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "haskell";
          publisher = "haskell";
          version = "2.2.1";
          sha256 = "14p9g07zsb3da4ilaasgsdvh3wagfzayqr8ichsf6k5c952zi8fk";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      hashicorp.terraform = callPackage ./terraform { };

      hookyqr.beautify = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "beautify";
          publisher = "HookyQR";
          version = "1.5.0";
          sha256 = "1c0kfavdwgwham92xrh0gnyxkrl9qlkpv39l1yhrldn8vd10fj5i";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      ibm.output-colorizer = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "output-colorizer";
          publisher = "IBM";
          version = "0.1.2";
          sha256 = "0i9kpnlk3naycc7k8gmcxas3s06d67wxr3nnyv5hxmsnsx5sfvb7";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      iciclesoft.workspacesort = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "workspacesort";
          publisher = "iciclesoft";
          version = "1.6.0";
          sha256 = "1pbk8kflywll6lqhmffz9yjf01dn8xq8sk6rglnfn2kl2ildfhh6";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/iciclesoft.workspacesort/changelog";
          description = "Sort workspace-folders alphabetically rather than in chronological order";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=iciclesoft.workspacesort";
          homepage = "https://github.com/iciclesoft/workspacesort-for-VSCode";
          license = licenses.mit;
          maintainers = with maintainers; [ dbirks ];
        };
      };

      ionide.ionide-fsharp = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "Ionide-fsharp";
          publisher = "Ionide";
          version = "6.0.5";
          sha256 = "sha256-vlmLr/1rBreqZifzEwAlhyGzHG28oZa+kmMzRl53tOI=";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/Ionide.Ionide-fsharp/changelog";
          description = "Enhanced F# Language Features for Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=Ionide.Ionide-fsharp";
          homepage = "https://ionide.io";
          license = licenses.mit;
          maintainers = with maintainers; [ ratsclub ];
        };
      };

      elixir-lsp.vscode-elixir-ls = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "elixir-ls";
          publisher = "JakeBecker";
          version = "0.12.0";
          sha256 = "sha256-ZwdGcsvmEKDH5ZAkKiLEV/3ru74BittnxibMWbdkaco=";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/JakeBecker.elixir-ls/changelog";
          description = "Elixir support with debugger, autocomplete, and more. Powered by ElixirLS.";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=JakeBecker.elixir-ls";
          homepage = "https://github.com/elixir-lsp/elixir-ls";
          license = licenses.mit;
          maintainers = with maintainers; [ datafoo ];
        };
      };

      influxdata.flux = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "influxdata";
          name = "flux";
          version = "0.6.13";
          sha256 = "0myl7rppzcz7hxy9zjs81vs9p66lnbfcrdr6s5qb4i6929gmywfy";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      irongeek.vscode-env = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-env";
          publisher = "irongeek";
          version = "0.1.0";
          sha256 = "sha256-URq90lOFtPCNfSIl2NUwihwRQyqgDysGmBc3NG7o7vk=";
        };
        meta = with lib; {
          description = "Adds formatting and syntax highlighting support for env files (.env) to Visual Studio Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=IronGeek.vscode-env";
          homepage = "https://github.com/IronGeek/vscode-env.git";
          license = licenses.mit;
          maintainers = with maintainers; [  ];
        };
      };

      james-yu.latex-workshop = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "latex-workshop";
          publisher = "James-Yu";
          version = "9.4.4";
          sha256 = "sha256-EA3OABn80GciNecXwLcorWP7K3+jI+wgujpmvvFcNOA=";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/James-Yu.latex-workshop/changelog";
          description = "LaTeX Workshop Extension";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop";
          homepage = "https://github.com/James-Yu/LaTeX-Workshop";
          license = licenses.mit;
        };
      };

      jdinhlife.gruvbox = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "gruvbox";
          publisher = "jdinhlife";
          version = "1.5.1";
          sha256 = "sha256-0ghB0E+Wa9W2bNFFiH2Q3pUJ9HV5+JfKohX4cRyevC8=";
        };
        meta = with lib; {
          description = "Gruvbox Theme";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=jdinhlife.gruvbox";
          homepage = "https://github.com/jdinhify/vscode-theme-gruvbox";
          license = licenses.mit;
          maintainers = with maintainers; [ imgabe ];
        };
      };

      jebbs.plantuml = callPackage ./jebbs.plantuml {};

      jnoortheen.nix-ide = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "nix-ide";
          publisher = "jnoortheen";
          version = "0.2.1";
          sha256 = "sha256-yC4ybThMFA2ncGhp8BYD7IrwYiDU3226hewsRvJYKy4=";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/jnoortheen.nix-ide/changelog";
          description = "Nix language support with formatting and error report";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=jnoortheen.nix-ide";
          homepage = "https://github.com/jnoortheen/vscode-nix-ide";
          license = licenses.mit;
          maintainers = with maintainers; [  SuperSandro2000 ];
        };
      };

      jock.svg = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "svg";
          publisher = "jock";
          version = "1.4.23";
          sha256 = "11f1g4a8v8330ki4240bvg5zpydagg1dwqfh1sar9ds7p1795ims";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      johnpapa.vscode-peacock = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-peacock";
          publisher = "johnpapa";
          version = "4.2.2";
          sha256 = "1z9crpz025ha9hgc9mxxg3vyrsfpf9d16zm1vrf4q592j9156d2m";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      jpoissonnier.vscode-styled-components = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-styled-components";
          publisher = "jpoissonnier";
          version = "1.4.1";
          sha256 = "sha256-ojbeuYBCS+DjF5R0aLuBImzoSOb8mXw1s0Uh0CzggzE=";
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
          version = "0.6.36";
          sha256 = "sha256-4712BPibXJkkq0XEO9n0ZrdXAcID7IAabu/FOTiTeTo=";
        };
        meta = {
          license = lib.licenses.mit;
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
        meta = with lib; {
          description = "The Uncompromising Nix Code Formatter";
          homepage = "https://github.com/kamadorueda/alejandra";
          license = licenses.unlicense;
          maintainers = with maintainers; [ kamadorueda ];
        };
      };

      kddejong.vscode-cfn-lint = let
        inherit (python3Packages) cfn-lint;
      in buildVscodeMarketplaceExtension {
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
          license = lib.licenses.asl20;
          maintainers = with maintainers; [ wolfangaukang ];
        };
      };

      kubukoz.nickel-syntax = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "nickel-syntax";
          publisher = "kubukoz";
          version = "0.0.1";
          sha256 = "010zn58j9kdb2jpxmlfyyyais51pwn7v2c5cfi4051ayd02b9n3s";
        };
        meta = {
          license = lib.licenses.asl20;
        };
      };

      llvm-vs-code-extensions.vscode-clangd = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-clangd";
          publisher = "llvm-vs-code-extensions";
          version = "0.1.23";
          sha256 = "125incws4n688irqii3s2a1cznj0kvkbhv3sa8585chj5g4zvmfy";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      lokalise.i18n-ally = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "i18n-ally";
          publisher = "Lokalise";
          version = "2.7.1";
          sha256 = "sha256-nHBYRSiPQ5ucWPr9VCUgMrosloLnVj40Fh+CEBvWONE=";
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
          maintainers = with lib.maintainers; [ lucperkins ];
        };
      };

      mads-hartmann.bash-ide-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "mads-hartmann";
          name = "bash-ide-vscode";
          version = "1.11.0";
          sha256 = "1hq41fy2v1grjrw77mbs9k6ps6gncwlydm03ipawjnsinxc9rdkp";
        };
        meta = {
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [ kamadorueda ];
        };
      };

      matangover.mypy = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "mypy";
          publisher = "matangover";
          version = "0.2.2";
          sha256 = "sha256-eaiR30HjPCpOLUKQqiQ2Oqj+XY+JNnV47bM5KD2Mouk=";
        };
        meta.license = lib.licenses.mit;
      };

      mattn.lisp = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "lisp";
          publisher = "mattn";
          version = "0.1.12";
          sha256 = "sha256-x6aFrcX0YElEFEr0qA669/LPlab15npmXd5Q585pIEw=";
        };
        meta = with lib; {
          description = "Lisp syntax for vscode";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=mattn.lisp";
          homepage = "https://github.com/mattn/vscode-lisp";
          changelog = "https://marketplace.visualstudio.com/items/mattn.lisp/changelog";
          license = licenses.mit;
          maintainers = with maintainers; [ kamadorueda ];
        };
      };

      maximedenes.vscoq = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "maximedenes";
          name = "vscoq";
          version = "0.3.6";
          sha256 = "sha256-b0gCaEzt5yAj53oLFZSXSD3bum9J1fYes/uf9+OlUek=";
        };
        meta = with lib; {
          description = "VsCoq is an extension for Visual Studio Code (VS Code) and VSCodium with support for the Coq Proof Assistant.";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=maximedenes.vscoq";
          homepage = "https://github.com/coq-community/vscoq";
          license = licenses.mit;
          maintainers = with maintainers; [ Zimmi48 ];
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

      marp-team.marp-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "marp-vscode";
          publisher = "marp-team";
          version = "1.5.0";
          sha256 = "0wqsj8rp58vl3nafkjvyw394h5j4jd7d24ra6hkvfpnlzrgv4yhs";
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
          version = "0.10.1";
          sha256 = "0m89sx1qqdkwa9pfmd9b11lp8z0dqpi6jn27js5q4ymscyg41bqd";
        };
        meta = with lib; {
          description = "direnv support for Visual Studio Code";
          license = licenses.bsd0;
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=mkhl.direnv";
          maintainers = with maintainers; [ nullx76 ];
        };
      };

      mskelton.one-dark-theme = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "one-dark-theme";
          publisher = "mskelton";
          version = "1.7.2";
          sha256 = "1ks6z8wsxmlfhiwa51f7d6digvw11dlxc7mja3hankgxcf5dyj31";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      mechatroner.rainbow-csv = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "rainbow-csv";
          publisher = "mechatroner";
          version = "2.0.0";
          sha256 = "0wjlp6lah9jb0646sbi6x305idfgydb6a51pgw4wdnni02gipbrs";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ms-azuretools.vscode-docker = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-docker";
          publisher = "ms-azuretools";
          version = "1.22.2";
          sha256 = "13scns5iazzsjx8rli311ym2z8i8f4nvbcd5w8hqj5z0rzsds6xi";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ms-ceintl = callPackage ./language-packs.nix {}; # non-English language packs

      ms-dotnettools.csharp = callPackage ./ms-dotnettools-csharp { };

      ms-kubernetes-tools.vscode-kubernetes-tools = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-kubernetes-tools";
          publisher = "ms-kubernetes-tools";
          version = "1.3.4";
          sha256 = "0ial5ljgm0m35wh5gy4kpr0v7053wi52cv57ad4vcbxc9z00hxrd";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ms-vscode.cpptools = callPackage ./cpptools { };

      ms-vscode.cmake-tools = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "cmake-tools";
          publisher = "ms-vscode";
          version = "1.13.26";
          sha256 = "1bkjqlv48slgb8nf8y2g4nf11c1appr0ycka2w3mmbiczwdmyjr5";
        };
        meta.license = lib.licenses.mit;
      };

      ms-vscode.hexeditor = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "hexeditor";
          publisher = "ms-vscode";
          version = "1.9.9";
          sha256 = "0w7b9llgm6plzpkr5g8ikpyxdgfdjcd5v9xzhp6967j0xphisdbb";
        };
        meta = {
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

      ms-vscode.PowerShell = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "PowerShell";
          publisher = "ms-vscode";
          version = "2022.11.0";
          sha256 = "01pq84rqh2q6rd0ljfql37q6i1kg597qy0mr7fiz5ddi15zcfn19";
        };
        meta = with lib; {
          description = "A Visual Studio Code extension for PowerShell language support";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell";
          homepage = "https://github.com/PowerShell/vscode-powershell";
          license = licenses.mit;
          maintainers = with maintainers; [ rhoriguchi ];
        };
      };

      ms-vscode-remote.remote-ssh = callPackage ./remote-ssh { };

      ms-vscode.theme-tomorrowkit = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "Theme-TomorrowKit";
          publisher = "ms-vscode";
          version = "0.1.4";
          sha256 = "sha256-qakwJWak+IrIeeVcMDWV/fLPx5M8LQGCyhVt4TS/Lmc=";
        };
        meta = with lib; {
          description = "Additional Tomorrow and Tomorrow Night themes for VS Code. Based on the TextMate themes.";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-vscode.Theme-TomorrowKit";
          homepage = "https://github.com/microsoft/vscode-themes";
          license = licenses.mit;
          maintainers = with maintainers; [ ratsclub ];
        };
      };

      ms-pyright.pyright = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "pyright";
          publisher = "ms-pyright";
          version = "1.1.282";
          sha256 = "14qkk9gbpwnbkk3dk7b7s92smj374ha7axlsi74fllw74lp4ziwn";
        };
        meta = with lib; {
          description = "VS Code static type checking for Python";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ms-pyright.pyright";
          homepage = "https://github.com/Microsoft/pyright#readme";
          changelog = "https://marketplace.visualstudio.com/items/ms-pyright.pyright/changelog";
          license = licenses.mit;
          maintainers = with maintainers; [ ratsclub ];
        };
      };

      ms-python.python = callPackage ./python { };

      msjsdiag.debugger-for-chrome = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "debugger-for-chrome";
          publisher = "msjsdiag";
          version = "4.12.11";
          sha256 = "sha256-9i3TgCFThnFF5ccwzS4ATj5c2Xoe/4tDFGv75jJxeQ4=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ms-toolsai.vscode-jupyter-cell-tags = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-jupyter-cell-tags";
          publisher = "ms-toolsai";
          version = "0.1.6";
          sha256 = "1sb3za0ka8bl1kydlniwlaixldlgqxvfbx7pcyrg1a4sg6zwsvk1";
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

      ms-toolsai.jupyter = callPackage ./ms-toolsai-jupyter {};

      ms-toolsai.jupyter-keymap = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "jupyter-keymap";
          publisher = "ms-toolsai";
          version = "1.0.0";
          sha256 = "0wkwllghadil9hk6zamh9brhgn539yhz6dlr97bzf9szyd36dzv8";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ms-toolsai.jupyter-renderers = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "jupyter-renderers";
          publisher = "ms-toolsai";
          version = "1.0.12";
          sha256 = "12l5z60kpz3nx77l8ck6a6w4qdzyz3xkn6k9670r30w365q9lf0z";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ms-vscode.anycode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "anycode";
          publisher = "ms-vscode";
          version = "0.0.57";
          sha256 = "sha256-XwL7I+vwZJ6zx5IDZdfOUbq6M9IH/gi7MBe92cG1kDs=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      mvllow.rose-pine = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "mvllow";
          name = "rose-pine";
          version = "1.3.6";
          sha256 = "sha256-pKrwiA/ZArBfumT0VTauhINSDEbABWgBBzTZEE07wzk=";
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
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/naumovs.color-highlight/changelog";
          description = "Highlight web colors in your editor";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=naumovs.color-highlight";
          homepage = "https://github.com/enyancc/vscode-ext-color-highlight";
          license = licenses.gpl3Only;
          maintainers = with maintainers; [ datafoo ];
        };
      };

      njpwerner.autodocstring = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "autodocstring";
          publisher = "njpwerner";
          version = "0.6.1";
          sha256 = "sha256-NI0cbjsZPW8n6qRTRKoqznSDhLZRUguP7Sa/d0feeoc=";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/njpwerner.autodocstring/changelog";
          description = "Generates python docstrings automatically";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=njpwerner.autodocstring";
          homepage = "https://github.com/NilsJPWerner/autoDocstring";
          license = licenses.mit;
          maintainers = with maintainers; [ kamadorueda ];
        };
      };

      octref.vetur = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vetur";
          publisher = "octref";
          version = "0.34.1";
          sha256 = "09w3bik1mxs7qac67wgrc58vl98ham3syrn2anycpwd7135wlpby";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      oderwat.indent-rainbow = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "indent-rainbow";
          publisher = "oderwat";
          version = "8.2.2";
          sha256 = "sha256-7kkJc+hhYaSKUbK4eYwOnLvae80sIg7rd0E4YyCXtPc=";
        };
        meta = with lib; {
          description = "Makes indentation easier to read";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=oderwat.indent-rainbow";
          homepage = "https://github.com/oderwat/vscode-indent-rainbow";
          license = licenses.mit;
          maintainers = with maintainers; [ imgabe ];
        };
      };

      phoenixframework.phoenix = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "phoenix";
          publisher = "phoenixframework";
          version = "0.1.1";
          sha256 = "sha256-AfCwU4FF8a8C9D6+lyUDbAOLlD5SpZZw8CZVGpzRoV0=";
        };
        meta = with lib; {
          description = "Syntax highlighting support for HEEx / Phoenix templates";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=phoenixframework.phoenix";
          homepage = "https://github.com/phoenixframework/vscode-phoenix";
          license = licenses.mit;
          maintainers = with maintainers; [  ];
        };
      };

      redhat.java = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "java";
          publisher = "redhat";
          version = "1.14.2022120303";
          sha256 = "sha256-tlWb2rkDcEWgdpuidkBGN5Nxr3pmkYxnPJN/UdbQfEw=";
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
          version = "0.23.2022120303";
          sha256 = "sha256-rQvbb7GOUwVwg/049jchJMJTwaFsOP63AovcEmr2HXs=";
        };
        meta.license = lib.licenses.epl20;
      };

      redhat.vscode-yaml = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-yaml";
          publisher = "redhat";
          version = "1.11.10112022";
          sha256 = "0i53n9whcfpds9496r4pa27j3zmd4jc1kpkf4m4rfxzswwngg47x";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      rioj7.commandOnAllFiles = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "commandOnAllFiles";
          publisher = "rioj7";
          version = "0.3.0";
          sha256 = "sha256-tNFHrgFJ22YGQgkYw+0l4G6OtlUYVn9brJPLnsvSwRE=";
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
        meta = with lib; {
          license = licenses.mit;
        };
      };

      rust-lang.rust-analyzer = callPackage ./rust-analyzer { };
      matklad.rust-analyzer = self.rust-lang.rust-analyzer; # Previous publisher

      ocamllabs.ocaml-platform = buildVscodeMarketplaceExtension {
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/ocamllabs.ocaml-platform/changelog";
          description = "Official OCaml Support from OCamlLabs";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ocamllabs.ocaml-platform";
          homepage = "https://github.com/ocamllabs/vscode-ocaml-platform";
          license = licenses.isc;
          maintainers = with maintainers; [ ratsclub  ];
        };
        mktplcRef = {
          name = "ocaml-platform";
          publisher = "ocamllabs";
          version = "1.10.7";
          sha256 = "sha256-BxVur+aSbFPyX+DW9tQcfJEyImkbTC6O0uOV2d76au0=";
        };
      };

      pkief.material-icon-theme = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "material-icon-theme";
          publisher = "PKief";
          version = "4.22.0";
          sha256 = "0irrivfidgjqfd205gh27r2ccj2anvqgvq7lfaaf92wrrc2zvlsk";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      pkief.material-product-icons = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "material-product-icons";
          publisher = "PKief";
          version = "1.1.1";
          sha256 = "a0bd0eff67793828768135fd839f28db0949da9a310db312beb0781f2164fd47";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      piousdeer.adwaita-theme = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "adwaita-theme";
          publisher = "piousdeer";
          version = "1.0.8";
          sha256 = "XyzxiwKQGDUIXp6rnt1BmPzfpd1WrG8HnEqYEOJV6P8=";
        };
        meta = with lib; {
          description = "Theme for the GNOME desktop";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=piousdeer.adwaita-theme";
          homepage = "https://github.com/piousdeer/vscode-adwaita";
          license = licenses.gpl3;
          maintainers = with maintainers; [ wyndon ];
        };
      };

      prisma.prisma = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "prisma";
          publisher = "Prisma";
          version = "4.2.0";
          sha256 = "sha256-1U3JlWfIlTt0AMPsiP3vD2ZEzD2oUsYsqRRwBQeoLIA=";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/Prisma.prisma/changelog";
          description = "VSCode extension for syntax highlighting, formatting, auto-completion, jump-to-definition and linting for .prisma files";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=Prisma.prisma";
          homepage = "https://github.com/prisma/language-tools";
          license = licenses.asl20;
          maintainers = with maintainers; [  ];
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

      richie5um2.snake-trail = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "snake-trail";
          publisher = "richie5um2";
          version = "0.6.0";
          sha256 = "0wkpq9f48hplrgabb0v1ij6fc4sb8h4a93dagw4biprhnnm3qx49";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      ritwickdey.liveserver = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "liveserver";
          publisher = "ritwickdey";
          version = "5.6.1";
          sha256 = "sha256-QPMZMttYV+dQfWTniA7nko7kXukqU9g6Wj5YDYfL6hw=";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      roman.ayu-next = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "ayu-next";
          publisher = "roman";
          version = "1.2.9";
          sha256 = "sha256-rwZnqvHRmMquNq9PnU176vI4g8PtS6wSNvQaZ1BMa4I=";
        };
        meta = {
          license = lib.licenses.mit;
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
          maintainers = with lib.maintainers; [ pbsds ];
        };
      };

      scala-lang.scala = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "scala";
          publisher = "scala-lang";
          version = "0.5.5";
          sha256 = "1gqgamm97sq09za8iyb06jf7hpqa2mlkycbx6zpqwvlwd3a92qr1";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      scalameta.metals = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "metals";
          publisher = "scalameta";
          version = "1.20.0";
          sha256 = "3EjXzSMBIim13dRP1fBmbV/OtLmBjvcmjDXwYoeGfLA=";
        };
        meta = {
          license = lib.licenses.asl20;
        };
      };

      serayuzgur.crates = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "crates";
          publisher = "serayuzgur";
          version = "0.5.10";
          sha256 = "1dbhd6xbawbnf9p090lpmn8i5gg1f7y8xk2whc9zhg4432kdv3vd";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      shardulm94.trailing-spaces = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "shardulm94";
          name = "trailing-spaces";
          version = "0.3.1";
          sha256 = "0h30zmg5rq7cv7kjdr5yzqkkc1bs20d72yz9rjqag32gwf46s8b8";
        };
        meta = {
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [ kamadorueda ];
        };
      };

      shd101wyy.markdown-preview-enhanced = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "shd101wyy";
          name = "markdown-preview-enhanced";
          version = "0.6.3";
          sha256 = "dCWERQ5rHnmYLtYl12gJ+dXLnpMu55WnmF1VfdP0x34=";
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
          maintainers = with lib.maintainers; [ pbsds ];
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

      silvenon.mdx = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "mdx";
          publisher = "silvenon";
          version = "0.1.0";
          sha256 = "1mzsqgv0zdlj886kh1yx1zr966yc8hqwmiqrb1532xbmgyy6adz3";
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
        meta = with lib; {
          changelog = "https://github.com/skellock/vscode-just/blob/master/CHANGELOG.md";
          description = "Provides syntax and recipe launcher for Just scripts";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=skellock.just";
          homepage = "https://github.com/skellock/vscode-just";
          license = licenses.mit;
          maintainers = with maintainers; [ maximsmol ];
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
          version = "3.12.0";
          sha256 = "sha256-vVOmqb0iEIGgN+LkJfazNN+KNWvnWRbIsqetXfeabJU=";
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
        meta = with lib; {
          license = licenses.mit;
        };
      };

      stefanjarina.vscode-eex-snippets = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-eex-snippets";
          publisher = "stefanjarina";
          version = "0.0.8";
          sha256 = "0j8pmrs1lk138vhqx594pzxvrma4yl3jh7ihqm2kgh0cwnkbj36m";
        };
        meta = with lib; {
          description = "VSCode extension for Elixir EEx and HTML (EEx) code snippets";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=stefanjarina.vscode-eex-snippets";
          homepage = "https://github.com/stefanjarina/vscode-eex-snippets";
          license = licenses.mit;
          maintainers = with maintainers; [  ];
        };
      };

      stephlin.vscode-tmux-keybinding = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-tmux-keybinding";
          publisher = "stephlin";
          version = "0.0.6";
          sha256 = "0mph2nval1ddmv9hpl51fdvmagzkqsn8ljwqsfha2130bb7la0d9";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/stephlin.vscode-tmux-keybinding/changelog";
          description = "A simple extension for tmux behavior in vscode terminal.";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=stephlin.vscode-tmux-keybinding";
          homepage = "https://github.com/StephLin/vscode-tmux-keybinding";
          license = licenses.mit;
          maintainers = with maintainers; [ dbirks ];
        };
      };

      stkb.rewrap = buildVscodeMarketplaceExtension {
        mktplcRef = {
          publisher = "stkb";
          name = "rewrap";
          version = "1.16.3";
          sha256 = "sha256-WHeLTN992ltEZw2W7B3sJrHfAFsOGMq3llV4C0hXLNA=";
        };
        meta = with lib; {
          changelog = "https://github.com/stkb/Rewrap/blob/master/CHANGELOG.md";
          description = "Hard word wrapping for comments and other text at a given column.";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=stkb.rewrap";
          homepage = "https://github.com/stkb/Rewrap#readme";
          license = licenses.asl20;
          maintainers = with maintainers; [ datafoo ];
        };
      };

      streetsidesoftware.code-spell-checker = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "code-spell-checker";
          publisher = "streetsidesoftware";
          version = "2.12.0";
          sha256 = "sha256-Dhd0QVWdCCvdGKuu8OB4KrBS0XUHWLzRSyreAf7sGLU=";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/streetsidesoftware.code-spell-checker/changelog";
          description = "Spelling checker for source code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker";
          homepage = "https://streetsidesoftware.github.io/vscode-spell-checker";
          license = licenses.gpl3Only;
          maintainers = with maintainers; [ datafoo ];
        };
      };

      sumneko.lua = callPackage ./lua { };

      svelte.svelte-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "svelte-vscode";
          publisher = "svelte";
          version = "106.3.0";
          sha256 = "sha256-xe1Ad24r2Ks85WAfaD5em8KGwaQ5h6i5qkUouU6lmtc=";
        };
        meta = {
          changelog = "https://github.com/sveltejs/language-tools/releases";
          description = "Svelte language support for VS Code";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=svelte.svelte-vscode";
          homepage = "https://github.com/sveltejs/language-tools#readme";
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [ fabianhauser ];
        };
      };

      svsool.markdown-memo = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "markdown-memo";
          publisher = "svsool";
          version = "0.3.18";
          sha256 = "sha256-ypYqVH1ViJE7+mAJnxmpvUSmiImOo7rE7m+ijTEpmwg=";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/svsool.markdown-memo/changelog";
          description = "Markdown knowledge base with bidirectional [[link]]s built on top of VSCode";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=svsool.markdown-memo";
          homepage = "https://github.com/svsool/vscode-memo";
          license = licenses.mit;
          maintainers = with maintainers; [ ratsclub ];
        };
      };

      tabnine.tabnine-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "tabnine-vscode";
          publisher = "tabnine";
          version = "3.4.27";
          sha256 = "sha256-Xg/N59a38OKEWb/4anysslensUoj9ENcuobkyByFDxE=";
        };
        meta = {
          license = lib.licenses.mit;
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
          version = "0.14.2";
          sha256 = "17djwa2bnjfga21nvyz8wwmgnjllr4a7nvrsqvzm02hzlpwaskcl";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      theangryepicbanana.language-pascal = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "language-pascal";
          publisher = "theangryepicbanana";
          version = "0.1.6";
          sha256 = "096wwmwpas21f03pbbz40rvc792xzpl5qqddzbry41glxpzywy6b";
        };
        meta = with lib; {
          description = "VSCode extension for high-quality Pascal highlighting";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=theangryepicbanana.language-pascal";
          homepage = "https://github.com/ALANVF/vscode-pascal-magic";
          license = licenses.mit;
          maintainers = with maintainers; [  ];
        };
      };

      thenuprojectcontributors.vscode-nushell-lang = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-nushell-lang";
          publisher = "thenuprojectcontributors";
          version = "0.8.0";
          sha256 = "0065ckgpsalqgv9zw8gvxxkqzwl7mjp6mydnlm1m3y9qxlfl010s";
        };
        meta.license = lib.licenses.mit;
      };

      tiehuis.zig = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "zig";
          publisher = "tiehuis";
          version = "0.2.5";
          sha256 = "sha256-P8Sep0OtdchTfnudxFNvIK+SW++TyibGVI9zd+B5tu4=";
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
          version = "1.10.7";
          sha256 = "sha256-t5CKrDEbDCuo28wN+hiWrvkt3C9vQAPfV/nd3QBGQ/s=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      tomoki1207.pdf = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "pdf";
          publisher = "tomoki1207";
          version = "1.2.0";
          sha256 = "1bcj546bp0w4yndd0qxwr8grhiwjd1jvf33jgmpm0j96y34vcszz";
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
          version = "0.37.1";
          sha256 = "19969qb6ink70km4wawh4w238igdm6npwskyr3hx38qgf69nd748";
        };
        meta = {
          changelog = "https://github.com/whitphx/vscode-emacs-mcx/blob/main/CHANGELOG.md";
          description = "Awesome Emacs Keymap - VSCode emacs keybinding with multi cursor support";
          homepage = "https://github.com/whitphx/vscode-emacs-mcx";
          license = lib.licenses.mit;
        };
      };

      tyriar.sort-lines = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "sort-lines";
          publisher = "Tyriar";
          version = "1.9.1";
          sha256 = "0dds99j6awdxb0ipm15g543a5b6f0hr00q9rz961n0zkyawgdlcb";
        };
        meta = {
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

      usernamehw.errorlens = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "errorlens";
          publisher = "usernamehw";
          version = "3.6.0";
          sha256 = "sha256-oNzB81mPZjEwrqbeFMvTlXERXrYBpF03EH9ZXz/daOs=";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/usernamehw.errorlens/changelog";
          description = "Improve highlighting of errors, warnings and other language diagnostics.";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=usernamehw.errorlens";
          homepage = "https://github.com/usernamehw/vscode-error-lens";
          license = licenses.mit;
          maintainers = with maintainers; [ imgabe ];
        };
      };

      vadimcn.vscode-lldb = callPackage ./vscode-lldb { llvmPackages = llvmPackages_14; };

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

      viktorqvarfordt.vscode-pitch-black-theme = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-pitch-black-theme";
          publisher = "ViktorQvarfordt";
          version = "1.3.0";
          sha256 = "sha256-1JDm/cWNWwxa1gNsHIM/DIvqjXsO++hAf0mkjvKyi4g=";
        };
        meta = with lib; {
          license = licenses.mit;
          maintainers = with maintainers; [ wolfangaukang ];
        };
      };


      vincaslt.highlight-matching-tag = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "highlight-matching-tag";
          publisher = "vincaslt";
          version = "0.10.1";
          sha256 = "0b9jpwiyxax783gyr9zhx7sgrdl9wffq34fi7y67vd68q9183jw1";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ms-vsliveshare.vsliveshare = callPackage ./ms-vsliveshare-vsliveshare { };

      vscjava.vscode-java-debug = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-java-debug";
          publisher = "vscjava";
          version = "0.47.2022112823";
          sha256 = "0nlkkpc2v755g39lcb5bhx207b0kjn44q539w07al9b021y2vq54";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vscjava.vscode-java-dependency = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-java-dependency";
          publisher = "vscjava";
          version = "0.21.2022111900";
          sha256 = "1k5wk27s0lk2ywc6ajvraldhr1d48i0l2fj7jlaayds41zhyj73l";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vscjava.vscode-java-test = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-java-test";
          publisher = "vscjava";
          version = "0.37.2022090902";
          sha256 = "17i9jfwpjjxp81dg6nnviczzmr47pvz33zc4bwfvz69ckn6v74j4";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vscjava.vscode-maven = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-maven";
          publisher = "vscjava";
          version = "0.40.2022120203";
          sha256 = "063b0k74zy62qg6mh2bms15jiydysv58mds8p82nw3iajm6ppm5i";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vscjava.vscode-spring-initializr = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-spring-initializr";
          publisher = "vscjava";
          version = "0.11.0";
          sha256 = "1rbwbfz2wgw57vna8ip5b4k8mpk1d1y9vx0xr6gfqhmh6igigqil";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vscodevim.vim = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vim";
          publisher = "vscodevim";
          version = "1.24.1";
          sha256 = "00gq6mqqwqipc6d7di2x9mmi1lya11vhkkww9563avchavczb9sv";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vspacecode.vspacecode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vspacecode";
          publisher = "VSpaceCode";
          version = "0.10.9";
          sha256 = "sha256-16oC2BghY7mB/W0niTDtKGMAC9pt6m0utSOJ0lgbpAU=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vspacecode.whichkey = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "whichkey";
          publisher = "VSpaceCode";
          version = "0.9.2";
          sha256 = "sha256-f+t2d8iWW88OYzuYFxzQPnmFMgx/DELBywYhA8A/0EU=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      wix.vscode-import-cost = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-import-cost";
          publisher = "wix";
          version = "3.3.0";
          sha256 = "0wl8vl8n0avd6nbfmis0lnlqlyh4yp3cca6kvjzgw5xxdc5bl38r";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      xadillax.viml = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "viml";
          publisher = "xadillax";
          version = "2.1.2";
          sha256 = "sha256-n91Rj1Rpp7j7gndkt0bV+jT1nRMv7+coVoSL5c7Ii3A=";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      xaver.clang-format = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "clang-format";
          publisher = "xaver";
          version = "1.9.0";
          sha256 = "abd0ef9176eff864f278c548c944032b8f4d8ec97d9ac6e7383d60c92e258c2f";
        };
        meta = with lib; {
          license = licenses.mit;
          maintainers = [ maintainers.zeratax ];
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

      yzhang.markdown-all-in-one = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "markdown-all-in-one";
          publisher = "yzhang";
          version = "3.4.4";
          sha256 = "2lZfWP+yk0Dp8INLjlJY5ROGu0sLaWhb4fT+O9xGg0s=";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      zhuangtongfa.material-theme = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "material-theme";
          publisher = "zhuangtongfa";
          version = "3.13.17";
          sha256 = "100riqnvc2j315i1lvnwxmgga17s369xxvds5skgnk2yi2xnm2g9";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      llvm-org.lldb-vscode = llvmPackages_8.lldb;

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

      WakaTime.vscode-wakatime = callPackage ./wakatime { };

      wingrunr21.vscode-ruby = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-ruby";
          publisher = "wingrunr21";
          version = "0.28.0";
          sha256 = "sha256-H3f1+c31x+lgCzhgTb0uLg9Bdn3pZyJGPPwfpCYrS70=";
        };

        meta.license = lib.licenses.mit;
      };

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

  aliases = self: super: {
    # aliases
    jakebecker.elixir-ls = super.elixir-lsp.vscode-elixir-ls;
    ms-vscode = lib.recursiveUpdate super.ms-vscode { inherit (super.golang) go; };
  };

  # TODO: add overrides overlay, so that we can have a generated.nix
  # then apply extension specific modifcations to packages.

  # overlays will be applied left to right, overrides should come after aliases.
  overlays = lib.optionals config.allowAliases [ aliases ];

  toFix = lib.foldl' (lib.flip lib.extends) baseExtensions overlays;
in
lib.fix toFix
