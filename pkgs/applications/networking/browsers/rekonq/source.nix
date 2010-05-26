{ fetchurl, fetchgit }:

builtins.listToAttrs
[
  {
    name = "0.4.90";
    value = rec {
      name = "rekonq-0.4.90";
      src = fetchurl {
        url = "http://kde-apps.org/CONTENT/content-files/94258-${name}.tar.bz2";
        name = "${name}.tar.bz2";
        sha256 = "1dmdx54asv0b4xzc8p5nadn92l8pks9cl1y9j8a46lsslwsjw3ws";
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
