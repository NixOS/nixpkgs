{stdenv, fetchurl, readline}:

stdenv.mkDerivation rec {
  # FIXME: replace Makefile so we can build MPI & MAC support

  name = "mrbayes-3.1.2";
  src = fetchurl {
    url = "mirror://sourceforge/mrbayes/${name}.tar.gz";
    sha256 = "1x7j8ca5wjrqrxmcpvd375ydm3s2pbkzykv8xfhg1jc037g560n6";
  };
  builder = ./builder.sh;
  buildInputs = [readline];

  meta = {
    description     = "Bayesian Inference of Phylogeny";
    longDescription = ''
      Bayesian inference of phylogeny is based upon a
      quantity called the posterior probability distribution of trees, which is
      the probability of a tree conditioned on the observations. The conditioning
      is accomplished using Bayes's theorem. The posterior probability
      distribution of trees is impossible to calculate analytically; instead,
      MrBayes uses a simulation technique called Markov chain Monte Carlo (or
      MCMC) to approximate the posterior probabilities of trees.
    '';
    license     = "GPL2";
    homepage    = http://mrbayes.csit.fsu.edu/;
    platforms = stdenv.lib.platforms.linux;
  };
}
