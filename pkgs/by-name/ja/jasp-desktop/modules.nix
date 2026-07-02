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
    version = "0.26.3";

    src = fetchFromGitHub {
      owner = "dustinfife";
      repo = "flexplot";
      rev = "cae36ba45502ce1794ad35cfeaf0155275db3056";
      hash = "sha256-aOCYy21EQ/lGDWQvkGAspTSZiJif8mlS2lCwS180dUA=";
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
      version = "0.96.0";
      hash = "sha256-sbLzTuGr7r/OsIMliOfvwVsmgUgZxL+6rqiq4W+BIBc=";
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
      version = "0.96.0";
      hash = "sha256-K695RXTxzbYVF+gh8gzFTsceTTNdx976yF6WiPHm3No=";
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
      version = "0.96.0";
      hash = "sha256-1j6Na7Ikk8XJQjbTRRuK28K3jMVdUVe0FwTzo5ywppY=";
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
      version = "0.96.0";
      hash = "sha256-CcelkJJD/rr5BOx8MaCkHfbUKp7/tvWOSSC+Ilsopc8=";
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
      version = "0.96.0";
      hash = "sha256-bh3uLZcjfYpwaNmEzqVW5eNdPFq/Ig3bh7+1DgXYoF8=";
      deps = [
        BFF
        jaspBase
        jaspGraphs
      ];
    };
    jaspBfpack = buildJaspModule {
      pname = "jaspBfpack";
      version = "0.96.0";
      hash = "sha256-S1lKrMC6BG6cjJWuxVYVtUciZIeePX0Nx/IvwCjixHY=";
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
      version = "0.96.0";
      hash = "sha256-sFbn0yOr7ZaaO2APYNOshBcs1zvgIZUT89BvdRrN/+4=";
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
      version = "0.96.0";
      hash = "sha256-fqBSR/um02+BXuu7gucd7WWG/RSOeLmhXHQl2wXiVGw=";
      deps = [
        jaspBase
        jaspGraphs
        circular
        ggplot2
      ];
    };
    jaspCochrane = buildJaspModule {
      pname = "jaspCochrane";
      version = "0.96.0";
      hash = "sha256-z6rglW4wItG9akHWplpDBzB5yzRko/ze+DcQotJmHTg=";
      deps = [
        jaspBase
        jaspGraphs
        jaspDescriptives
        jaspMetaAnalysis
      ];
    };
    jaspDescriptives = buildJaspModule {
      pname = "jaspDescriptives";
      version = "0.96.0";
      hash = "sha256-cJCTglQhU5fCH7henOKA0h39VuA07zVVfATtuct8tqY=";
      deps = [
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
    };

    jaspDistributions = buildJaspModule {
      pname = "jaspDistributions";
      version = "0.96.0";
      hash = "sha256-uZWCVCOFfNkLNjJJ82x4H5rKH1m7KE3UDX1p/7dn4uY=";
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
      version = "0.96.0";
      hash = "sha256-4XFN6ikBfOZWHMTLbNPBwgMoYiLVULQE0XyNaoPQ40k=";
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
      version = "0.96.0";
      hash = "sha256-pH1neP1GmL3usXP5ycQKGeLNzvfMV/UBrrKF718QaGI=";
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
      version = "0.96.0";
      hash = "sha256-AU9nTrxZNseN0Wsp3932V3N+ax5CzfJMoEB128AR5LM=";
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
      version = "0.96.0";
      hash = "sha256-qolgiJjiODzheW04fXdtxNqAreEny7ln+GlwV4ztRik=";
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
      version = "0.96.0";
      hash = "sha256-f26njMClIUWNc4fGsPgwitzKbqdU6Ld+Ys6ukWAHE/M=";
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
      version = "0.96.0";
      hash = "sha256-zqMcWFML/iexmegMtGWCe/OCGqwmWW98/XZfKVs6N8w=";
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
      version = "0.96.0";
      hash = "sha256-Yvqhv269Uvr087IjiGMBzTHZj+4Wu5A8dN/F9+8odqY=";
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
      version = "0.96.0";
      hash = "sha256-Wg1C/ZJL98U8JkMfeZcc4/83DmCHRYOIn2OglsMqImw=";
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
      version = "0.96.0";
      hash = "sha256-bXHlYiGEtNMqr833ve3Qrdv+TCm7G4let07McMETUv8=";
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
      version = "0.96.0";
      hash = "sha256-F7NEyqA+vW+66l/ZmWaVvTSbG+0fxI+SsgfV6GmwJLs=";
      deps = [
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
    };
    jaspNetwork = buildJaspModule {
      pname = "jaspNetwork";
      version = "0.96.0";
      hash = "sha256-alF9pDjBqrJvqDaJIOf9F/SWu/wrmspSFY/chE8/U9k=";
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
      version = "0.96.0";
      hash = "sha256-Q5CBXoHr6jPs/UNMpyQXzhMm5a48G8LTYr37VKfzrrc=";
      deps = [
        pwr
        jaspBase
        jaspGraphs
        viridis
      ];
    };
    jaspPredictiveAnalytics = buildJaspModule {
      pname = "jaspPredictiveAnalytics";
      version = "0.96.0";
      hash = "sha256-CrpozVhA+vTv15dWUH9CqK37BdO7okE8XML6BYRsoYw=";
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
      version = "0.96.0";
      hash = "sha256-ZO3Y+3qA84s0wUdL9iRqnc4vljzg69crH34eCbGWmOo=";
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
      version = "0.96.0";
      hash = "sha256-rEBXWEVpavXiMljtvNfKLVvI8VIaTk+yymaGx4w/li8=";
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
      version = "0.96.0";
      hash = "sha256-5DNz827MZHfmLnFXNUTFweMmOdDftxm6S8ZJwzCCDa8=";
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
        flexsurv
      ];
    };
    jaspRegression = buildJaspModule {
      pname = "jaspRegression";
      version = "0.96.0";
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
      version = "0.96.0";
      hash = "sha256-WZW9CAAKdEYUTwGC1zmtChvntgRTkLL6xwrpukDoqSo=";
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
      version = "0.96.0";
      hash = "sha256-U6qH0tKC7lLFvnTGK9mNli7Azh/SA6pUEJdsUoOCsYo=";
      deps = [
        RoBTT
        ggplot2
        jaspBase
        jaspGraphs
      ];
    };
    jaspSem = buildJaspModule {
      pname = "jaspSem";
      version = "0.96.0";
      hash = "sha256-acSH/0IbqDxSOZi30zBjDgU3I6jxUYCgVG9B7dbkAh8=";
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
        mxsem
        OpenMx
      ];
    };
    jaspSummaryStatistics = buildJaspModule {
      pname = "jaspSummaryStatistics";
      version = "0.96.0";
      hash = "sha256-UuC26atGRnRHwp1xhAJtj5vkdPvYjcs2WIPgAq/0Uvg=";
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
      version = "0.96.0";
      hash = "sha256-P652YSopruDje69vXfeBMSBMU/GPmYCuRp7jd2ZneEI=";
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
      version = "0.96.0";
      hash = "sha256-K1thMejBibf8nzP07QbKyS/j3FbbrGQNPdiBpkhKf1w=";
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
      version = "0.96.0";
      hash = "sha256-FZEEa1n7B9Kt74L7dw+oYWmHBGobI78wUBzQ1wsKos8=";
      deps = [
        jaspBase
        jaspGraphs
        jaspDescriptives
        forecast
      ];
    };
    jaspVisualModeling = buildJaspModule {
      pname = "jaspVisualModeling";
      version = "0.96.0";
      hash = "sha256-lhvH69LUIzXsFQ730hqcWnkTK0aeMhal3VhSTrr4eHc=";
      deps = [
        flexplot
        jaspBase
        jaspGraphs
        jaspDescriptives
      ];
    };
  };
}
