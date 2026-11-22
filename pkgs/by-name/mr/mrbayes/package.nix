{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mrbayes";
  version = "3.2.7a";

  src = fetchFromGitHub {
    owner = "NBISweden";
    repo = "MrBayes";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-pkkxZ6YHRn/I1SJpT9A+EK4S5hWGmFdcDBJS0zh5mLA=";
  };

  meta = {
    description = "Bayesian Inference of Phylogeny";
    mainProgram = "mb";
    longDescription = ''
      Bayesian inference of phylogeny is based upon a
      quantity called the posterior probability distribution of trees, which is
      the probability of a tree conditioned on the observations. The conditioning
      is accomplished using Bayes's theorem. The posterior probability
      distribution of trees is impossible to calculate analytically; instead,
      MrBayes uses a simulation technique called Markov chain Monte Carlo (or
      MCMC) to approximate the posterior probabilities of trees.
    '';
    maintainers = [ ];
    license = lib.licenses.gpl2Plus;
    homepage = "https://nbisweden.github.io/MrBayes/";
    platforms = lib.platforms.linux;
  };
})
