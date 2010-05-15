{ fetchurl, fetchgit }:

builtins.listToAttrs
[
  {
    name = "0.4.0";
    value = rec {
      name = "rekonq-0.4.0";
      src = fetchurl {
        url = "mirror://sourceforge/rekonq/${name}.tar.bz2";
        sha256 = "1dxpzkifqy85kwj94mhazan6f9glxvl7i02c50n3f0a12wiywwvy";
      };
    };
  }

  {
    name = "scm";
    value = {
      name = "rekonq-0.4.0-20100514";
      src = fetchgit {
        url = git://gitorious.org/rekonq/mainline.git;
        rev = "6b4f4d69a3c599bc958ccddc5f7ac1c8648a7042";
        sha256 = "1qcwf7rsrnsbnq62cl44r48bmavc2nysi2wqhy1jxmj2ndwvsxy1";
      };
    };
  }
]
