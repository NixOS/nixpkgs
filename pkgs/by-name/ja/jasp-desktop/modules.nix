{
  lib,
  rPackages,
  fetchFromGitHub,
  jasp-src,
  jasp-version,
}:

let
  inherit (rPackages) buildRPackage;
  customRPackages =
    rPackages
    // jaspModules
    // {
      jaspGraphs = buildRPackage rec {
        pname = "jaspGraphs";
        version = "0.96.0";

        src = fetchFromGitHub {
          owner = "jasp-stats";
          repo = "jaspGraphs";
          tag = "v${version}";
          hash = "sha256-aTemaJA3ZitDeYob3QbE4qtjyd5JN0i65OtrpoaopNg=";
        };

        propagatedBuildInputs = with customRPackages; [
          ggplot2
          gridExtra
          gtable
          htmlwidgets
          lifecycle
          jsonlite
          plotly
          R6
          RColorBrewer
          rlang
          scales
          viridisLite
        ];
      };

      jaspBase = buildRPackage {
        pname = "jaspBase";
        version = jasp-version;

        src = jasp-src;
        sourceRoot = "${jasp-src.name}/Engine/jaspBase";

        preConfigure = ''
          mkdir -p ./inst/include/
          cp -r --no-preserve=all ../../Common ./inst/include/Common
          export INCLUDE_DIR=$(pwd)/inst/include/Common/
        '';

        propagatedBuildInputs = with customRPackages; [
          cli
          codetools
          ggplot2
          gridExtra
          gridGraphics
          jaspGraphs
          jsonlite
          lifecycle
          modules
          officer
          pkgbuild
          plyr
          qgraph
          ragg
          R6
          Rcpp
          renv
          remotes
          rjson
          rvg
          svglite
          systemfonts
          withr
        ];
      };

      stanova = buildRPackage {
        pname = "stanova";
        version = "0.3-unstable-2021-06-06";

        src = fetchFromGitHub {
          owner = "bayesstuff";
          repo = "stanova";
          rev = "988ad8e07cda1674b881570a85502be7795fbd4e";
          hash = "sha256-tAeHqTHao2KVRNFBDWmuF++H31aNN6O1ss1Io500QBY=";
        };

        propagatedBuildInputs = with customRPackages; [
          emmeans
          lme4
          coda
          rstan
          MASS
        ];
      };

      bstats = buildRPackage {
        pname = "bstats";
        version = "0.0.0.9004-unstable-2023-09-08";

        src = fetchFromGitHub {
          owner = "AlexanderLyNL";
          repo = "bstats";
          rev = "42d34c18df08d233825bae34fdc0dfa0cd70ce8c";
          hash = "sha256-N2KmbTPbyvzsZTWBRE2x7bteccnzokUWDOB4mOWUdJk=";
        };

        propagatedBuildInputs = with customRPackages; [
          hypergeo
          purrr
          SuppDists
        ];
      };

      flexplot = buildRPackage {
        pname = "flexplot";
        version = "0.26.3";

        src = fetchFromGitHub {
          owner = "dustinfife";
          repo = "flexplot";
          rev = "cae36ba45502ce1794ad35cfeaf0155275db3056";
          hash = "sha256-aOCYy21EQ/lGDWQvkGAspTSZiJif8mlS2lCwS180dUA=";
        };

        propagatedBuildInputs = with customRPackages; [
          cowplot
          MASS
          tibble
          withr
          dplyr
          magrittr
          forcats
          purrr
          plyr
          R6
          ggplot2
          patchwork
          ggsci
          lme4
          party
          mgcv
          rlang
        ];
      };

      # conting has been removed from CRAN
      conting = buildRPackage {
        pname = "conting";
        version = "1.7.9999";

        src = fetchFromGitHub {
          owner = "vandenman";
          repo = "conting";
          rev = "03a4eb9a687e015d602022a01d4e638324c110c8";
          hash = "sha256-Sp09YZz1WGyefn31Zy1qGufoKjtuEEZHO+wJvoLArf0=";
        };

        propagatedBuildInputs = with customRPackages; [
          mvtnorm
          gtools
          tseries
          coda
        ];
      };

      DistributionS7 = buildRPackage {
        pname = "DistributionS7";
        version = "0.1.1";

        src = fetchFromGitHub {
          owner = "Kucharssim";
          repo = "DistributionS7";
          rev = "8c5a709c120abc0f26697c6009769e4c2d889b9b";
          hash = "sha256-9kxo38CpbEMRmeXbrngSZrQ8M9iL9SzV+WDYQitXDvU=";
        };

        postPatch = ''
          rm -f .Rprofile
        '';

        propagatedBuildInputs = with customRPackages; [
          S7
          assertthat
          rlang
          goftest
          nortest
          ggplot2
          ggrepel
          jaspGraphs
          patchwork
          sn
          gnorm
          sgt
          generics
        ];

      };
    };

  moduleInfo = lib.importJSON ./module-info.json;

  jaspModules = lib.mapAttrs (
    name: info:
    buildRPackage {
      inherit (info) pname version;
      src = fetchFromGitHub {
        name = "${info.pname}-${info.version}-source";
        owner = "jasp-stats-modules";
        repo = info.pname;
        tag = info.tag;
        hash = info.hash;
      };
      propagatedBuildInputs = lib.map (dep_name: customRPackages.${dep_name}) info.deps;

      # some packages have a .Rprofile that tries to activate renv
      # we disable this by removing .Rprofile
      postPatch = ''
        rm -f .Rprofile
      '';
    }
  ) moduleInfo;
in
{
  inherit customRPackages jaspModules;
}
