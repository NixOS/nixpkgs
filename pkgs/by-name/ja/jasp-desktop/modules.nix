{
  rPackages,
  fetchFromGitHub,
  jasp-src,
  jasp-version,
}:

with rPackages;
let
  jaspGraphs = buildRPackage rec {
    pname = "jaspGraphs";
    version = "0.95.3";

    src = fetchFromGitHub {
      owner = "jasp-stats";
      repo = "jaspGraphs";
      tag = "v${version}";
      hash = "sha256-h2jYFtMFGbaIO1Ed75I2Q0+ut0bR8zBaZ3RZWcTpxMs=";
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

  jaspBase = buildRPackage {
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

  stanova = buildRPackage {
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

  bstats = buildRPackage {
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

  flexplot = buildRPackage {
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
  conting' = buildRPackage {
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
      rev ? "refs/tags/v${version}",
      hash,
      deps,
    }:
    buildRPackage {
      inherit pname version;
      src = fetchFromGitHub {
        name = "${pname}-${version}-source";
        owner = "jasp-stats";
        repo = pname;
        inherit rev hash;
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
      version = "0.95.3";
      hash = "sha256-Z0NyUPAmgCYC3+w2JX2vSmkyFWdJERd5NckXfF46n5o=";
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
      version = "0.95.3";
      hash = "sha256-d0m/mGyRkcBlk3961lafQ+X10yTvsWvQnExVDraW28M=";
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
      version = "0.95.3";
      hash = "sha256-XnQFmf5xdUqClpaJ6Qz0zJAHs1ieeYd4nffxDKX7ReE=";
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
      version = "0.95.3";
      hash = "sha256-kt0s2VJQGhVeD+ALY4FTtU1+7hYw81cXM1WvJ99lnZQ=";
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
      version = "0.95.3";
      hash = "sha256-E+CYTFfiAM7Fng4vY39cceU2IUFcXKn+uejLufnwcOc=";
      deps = [
        BFF
        jaspBase
        jaspGraphs
      ];
    };
    jaspBfpack = buildJaspModule {
      pname = "jaspBfpack";
      version = "0.95.3";
      hash = "sha256-9biiB/m8QsSjlAheoo3hllxYyAIgoeEb1W0KXUEa5C8=";
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
      version = "0.95.3";
      hash = "sha256-TJi0fqZ3abV9mM9XyRiuQfK1tkOJ7VluyKilUdHHj0Y=";
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
      version = "0.95.3";
      hash = "sha256-L3WVErysIMtRLDRzaRd+MCYL9smzWERMTiyzrPHGPjQ=";
      deps = [
        jaspBase
        jaspGraphs
        circular
        ggplot2
      ];
    };
    jaspCochrane = buildJaspModule {
      pname = "jaspCochrane";
      version = "0.95.3";
      hash = "sha256-MAIj0ThgUdo07gHBs0a5tzEsJTrtPS3XnyW2Wj+xp3g=";
      deps = [
        jaspBase
        jaspGraphs
        jaspDescriptives
        jaspMetaAnalysis
      ];
    };
    jaspDescriptives = buildJaspModule {
      pname = "jaspDescriptives";
      version = "0.95.3";
      hash = "sha256-W4LWha+GTVSrOAJLIv9Uy3wOnyHxoT0O/yxj9Zw8/Tg=";
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
      version = "0.95.3";
      hash = "sha256-EutMd5cD3jEW/3e3Ch9IClo1LaNsuvmnvh9cy8hG5Bc=";
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
      version = "0.95.3";
      hash = "sha256-cTVPephc/9IIJ8eUP3Ma1d215E6bI1MOWtlQDGqPN70=";
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
      version = "0.95.3";
      hash = "sha256-wgbp1iZRWfm6dRVkVhK6iC0hHu73pFm3Hk9pN7Z6ej8=";
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
      version = "0.95.3";
      hash = "sha256-1e4HYst/G5JqN7fksFR907LqysdyTCcUXLgRfiSBCd0=";
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
      version = "0.95.3";
      hash = "sha256-3JznrmKqAJJop57gNQw7eOLjbS7B41AriUdZTttoSkM=";
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
      version = "0.95.3";
      hash = "sha256-wZsc3NSiNKa35R7c/mrnp+crA8OkNk/2JRiiEW8DZq4=";
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
      version = "0.95.3";
      hash = "sha256-YRzoF4FrPrSeDcKq7V9N8FcNtCKZ4n5e2O9u9aseAik=";
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
      version = "0.95.3";
      hash = "sha256-PSrLmRlvd0U7hkFXRvzi5hFz7/Czj3iOSdWyGGoOHVI=";
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
      version = "0.95.3";
      hash = "sha256-ZZKEO+FMx5uycD1JBln6HG5qLqbzRCnr/B2/yDUqhYs=";
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
      version = "0.95.3";
      hash = "sha256-JxO3jvEVcYIkOPncCYLHJFbu0i2HYx7ltqEBzSNKRjM=";
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
      version = "0.95.3";
      hash = "sha256-rc0l9aYKVjpSruxutYxYHLRmDN045fBYXD3itKbzDYA=";
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
      version = "0.95.3";
      hash = "sha256-16qRhOgzFRgbImeIfTKZJyn8ZlGnohPp4/whabdDHeM=";
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
      version = "0.95.3";
      hash = "sha256-2PrPaksHMAFVYCPN+xigLDSyALarzrO4FTylMmi4+vk=";
      deps = [
        pwr
        jaspBase
        jaspGraphs
        viridis
      ];
    };
    jaspPredictiveAnalytics = buildJaspModule {
      pname = "jaspPredictiveAnalytics";
      version = "0.95.3";
      hash = "sha256-mQx/LsFDaD9zS2DqqiXfFNT019/J3HPdNsPzxWn2Pwc=";
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
      version = "0.95.3";
      hash = "sha256-wWMpqOXOKEx3z0juBXfnfJvbKCeI+H/Wnhh24dNWJWw=";
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
      version = "0.95.3";
      hash = "sha256-AOm0oNqCHmkUdhC8Cqb4O9HkUoC9L8TFaSNcZ/DzoYQ=";
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
      version = "0.95.3";
      hash = "sha256-zFxC3icKd84jjilwZBCe7JRV8S1eb4AO8UyBENXsF/U=";
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
      version = "0.95.3";
      rev = "b0ecad26bb248964e778ee6d4486d671b83930b2";
      hash = "sha256-wm/Fz/wA7B96bzj8UylZjFgrrZgwOTdGnCsmfaCPGp0=";
      deps = [
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
    };
    jaspReliability = buildJaspModule {
      pname = "jaspReliability";
      version = "0.95.3";
      hash = "sha256-80G8Z8JWxwyAer1GsQgzytEcSquCBW8Zmu92KKiHu1I=";
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
      version = "0.95.3";
      hash = "sha256-txcItwNHq41ifdjvyY9Jhp2sfHJYA/YStTxpyk/lUPQ=";
      deps = [
        RoBTT
        ggplot2
        jaspBase
        jaspGraphs
      ];
    };
    jaspSem = buildJaspModule {
      pname = "jaspSem";
      version = "0.95.3";
      hash = "sha256-QI1OGAfyBJ9p3Nb/sI3A5sISXc4ZpsN1sPaJL/3chP8=";
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
      version = "0.95.3";
      hash = "sha256-6OEnYhp4NBd8mr518Mz63F7eZ297unDRYLiOoWzlAbc=";
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
      version = "0.95.3";
      hash = "sha256-rrbzd8Iws7lhKPJGRtFLuFgRkqHa8B0R6ZH/HdHDk44=";
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
      version = "0.95.3";
      hash = "sha256-yuNLBi56qKCTCh/UNoYjA7YlyL/1B0QXsgN4C8SzQbs=";
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
      version = "0.95.3";
      hash = "sha256-kzwGm4hHkO1+mzmCl792oDQimJrsw4xIhd+e91PrOMg=";
      deps = [
        jaspBase
        jaspGraphs
        svglite
        stringi
      ];
    };
    jaspTimeSeries = buildJaspModule {
      pname = "jaspTimeSeries";
      version = "0.95.3";
      hash = "sha256-qOrLihjSH7cEazTiFJZIfMe9uGZ6ltZ3uMm+1fwPN7E=";
      deps = [
        jaspBase
        jaspGraphs
        jaspDescriptives
        forecast
      ];
    };
    jaspVisualModeling = buildJaspModule {
      pname = "jaspVisualModeling";
      version = "0.95.3";
      hash = "sha256-KwFfgwBlukRmSltHt1LVzIMB/x2iCvRMc/Rrhmmxw98=";
      deps = [
        flexplot
        jaspBase
        jaspGraphs
        jaspDescriptives
      ];
    };
  };
}
