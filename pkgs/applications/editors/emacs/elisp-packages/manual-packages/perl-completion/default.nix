{ trivialBuild
, fetchurl
}:

trivialBuild {
  pname = "perl-completion";

  src = fetchurl {
    url = "http://emacswiki.org/emacs/download/perl-completion.el";
    sha256 = "0x6qsgs4hm87k0z9q3g4p6508kc3y123j5jayll3jf3lcl2vm6ks";
  };

  meta = {
    broken = true;
    description = "Minor mode provides useful features for editing perl codes";
    homepage = "http://emacswiki.org/emacs/PerlCompletion";
  };
}
