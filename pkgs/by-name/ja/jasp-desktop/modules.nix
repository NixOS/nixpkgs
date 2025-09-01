{
  rPackages,
  fetchFromGitHub,
  jasp-src,
  jasp-version,
}:

with rPackages;
let
  buildRPackage' = args: buildRPackage ({ name = "${args.pname}-${args.version}"; } // args);

  jaspGraphs = buildRPackage' {
    pname = "jaspGraphs";
    version = "0.19.2-unstable-2025-07-25";

    src = fetchFromGitHub {
      owner = "jasp-stats";
      repo = "jaspGraphs";
      rev = "e721a631c8357d42c1371a978db7cb5765bc7044";
      hash = "sha256-DOOKHBVTF9bVhAa/LZCH1J7A821H4mGEfy6KAEtDBNk=";
    };

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

  jaspColumnEncoder-src = fetchFromGitHub {
    owner = "jasp-stats";
    repo = "jaspColumnEncoder";
    rev = "32c53153da95087feb109c0f5f69534ffa3f32b7";
    hash = "sha256-VOMcoXpLH24auQfZCWW6hQ10u6n2GxuEQHMaXrvGTnI=";
  };

  jaspBase = buildRPackage' {
    pname = "jaspBase";
    version = jasp-version;

    src = jasp-src;
    sourceRoot = "${jasp-src.name}/Engine/jaspBase";

    env.INCLUDE_DIR = "../inst/include/jaspColumnEncoder";

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

  stanova = buildRPackage' {
    pname = "stanova";
    version = "0.3-unstable-2021-06-06";

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

  bstats = buildRPackage' {
    pname = "bstats";
    version = "0.0.0.9004-unstable-2023-09-08";

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

  flexplot = buildRPackage' {
    pname = "flexplot";
    version = "0.25.5";

    src = fetchFromGitHub {
      owner = "dustinfife";
      repo = "flexplot";
      rev = "9a39de871d48364dd5f096b2380a4c9907adf4c3";
      hash = "sha256-yf5wbhfffztT5iF6h/JSg4NSbuaexk+9JEOfT5Is1vE=";
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
  conting' = buildRPackage' {
    pname = "conting";
    version = "1.7.9999";

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
    {
      pname,
      version,
      hash,
      deps,
    }:
    buildRPackage' {
      inherit pname version;
      src = fetchFromGitHub {
        name = "${pname}-${version}-source";
        owner = "jasp-stats";
        repo = pname;
        tag = "v${version}";
        inherit hash;
      };
      propagatedBuildInputs = deps;
      # some packages have a .Rprofile that tries to activate renv
      # we disable this by removing .Rprofile
      postPatch = ''
        rm -f .Rprofile
      '';
    };
in
{
  inherit jaspBase;

  modules = rec {
    jaspAcceptanceSampling = buildJaspModule {
      pname = "jaspAcceptanceSampling";
      version = "0.95.0";
      hash = "sha256-MzuijLBrCd/aIACzyEWWbQoyuYl/c7iMplsIpScbqK4=";
      deps = [
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
    };
    jaspAnova = buildJaspModule {
      pname = "jaspAnova";
      version = "0.95.0";
      hash = "sha256-elunqlNy7krnoL31aeS4B7SkpKCD42S8Z8HsPeFTjEM=";
      deps = [
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
    };
    jaspAudit = buildJaspModule {
      pname = "jaspAudit";
      version = "0.95.0";
      hash = "sha256-CqrjrNm7DEyzOTg69TzksYczGBSCvhHfdfZ/HaNkhcI=";
      deps = [
        bstats
        extraDistr
        ggplot2
        ggrepel
        jaspBase
        jaspGraphs
        jfa
      ];
    };
    jaspBain = buildJaspModule {
      pname = "jaspBain";
      version = "0.95.0";
      hash = "sha256-E6j7dH6jbXWhR03QVQjY30/pylrMHU6PNX13gr5KvV4=";
      deps = [
        bain
        lavaan
        ggplot2
        semPlot
        stringr
        jaspBase
        jaspGraphs
        jaspSem
      ];
    };
    jaspBFF = buildJaspModule {
      pname = "jaspBFF";
      version = "0.95.0";
      hash = "sha256-fgAUdzgSNt34WL/U3/0ac1kTB5PYAvmpXeQUuNEUhuE=";
      deps = [
        BFF
        jaspBase
        jaspGraphs
      ];
    };
    jaspBfpack = buildJaspModule {
      pname = "jaspBfpack";
      version = "0.95.0";
      hash = "sha256-4c7ORf0epHSdv6AB1UVMwiSEwCfVHAg0jzifBdHInoc=";
      deps = [
        BFpack
        bain
        ggplot2
        stringr
        coda
        jaspBase
        jaspGraphs
      ];
    };
    jaspBsts = buildJaspModule {
      pname = "jaspBsts";
      version = "0.95.0";
      hash = "sha256-pClbOuA255mHJSy7/TpQE+oaYQbxJut9AqZRMqm8Rhg=";
      deps = [
        Boom
        bsts
        ggplot2
        jaspBase
        jaspGraphs
        matrixStats
        reshape2
      ];
    };
    jaspCircular = buildJaspModule {
      pname = "jaspCircular";
      version = "0.95.0";
      hash = "sha256-Sx63VGtOZvwHF1jIjnd6aPmN1WtHHf35iQ0dzCWs1eU=";
      deps = [
        jaspBase
        jaspGraphs
        circular
        ggplot2
      ];
    };
    jaspCochrane = buildJaspModule {
      pname = "jaspCochrane";
      version = "0.95.0";
      hash = "sha256-ZYMe1BJ0+HKKyHVY5riEcGE+6vZsAurWzHmPF5I7nk8=";
      deps = [
        jaspBase
        jaspGraphs
        jaspDescriptives
        jaspMetaAnalysis
      ];
    };
    jaspDescriptives = buildJaspModule {
      pname = "jaspDescriptives";
      version = "0.95.0";
      hash = "sha256-gaGgSSv1D0GB8Rmzg9TYl460TjWHkK0abHDm5DHhOJg=";
      deps = [
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
        tidyplots
        ggpubr
        forcats
        patchwork
      ];
    };

    jaspDistributions = buildJaspModule {
      pname = "jaspDistributions";
      version = "0.95.0";
      hash = "sha256-jtPYx2wOAY7ItrkPqyMsKp7sTrL9M1TtTmR0IjxU1nw=";
      deps = [
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
      ];
    };
    jaspEquivalenceTTests = buildJaspModule {
      pname = "jaspEquivalenceTTests";
      version = "0.95.0";
      hash = "sha256-b/I6lb6I8rzOyyRgmsQTBMfHXfJDkrZPdwe5Kh2IVnc=";
      deps = [
        BayesFactor
        ggplot2
        jaspBase
        jaspGraphs
        metaBMA
        TOSTER
        jaspTTests
      ];
    };
    jaspEsci = buildJaspModule {
      pname = "jaspEsci";
      version = "0.95.0";
      hash = "sha256-0YBC54VdVNuGdkfjWEIJnW3n/Wbch4E6tkauVm45/9c=";
      deps = [
        jaspBase
        jaspGraphs
        esci
        glue
        vdiffr
        legendry
      ];
    };
    jaspFactor = buildJaspModule {
      pname = "jaspFactor";
      version = "0.95.0";
      hash = "sha256-gK4GdwADrPt2UB/UUx+2Kx5IOlFolYjNArrYpTGK9ic=";
      deps = [
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
    };
    jaspFrequencies = buildJaspModule {
      pname = "jaspFrequencies";
      version = "0.95.0";
      hash = "sha256-aK4t+q6NRHGiszJa6rWx1bQddxzwynM9TOckxofdgsw";
      deps = [
        abtest
        BayesFactor
        bridgesampling
        conting'
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
    };
    jaspJags = buildJaspModule {
      pname = "jaspJags";
      version = "0.95.0";
      hash = "sha256-DxLy3NgqvLIROBut30ne3hCUd67rCRutgM7zGvwkKNU=";
      deps = [
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
    };
    jaspLearnBayes = buildJaspModule {
      pname = "jaspLearnBayes";
      version = "0.95.0";
      hash = "sha256-mka93YglICKxPXNO85Kv/gzSRAMuTkWcnAlwIExDpi0=";
      deps = [
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
    };
    jaspLearnStats = buildJaspModule {
      pname = "jaspLearnStats";
      version = "0.95.0";
      hash = "sha256-AcdSmAGr1ITZV/OXNpyOz0wwBlho76lvEGgt5FUHnsg=";
      deps = [
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
    };
    jaspMachineLearning = buildJaspModule {
      pname = "jaspMachineLearning";
      version = "0.95.0";
      hash = "sha256-oCsXrcEAteFGfFHU65FV3jm1majA1q1w+TYCwAsvf70=";
      deps = [
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
    };
    jaspMetaAnalysis = buildJaspModule {
      pname = "jaspMetaAnalysis";
      version = "0.95.0";
      hash = "sha256-5zmLCx6HuM/oBxfaAgo4y7/CYJJkiJEP9RvAsc1h/5w=";
      deps = [
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
    };
    jaspMixedModels = buildJaspModule {
      pname = "jaspMixedModels";
      version = "0.95.0";
      hash = "sha256-EbB7rwlfRiGPI+QIi8/SygxJgsU5nOpZ2ZEg+mETX5Y=";
      deps = [
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
    };
    jaspNetwork = buildJaspModule {
      pname = "jaspNetwork";
      version = "0.95.0";
      hash = "sha256-1RDkKRgNV6cToM2pVdHwIDE41UpFV0snIU54BEesVJw=";
      deps = [
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
    };
    jaspPower = buildJaspModule {
      pname = "jaspPower";
      version = "0.95.0";
      hash = "sha256-sLLJ6yqKbFlXrHPlm2G7NuHp+/kBl+kPRvi6vAy32Ds=";
      deps = [
        pwr
        jaspBase
        jaspGraphs
      ];
    };
    jaspPredictiveAnalytics = buildJaspModule {
      pname = "jaspPredictiveAnalytics";
      version = "0.95.0";
      hash = "sha256-850PruQnCGab0g3Vdlh1LSqWYLFJUCbGNt3gWjEWP34=";
      deps = [
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
    };
    jaspProcess = buildJaspModule {
      pname = "jaspProcess";
      version = "0.95.0";
      hash = "sha256-LUlk9Iy538Zenzy+W1oJiCr7dcrBQVrl4gzflwnJVyc=";
      deps = [
        blavaan
        dagitty
        ggplot2
        ggraph
        jaspBase
        jaspGraphs
        jaspJags
        runjags
      ];
    };
    jaspProphet = buildJaspModule {
      pname = "jaspProphet";
      version = "0.95.0";
      hash = "sha256-lCgqH3CfZxRImq5VndZepiy/JaXJHHh1Haj+7XhZUSE=";
      deps = [
        rstan
        ggplot2
        jaspBase
        jaspGraphs
        prophet
        scales
      ];
    };
    jaspQualityControl = buildJaspModule {
      pname = "jaspQualityControl";
      version = "0.95.0";
      hash = "sha256-6SvLe++9ipvHfX0Hi1xeBeoQeq+PdG9YTE5sewhqUHA=";
      deps = [
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
    };
    jaspRegression = buildJaspModule {
      pname = "jaspRegression";
      version = "0.95.0";
      hash = "sha256-9Q5Ei9vjFaDte//1seCj9++ftbDctkHzP8ZpGVETXH0=";
      deps = [
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
    };
    jaspReliability = buildJaspModule {
      pname = "jaspReliability";
      version = "0.95.0";
      hash = "sha256-wxx1ECm7QKDvLLKQZbEVYTHfyn3ieks69HSP/cg5dDQ=";
      deps = [
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
    };
    jaspRobustTTests = buildJaspModule {
      pname = "jaspRobustTTests";
      version = "0.95.0";
      hash = "sha256-nw+7eZycdJ+DHlLaTSBWdHocnaZk95PBqYj8sVFlPSg=";
      deps = [
        RoBTT
        ggplot2
        jaspBase
        jaspGraphs
      ];
    };
    jaspSem = buildJaspModule {
      pname = "jaspSem";
      version = "0.95.0";
      hash = "sha256-+cgP6KqSK4tXQ+Dg6OTEoXfzEJFNdnwAat6tyWyzSkU=";
      deps = [
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
      ];
    };
    jaspSummaryStatistics = buildJaspModule {
      pname = "jaspSummaryStatistics";
      version = "0.95.0";
      hash = "sha256-VuBDJtkDifDeatY3eX5RBd5ix6fB0QnJ1ZoM7am9SOA=";
      deps = [
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
    };
    jaspSurvival = buildJaspModule {
      pname = "jaspSurvival";
      version = "0.95.0";
      hash = "sha256-IVN3Tcd+OgD4pancwyNomQMOfOvUnKIWG/nxKdjNxcw=";
      deps = [
        survival
        ggsurvfit
        flexsurv
        jaspBase
        jaspGraphs
      ];
    };
    jaspTTests = buildJaspModule {
      pname = "jaspTTests";
      version = "0.95.0";
      hash = "sha256-CLrfa5X/q2Ruc+y3ruHnT/NhYQ4ESvxtJCH2JM/hf4o=";
      deps = [
        BayesFactor
        car
        ggplot2
        jaspBase
        jaspGraphs
        logspline
        plotrix
        plyr
      ];
    };
    jaspTestModule = buildJaspModule {
      pname = "jaspTestModule";
      version = "0.95.0";
      hash = "sha256-r+VzUxfvWYl/Fppq/TxCw1jI8F3dohsvb6qwlQHlFDA=";
      deps = [
        jaspBase
        jaspGraphs
        svglite
        stringi
      ];
    };
    jaspTimeSeries = buildJaspModule {
      pname = "jaspTimeSeries";
      version = "0.95.0";
      hash = "sha256-hQh9p6mX3NlkToh4uQRbPtwpNLlVwsILxH+9D2caZXk=";
      deps = [
        jaspBase
        jaspGraphs
        jaspDescriptives
        forecast
      ];
    };
    jaspVisualModeling = buildJaspModule {
      pname = "jaspVisualModeling";
      version = "0.95.0";
      hash = "sha256-MX3NvfVoFPp2NLWYIYIoCdWKHxpcRhfyMCWj3VdIBC0=";
      deps = [
        flexplot
        jaspBase
        jaspGraphs
        jaspDescriptives
      ];
    };
  };
}
