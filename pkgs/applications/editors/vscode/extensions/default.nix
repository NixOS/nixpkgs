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
, nixpkgs-fmt
, protobuf
, jq
, shellcheck
, moreutils
, racket-minimal
, clojure-lsp
, alejandra
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
          version = "12.2.0";
          sha256 = "sha256-CChkWKiLi/OcOm268d45pNwiyrKhztqYsQvJV/9z+Ag=";
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
          version = "1.19.9";
          sha256 = "sha256-iJpzNKcuQrfq4Z0LXuadt6OKXelBbDQg/vuc7NJ2I5o=";
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
          version = "0.18.0";
          sha256 = "sha256-Uo6peR+2ZNX6nwJ0Yar32Pe0rfBZ+f6ef1cYhUvVUbE=";
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
          version = "1.0.7";
          sha256 = "0e76885c9dbb6dca4eac8a75866ec372b948cc64a3a3845327d7c3ef6ba42a57";
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

      asvetliakov.vscode-neovim = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-neovim";
          publisher = "asvetliakov";
          version = "0.0.83";
          sha256 = "1giybf12p0h0fm950w9bwvzdk77771zfkylrqs9h0lhbdzr92qbl";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      ms-python.vscode-pylance = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-pylance";
          publisher = "MS-python";
          version = "2022.1.5";
          sha256 = "1b5ihrac9xsq35a39vlq7krr1ffqpdjxdlhv9s056hs033kayazl";
        };

        buildInputs = [ nodePackages.pyright ];

        meta = {
          license = lib.licenses.unfree;
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

      bradlc.vscode-tailwindcss = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-tailwindcss";
          publisher = "bradlc";
          version = "0.6.13";
          sha256 = "098vrm28b7jpzk0c2d0cgxvdw4jsswzf18cx1m9jwsm1j40fp5f4";
        };
        meta = with lib; {
          license = licenses.mpl20;
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

      chenglou92.rescript-vscode = callPackage ./rescript { };

      christian-kohler.path-intellisense = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "path-intellisense";
          publisher = "christian-kohler";
          version = "2.6.1";
          sha256 = "sha256-ol98g3pliBlyEQ+n7cR4O04J/0QB9U8+fvf+FC0j0Fc=";
        };
        meta = with lib; {
          description = "Visual Studio Code plugin that autocompletes filenames";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=christian-kohler.path-intellisense";
          homepage = "https://github.com/ChristianKohler/PathIntellisense";
          license = licenses.mit;
          maintainers = with maintainers; [ imgabe ];
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
          version = "2.2.2";
          sha256 = "sha256-llalyQXl+k/ugZq+Ti9mApHRqAGu6QyoMP51GtZnRJ4=";
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
          version = "0.46.0";
          sha256 = "sha256-2FvE+6fnZPtR0At4NjLKSMCbPu8T7o8xtpvYiEjh7ck=";
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
          version = "3.9.1";
          sha256 = "sha256-OuGTjmJQFAWrYp7YnFpyo0NnnCcXYF8itYjGKMa3FCs=";
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
          version = "0.6.14";
          sha256 = "11x116hzqnhgbryp2kqpki1z5mlnwxb0ly9r1513m5vgbisrsn0i";
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
          version = "2.22.3";
          sha256 = "0wni9sriin54ci8rly2s68lkfx8rj1cys6mgcizvps9sam6377w6";
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
          version = "12.0.3";
          sha256 = "sha256-PHQXfk0JggkEBRflHp+OAUOCVuymCubaszfDCYbpfG0=";
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
          version = "9.3.0";
          sha256 = "sha256-hJgPjWf7a8+ltjmXTK8U/MwqgIZqBjmcCfHsAk2G3PA=";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/esbenp.prettier-vscode/changelog";
          description = "Code formatter using prettier";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode";
          homepage = "https://github.com/prettier/prettier-vscode";
          license = licenses.mit;
          maintainers = with maintainers; [ datafoo ];
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
          version = "1.0.28";
          sha256 = "1lyx0l42xhi2f3rdnjddc3mw7m913kjnchawi98i6vqsx3dv7091";
        };
      };

      foam.foam-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "foam-vscode";
          publisher = "foam";
          version = "0.14.1";
          sha256 = "sha256-w9xGkezS3A9z6sTk8WWgW7g8qYX6mJFfRV0lv5cu160=";
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
        copilot = buildVscodeMarketplaceExtension {
          mktplcRef = {
            publisher = "github";
            name = "copilot";
            version = "1.7.4812";
            sha256 = "1yl7m90m38pv8nz4dwcszjsa1sf253459xln17mngmc8z9wd3d3a";
          };
          meta = { license = lib.licenses.unfree; };
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
            version = "0.37.2022030309";
            sha256 = "1icmg2ssdkxvwp8mn8zzakwn42hrdglsdgfnaf8va4vd9mqixl1v";
          };
          meta = { license = lib.licenses.mit; };
        };
      };

      golang.go = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "Go";
          publisher = "golang";
          version = "0.25.1";
          sha256 = "sha256-ZDUWN9lzDnR77W7xcMFQaaFl/6Lf/x1jgaBkwZPqGGw=";
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
          version = "0.0.215";
          sha256 = "sha256-WK9J6TvmMCLoqeKWh5FVp1mNAXPWVmRvi/iFuLWMylM=";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      haskell.haskell = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "haskell";
          publisher = "haskell";
          version = "1.8.0";
          sha256 = "sha256-+k8XT2COe9Z8HvZvcrzfVuocRcxXBrVoNHDT/uKK7Hs=";
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
          version = "5.10.1";
          sha256 = "sha256-LkWWgyh4khPyUgekVeO8ZzPK+1gTrS8d9Yz6/kHomr8=";
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
          version = "0.8.0";
          sha256 = "sha256-VD1g4DJfA0vDJ0cyHFDEtCEqQo0nXfPC5vknEU91cPk=";
        };
        meta = with lib; {
          license = licenses.mit;
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

      jakebecker.elixir-ls = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "elixir-ls";
          publisher = "JakeBecker";
          version = "0.9.0";
          sha256 = "sha256-KNfZOrVxK3/rClHPcIyPgE9CRtjkI7NLY0xZ9W+X6OM=";
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

      james-yu.latex-workshop = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "latex-workshop";
          publisher = "James-Yu";
          version = "8.23.0";
          sha256 = "sha256-IHLsAuTi+GBZViL2KozudebNY745RiOYNATzabQfnOY=";
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

      jnoortheen.nix-ide = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "nix-ide";
          publisher = "jnoortheen";
          version = "0.1.19";
          sha256 = "1ms96ij6z4bysdhqgdaxx2znvczyhzx57iifbqws50m1c3m7pkx7";
        };
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/jnoortheen.nix-ide/changelog";
          description = "Nix language support with formatting and error report";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=jnoortheen.nix-ide";
          homepage = "https://github.com/jnoortheen/vscode-nix-ide";
          license = licenses.mit;
          maintainers = with maintainers; [ SuperSandro2000 ];
        };
      };

      jock.svg = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "svg";
          publisher = "jock";
          version = "1.4.17";
          sha256 = "sha256-CDxh/YRyDGocxG4qOcyLXA0zHCg0YJ7XUu3OjFFjleI=";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      johnpapa.vscode-peacock = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-peacock";
          publisher = "johnpapa";
          version = "4.0.0";
          sha256 = "1i65w70f0kikah1cx7m0bji6qd800jabfci0xisdqxyzaksg7ysz";
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
          version = "3.4.0";
          sha256 = "0ab7m5jzxakjxaiwmg0jcck53vnn183589bbxh3iiylkpicrv67y";
        };
        meta = {
          license = lib.licenses.bsd3;
        };
      };

      kahole.magit = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "magit";
          publisher = "kahole";
          version = "0.6.18";
          sha256 = "0sqzz5bbqqg60aypvwxcqnxrr72gmwfj9sv0amgkyaf60zg5sf7w";
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
          version = "0.1.15";
          sha256 = "0skasnc490wp0l5xzpdmwdzjr4qiy63kg2qi27060m5yqkq3h8xn";
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
          version = "1.20.0";
          sha256 = "sha256-i3gYTP76YEDItG2oXR9pEXuGv0qmyf1Xv6HQvDBEOyg=";
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
          version = "1.1.222";
          sha256 = "sha256-QMX/SawDEnG1xVrug8mvN7EvRrRDkJffcXBUFpQi1XE=";
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

      ms-python.python = callPackage ./python {
        extractNuGet = callPackage ./python/extract-nuget.nix { };
      };

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

      ms-toolsai.jupyter = callPackage ./ms-toolsai-jupyter {};

      ms-toolsai.jupyter-renderers = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "jupyter-renderers";
          publisher = "ms-toolsai";
          version = "1.0.4";
          sha256 = "sha256-aKWu0Gp0f28DCv2akF/G8UDaGfTN410CcH8CAmW7mgU=";
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

      redhat.java = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "java";
          publisher = "redhat";
          version = "1.4.0";
          sha256 = "sha256-9q3ilNukx3sQ6Fr1LhuQdjHHS251SDoHxC33w+qrfAI=";
        };
        buildInputs = [ jdk ];
        meta = {
          license = lib.licenses.epl20;
          broken = lib.versionOlder jdk.version "11";
        };
      };

      redhat.vscode-yaml = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vscode-yaml";
          publisher = "redhat";
          version = "1.5.1";
          sha256 = "sha256-JXhmgBFZdKNjgX6K7U+M/T7HEmIOBQOzQEJ5957TUuM=";
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

      matklad.rust-analyzer = callPackage ./rust-analyzer { };

      ocamllabs.ocaml-platform = buildVscodeMarketplaceExtension {
        meta = with lib; {
          changelog = "https://marketplace.visualstudio.com/items/ocamllabs.ocaml-platform/changelog";
          description = "Official OCaml Support from OCamlLabs";
          downloadPage = "https://marketplace.visualstudio.com/items?itemName=ocamllabs.ocaml-platform";
          homepage = "https://github.com/ocamllabs/vscode-ocaml-platform";
          license = licenses.isc;
          maintainers = with maintainers; [ ratsclub ];
        };
        mktplcRef = {
          name = "ocaml-platform";
          publisher = "ocamllabs";
          version = "1.8.4";
          sha256 = "sha256-T1eYAuYMv4B7rdECxYzNfIpydjzCDjeo7gmb1uhr6VM=";
        };
      };

      pkief.material-icon-theme = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "material-icon-theme";
          publisher = "PKief";
          version = "4.14.1";
          sha256 = "sha256-OHXi0EfeyKMeFiMU5yg0aDoWds4ED0lb+l6T12XZ3LQ=";
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
          version = "1.12.18";
          sha256 = "104h3qfdn0y4138g3mdw1209qqh3mj3jsdsbzpnw2plk1cmr3nx5";
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
          version = "1.16.1";
          sha256 = "sha256-OTPNbwoQmKd73g8IwLKMIbe6c7E2jKNkzwuBU/f8dmY=";
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
          version = "2.1.7";
          sha256 = "sha256-C0jYDIDBK1JH8eFaFmCUilBXCbU5y2TRF3OZAw9ijoY=";
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

      svelte.svelte-vscode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "svelte-vscode";
          publisher = "svelte";
          version = "105.3.0";
          sha256 = "11plqsj3c4dv0xg2d76pxrcn382qr9wbh1lhln2x8mzv840icvwr";
        };
        meta = {
          license = lib.licenses.mit;
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
          version = "0.18.4";
          sha256 = "00cii58md6v028h0xfvbdjvg3r44451mi0lfmjwiwif5xcw3wnlx";
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

      usernamehw.errorlens = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "errorlens";
          publisher = "usernamehw";
          version = "3.4.1";
          sha256 = "1mr8si7jglpjw8qzl4af1k7r68vz03fpal1dr8i0iy4ly26pz7bh";
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

      vscodevim.vim = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vim";
          publisher = "vscodevim";
          version = "1.21.5";
          sha256 = "1v1xs1wcigisr6xip31i02cfryxrb157sla34y59pwlnhc5x1gny";
        };
        meta = {
          license = lib.licenses.mit;
        };
      };

      vspacecode.vspacecode = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "vspacecode";
          publisher = "VSpaceCode";
          version = "0.10.1";
          sha256 = "sha256-H7SCC/ZhDswMQjLX+qpQa6A1N83MobJRPC4pyIbZ1kA=";
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
          version = "2.15.0";
          sha256 = "0d3b6654cdck1syn74vmmd1jmgkrw5v4c4cyrhdxbhggkip732bc";
        };
        meta = with lib; {
          license = licenses.mit;
        };
      };

      xadillax.viml = buildVscodeMarketplaceExtension {
        mktplcRef = {
          name = "viml";
          publisher = "xadillax";
          version = "1.0.1";
          sha256 = "sha256-mzf2PBSbvmgPjchyKmTaf3nASUi5/S9Djpoeh0y8gH0=";
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
          version = "3.4.0";
          sha256 = "0ihfrsg2sc8d441a2lkc453zbw1jcpadmmkbkaf42x9b9cipd5qb";
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

      WakaTime.vscode-wakatime = callPackage ./wakatime { };

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
    ms-vscode = lib.recursiveUpdate super.ms-vscode { inherit (super.golang) go; };
  };

  # TODO: add overrides overlay, so that we can have a generated.nix
  # then apply extension specific modifcations to packages.

  # overlays will be applied left to right, overrides should come after aliases.
  overlays = lib.optionals (config.allowAliases or true) [ aliases ];

  toFix = lib.foldl' (lib.flip lib.extends) baseExtensions overlays;
in
lib.fix toFix
