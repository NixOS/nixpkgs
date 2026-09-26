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
      propagatedBuildInputs = moduleDeps.${info.pname};

      # some packages have a .Rprofile that tries to activate renv
      # we disable this by removing .Rprofile
      postPatch = ''
        rm -f .Rprofile
      '';
    }
  ) moduleInfo;

  moduleDeps = with customRPackages; {
    jaspAcceptanceSampling = [
      abtest
      BayesFactor
      conting
      ggplot2
      jaspBase
      jaspGraphs
      plyr
      stringr
      vcd
      vcdExtra
      AcceptanceSampling
    ];
    jaspAnova = [
      afex
      BayesFactor
      boot
      car
      colorspace
      emmeans
      effectsize
      ggplot2
      jaspBase
      jaspDescriptives
      jaspGraphs
      jaspTTests
      KernSmooth
      matrixStats
      multcomp
      multcompView
      mvShapiroTest
      onewaytests
      plyr
      stringi
      stringr
      restriktor
    ];
    jaspAudit = [
      bstats
      extraDistr
      ggplot2
      ggrepel
      jaspBase
      jaspGraphs
      jfa
    ];
    jaspBain = [
      bain
      lavaan
      ggplot2
      semPlot
      stringr
      jaspBase
      jaspGraphs
      jaspSem
    ];
    jaspBFF = [
      BFF
      jaspBase
      jaspGraphs
    ];
    jaspBfpack = [
      BFpack
      bain
      ggplot2
      stringr
      coda
      jaspBase
      jaspGraphs
    ];
    jaspBsts = [
      Boom
      bsts
      ggplot2
      jaspBase
      jaspGraphs
      matrixStats
      reshape2
    ];
    jaspCircular = [
      jaspBase
      jaspGraphs
      circular
      ggplot2
    ];
    jaspCochrane = [
      jaspBase
      jaspGraphs
      jaspDescriptives
      jaspMetaAnalysis
    ];
    jaspDescriptives = [
      ggplot2
      ggrepel
      jaspBase
      jaspGraphs
      jaspTTests
      forecast
      flexplot
      ggrain
      ggh4x
      ggpp
      ggtext
      dplyr
      tidyplots
      ggpubr
      forcats
      patchwork
    ];
    jaspDistributions = [
      car
      fitdistrplus
      ggplot2
      goftest
      gnorm
      jaspBase
      jaspGraphs
      MASS
      nortest
      sgt
      sn
      DistributionS7
    ];
    jaspEquivalenceTTests = [
      BayesFactor
      ggplot2
      jaspBase
      jaspGraphs
      metaBMA
      TOSTER
      jaspTTests
    ];
    jaspEsci = [
      jaspBase
      jaspGraphs
      esci
      glue
      vdiffr
      legendry
    ];
    jaspFactor = [
      ggplot2
      jaspBase
      jaspGraphs
      jaspSem
      lavaan
      psych
      qgraph
      reshape2
      semPlot
      GPArotation
      Rcsdp
      semTools
    ];
    jaspFrequencies = [
      abtest
      BayesFactor
      bridgesampling
      conting
      multibridge
      ggplot2
      interp
      jaspBase
      jaspGraphs
      plyr
      stringr
      vcd
      vcdExtra
    ];
    jaspJags = [
      coda
      ggplot2
      ggtext
      hexbin
      jaspBase
      jaspGraphs
      rjags
      runjags
      scales
      stringr
    ];
    jaspLearnBayes = [
      extraDistr
      ggplot2
      HDInterval
      jaspBase
      jaspGraphs
      MASS
      MCMCpack
      MGLM
      scales
      ggalluvial
      ragg
      rjags
      runjags
      ggdist
      png
      posterior
    ];
    jaspLearnStats = [
      extraDistr
      ggplot2
      jaspBase
      jaspGraphs
      jaspDistributions
      jaspDescriptives
      jaspTTests
      ggforce
      tidyr
      igraph
      HDInterval
      metafor
    ];
    jaspMachineLearning = [
      kknn
      AUC
      cluster
      colorspace
      DALEX
      dbscan
      e1071
      fpc
      gbm
      Gmedian
      ggparty
      ggdendro
      ggnetwork
      ggplot2
      ggrepel
      ggridges
      glmnet
      jaspBase
      jaspGraphs
      MASS
      mclust
      mvnormalTest
      neuralnet
      network
      partykit
      plyr
      randomForest
      rpart
      ROCR
      Rtsne
      signal
      VGAM
    ];
    jaspMetaAnalysis = [
      dplyr
      ggplot2
      jaspBase
      jaspGraphs
      jaspSem
      MASS
      metaBMA
      metafor
      metaSEM
      psych
      purrr
      rstan
      stringr
      tibble
      tidyr
      weightr
      BayesTools
      RoBMA
      metamisc
      ggmcmc
      pema
      clubSandwich
      CompQuadForm
      sp
      dfoptim
      nleqslv
      patchwork
    ];
    jaspMixedModels = [
      afex
      emmeans
      ggplot2
      jaspBase
      jaspGraphs
      lme4
      loo
      mgcv
      rstan
      rstanarm
      stanova
      withr
    ];
    jaspNetwork = [
      bootnet
      easybgm
      corpcor
      dplyr
      foreach
      ggplot2
      gtools
      HDInterval
      huge
      IsingSampler
      jaspBase
      jaspGraphs
      mvtnorm
      qgraph
      reshape2
      snow
      stringr
    ];
    jaspPower = [
      pwr
      jaspBase
      jaspGraphs
      viridis
    ];
    jaspPredictiveAnalytics = [
      jaspBase
      jaspGraphs
      bsts
      bssm
      precrec
      reshape2
      Boom
      lubridate
      prophet
      BART
      EBMAforecast
      imputeTS
      scoringRules
      scoringutils
    ];
    jaspProcess = [
      blavaan
      dagitty
      ggplot2
      ggraph
      jaspBase
      jaspGraphs
      jaspJags
      runjags
    ];
    jaspProphet = [
      rstan
      ggplot2
      jaspBase
      jaspGraphs
      prophet
      scales
    ];
    jaspQualityControl = [
      car
      cowplot
      daewr
      desirability
      DoE_base
      EnvStats
      FAdist
      fitdistrplus
      FrF2
      ggplot2
      ggrepel
      goftest
      ggpp
      irr
      jaspBase
      jaspDescriptives
      jaspGraphs
      mle_tools
      psych
      qcc
      rsm
      Rspc
      tidyr
      tibble
      vipor
      weibullness
      flexsurv
    ];
    jaspRegression = [
      BAS
      boot
      bstats
      combinat
      emmeans
      ggplot2
      ggrepel
      jaspAnova
      jaspBase
      jaspDescriptives
      jaspGraphs
      jaspTTests
      lmtest
      logistf
      MASS
      matrixStats
      mdscore
      ppcor
      purrr
      Rcpp
      statmod
      VGAM
    ];
    jaspReliability = [
      Bayesrel
      coda
      ggplot2
      ggridges
      irr
      jaspBase
      jaspGraphs
      LaplacesDemon
      lme4
      MASS
      psych
      mirt
    ];
    jaspRobustTTests = [
      RoBTT
      ggplot2
      jaspBase
      jaspGraphs
    ];
    jaspSem = [
      forcats
      ggplot2
      lavaan
      cSEM
      reshape2
      jaspBase
      jaspGraphs
      semPlot
      semTools
      stringr
      tibble
      tidyr
      SEMsens
      mxsem
      OpenMx
    ];
    jaspSummaryStatistics = [
      BayesFactor
      bstats
      jaspBase
      jaspFrequencies
      jaspGraphs
      jaspRegression
      jaspTTests
      jaspAnova
      jaspDescriptives
      SuppDists
      bayesplay
    ];
    jaspSurvival = [
      survival
      ggsurvfit
      flexsurv
      jaspBase
      jaspGraphs
    ];
    jaspTTests = [
      BayesFactor
      car
      ggplot2
      jaspBase
      jaspGraphs
      logspline
      plotrix
      plyr
    ];
    jaspTestModule = [
      jaspBase
      jaspGraphs
      svglite
      stringi
    ];
    jaspTimeSeries = [
      jaspBase
      jaspGraphs
      jaspDescriptives
      forecast
    ];
    jaspVisualModeling = [
      flexplot
      jaspBase
      jaspGraphs
      jaspDescriptives
    ];
  };
in
assert (
  lib.sort lib.lessThan (lib.attrNames jaspModules)
  == lib.sort lib.lessThan (lib.attrNames moduleInfo)
);
{
  inherit customRPackages jaspModules;
}
