{ lib
, trivialBuild
, fetchFromGitHub
, emacs
}:

trivialBuild {
  pname = "railgun";
  version= "0.pre+unstable=2012-10-17";

  src = fetchFromGitHub {
    owner = "mbriggs";
    repo = "railgun.el";
    rev = "66aaa1b091baef53a69d0d7425f48d184b865fb8";
    hash = "sha256-0L+jFgrXEPMTptx53RDdyH4BiA+7uInHceXL0eROoAM=";
  };

  buildInputs = [ emacs ];

  meta = with lib; {
    homepage = "https://github.com/mbriggs/railgun.el";
    description = "Propel yourself through a rails project with the power of magnets";
    inherit (emacs.meta) platforms;
  };
}
