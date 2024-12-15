{
  rPackages,
  fetchFromGitHub,
  jasp-src,
  jasp-version,
}:

with rPackages;
let
  jaspColumnEncoder-src = fetchFromGitHub {
    owner = "jasp-stats";
    repo = "jaspColumnEncoder";
    rev = "c54987bb25de8963866ae69ad3a6ae5a9a9f1240";
    hash = "sha256-aWfRG7DXO1MYFvmMLkX/xtHvGeIhFRcRDrVBrhkvYuI=";
  };

  jaspGraphs = buildRPackage {
    name = "jaspGraphs-${jasp-version}";
    version = jasp-version;

    src = jasp-src;
    sourceRoot = "${jasp-src.name}/Engine/jaspGraphs";

    propagatedBuildInputs = [
      ggplot2
      gridExtra
      gtable
      lifecycle
      jsonlite
      R6
      RColorBrewer
      rlang
      scales
      viridisLite
    ];
  };

  jaspBase = buildRPackage {
    name = "jaspBase-${jasp-version}";
    version = jasp-version;

    src = jasp-src;
    sourceRoot = "${jasp-src.name}/Engine/jaspBase";

    env.INCLUDE_DIR = "../inst/include/jaspColumnEncoder";

    # necessary for R 4.4.0
    hardeningDisable = [ "format" ];

    postPatch = ''
      mkdir -p inst/include
      cp -r --no-preserve=all ${jaspColumnEncoder-src} inst/include/jaspColumnEncoder
    '';

    propagatedBuildInputs = [
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
    name = "stanova";
    src = fetchFromGitHub {
      owner = "bayesstuff";
      repo = "stanova";
      rev = "988ad8e07cda1674b881570a85502be7795fbd4e";
      hash = "sha256-tAeHqTHao2KVRNFBDWmuF++H31aNN6O1ss1Io500QBY=";
    };
    propagatedBuildInputs = [
      emmeans
      lme4
      coda
      rstan
      MASS
    ];
  };

  bstats = buildRPackage {
    name = "bstats";
    src = fetchFromGitHub {
      owner = "AlexanderLyNL";
      repo = "bstats";
      rev = "42d34c18df08d233825bae34fdc0dfa0cd70ce8c";
      hash = "sha256-N2KmbTPbyvzsZTWBRE2x7bteccnzokUWDOB4mOWUdJk=";
    };
    propagatedBuildInputs = [
      hypergeo
      purrr
      SuppDists
    ];
  };

  flexplot = buildRPackage {
    name = "flexplot";
    src = fetchFromGitHub {
      owner = "dustinfife";
      repo = "flexplot";
      rev = "303a03968f677e71c99a5e22f6352c0811b7b2fb";
      hash = "sha256-iT5CdtNk0Oi8gga76L6YtyWGACAwpN8A/yTBy7JJERc=";
    };
    propagatedBuildInputs = [
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
  conting' = buildRPackage {
    name = "conting";
    src = fetchFromGitHub {
      owner = "vandenman";
      repo = "conting";
      rev = "03a4eb9a687e015d602022a01d4e638324c110c8";
      hash = "sha256-Sp09YZz1WGyefn31Zy1qGufoKjtuEEZHO+wJvoLArf0=";
    };
    propagatedBuildInputs = [
      mvtnorm
      gtools
      tseries
      coda
    ];
  };

  buildJaspModule =
    name: deps:
    buildRPackage {
      name = "${name}-${jasp-version}";
      version = jasp-version;
      src = jasp-src;
      sourceRoot = "${jasp-src.name}/Modules/${name}";
      propagatedBuildInputs = deps;
    };
in
{
  engine = {
    inherit jaspBase jaspGraphs;
  };

  modules = rec {
    jaspAcceptanceSampling = buildJaspModule "jaspAcceptanceSampling" [
      abtest
      BayesFactor
      conting'
      ggplot2
      jaspBase
      jaspGraphs
      plyr
      stringr
      vcd
      vcdExtra
      AcceptanceSampling
    ];
    jaspAnova = buildJaspModule "jaspAnova" [
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
    jaspAudit = buildJaspModule "jaspAudit" [
      bstats
      extraDistr
      ggplot2
      ggrepel
      jaspBase
      jaspGraphs
      jfa
    ];
    jaspBain = buildJaspModule "jaspBain" [
      bain
      lavaan
      ggplot2
      semPlot
      stringr
      jaspBase
      jaspGraphs
      jaspSem
    ];
    jaspBsts = buildJaspModule "jaspBsts" [
      Boom
      bsts
      ggplot2
      jaspBase
      jaspGraphs
      matrixStats
      reshape2
    ];
    jaspCircular = buildJaspModule "jaspCircular" [
      jaspBase
      jaspGraphs
      circular
      ggplot2
    ];
    jaspCochrane = buildJaspModule "jaspCochrane" [
      jaspBase
      jaspGraphs
      jaspDescriptives
      jaspMetaAnalysis
    ];
    jaspDescriptives = buildJaspModule "jaspDescriptives" [
      ggplot2
      ggrepel
      jaspBase
      jaspGraphs
      jaspTTests
      forecast
      flexplot
      ggrain
      ggpp
      ggtext
      dplyr
    ];
    jaspDistributions = buildJaspModule "jaspDistributions" [
      car
      fitdistrplus
      ggplot2
      goftest
      gnorm
      jaspBase
      jaspGraphs
      MASS
      sgt
      sn
    ];
    jaspEquivalenceTTests = buildJaspModule "jaspEquivalenceTTests" [
      BayesFactor
      ggplot2
      jaspBase
      jaspGraphs
      metaBMA
      TOSTER
      jaspTTests
    ];
    jaspFactor = buildJaspModule "jaspFactor" [
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
    jaspFrequencies = buildJaspModule "jaspFrequencies" [
      abtest
      BayesFactor
      bridgesampling
      conting'
      multibridge
      ggplot2
      jaspBase
      jaspGraphs
      plyr
      stringr
      vcd
      vcdExtra
    ];
    jaspJags = buildJaspModule "jaspJags" [
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
    jaspLearnBayes = buildJaspModule "jaspLearnBayes" [
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
    jaspLearnStats = buildJaspModule "jaspLearnStats" [
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
    ];
    jaspMachineLearning = buildJaspModule "jaspMachineLearning" [
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
    ];
    jaspMetaAnalysis = buildJaspModule "jaspMetaAnalysis" [
      dplyr
      ggplot2
      jaspBase
      jaspGraphs
      MASS
      metaBMA
      metafor
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
    ];
    jaspMixedModels = buildJaspModule "jaspMixedModels" [
      afex
      emmeans
      ggplot2
      ggpol
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
    jaspNetwork = buildJaspModule "jaspNetwork" [
      bootnet
      BDgraph
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
    jaspPower = buildJaspModule "jaspPower" [
      pwr
      jaspBase
      jaspGraphs
    ];
    jaspPredictiveAnalytics = buildJaspModule "jaspPredictiveAnalytics" [
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
    ];
    jaspProcess = buildJaspModule "jaspProcess" [
      blavaan
      dagitty
      ggplot2
      ggraph
      jaspBase
      jaspGraphs
      jaspJags
      runjags
    ];
    jaspProphet = buildJaspModule "jaspProphet" [
      rstan
      ggplot2
      jaspBase
      jaspGraphs
      prophet
      scales
    ];
    jaspQualityControl = buildJaspModule "jaspQualityControl" [
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
    ];
    jaspRegression = buildJaspModule "jaspRegression" [
      BAS
      boot
      bstats
      combinat
      emmeans
      ggplot2
      ggrepel
      hmeasure
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
    jaspReliability = buildJaspModule "jaspReliability" [
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
    ];
    jaspRobustTTests = buildJaspModule "jaspRobustTTests" [
      RoBTT
      ggplot2
      jaspBase
      jaspGraphs
    ];
    jaspSem = buildJaspModule "jaspSem" [
      forcats
      ggplot2
      jaspBase
      jaspGraphs
      lavaan
      cSEM
      reshape2
      semPlot
      semTools
      stringr
      tibble
      tidyr
    ];
    jaspSummaryStatistics = buildJaspModule "jaspSummaryStatistics" [
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
    jaspSurvival = buildJaspModule "jaspSurvival" [
      survival
      survminer
      jaspBase
      jaspGraphs
    ];
    jaspTTests = buildJaspModule "jaspTTests" [
      BayesFactor
      car
      ggplot2
      jaspBase
      jaspGraphs
      logspline
      plotrix
      plyr
    ];
    jaspTimeSeries = buildJaspModule "jaspTimeSeries" [
      jaspBase
      jaspGraphs
      jaspDescriptives
      forecast
    ];
    jaspVisualModeling = buildJaspModule "jaspVisualModeling" [
      flexplot
      jaspBase
      jaspGraphs
      jaspDescriptives
    ];
  };
}
