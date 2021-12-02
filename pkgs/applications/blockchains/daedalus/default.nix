{ fetchFromGitHub, lib }:

(import (fetchFromGitHub {
  owner = "input-output-hk";
  repo = "daedalus";
  rev = "1ae99357a794fb73e78852abc984c3e5cd37d6bf";
  sha256 = "QBYvDDsvLnWx0mv9wCLtM0RkUEaSuGFXnimR0v+ciFI=";
}) { }).daedalus
