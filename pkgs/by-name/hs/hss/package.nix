{
  lib,
  buildRubyGem,
  ruby,
  openssh,
}:

# Example ~/.hss.yml
#---
#patterns:
#  - note: Basic test
#    example: g -> github
#    short: '^g$'
#    long: 'git@github.com'

buildRubyGem rec {
  name = "hss-${version}";
  inherit ruby;
  gemName = "hss";
  version = "1.0.1";
  source.sha256 = "0hdfpxxqsh6gisn8mm0knsl1aig9fir0h2x9sirk3gr36qbz5xa4";

  postInstall = ''
    substituteInPlace $GEM_HOME/gems/${gemName}-${version}/bin/hss \
      --replace \
        "'ssh'" \
        "'${openssh}/bin/ssh'"
  '';

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = ''
      A SSH helper that uses regex and fancy expansion to dynamically manage SSH shortcuts.
    '';
    homepage = "https://github.com/akerl/hss";
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nixy ];
    platforms = lib.platforms.unix;
=======
    license = licenses.mit;
    maintainers = with maintainers; [ nixy ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "hss";
  };
}
