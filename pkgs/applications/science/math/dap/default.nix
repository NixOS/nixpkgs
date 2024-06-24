{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "dap";
  version = "3.10";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    sha256 = "Bk5sty/438jLb1PpurMQ5OqMbr6JqUuuQjcg2bejh2Y=";
  };

  hardeningDisable = [ "format" ];

  meta = with lib; {
    homepage = "https://www.gnu.org/software/dap";
    description = "Small statistics and graphics package based on C";
    longDescription = ''
      Dap is a small statistics and graphics package based on C. Version 3.0 and
      later of Dap can read SBS programs (based on the utterly famous, industry
      standard statistics system with similar initials - you know the one I
      mean)! The user wishing to perform basic statistical analyses is now freed
      from learning and using C syntax for straightforward tasks, while
      retaining access to the C-style graphics and statistics features provided
      by the original implementation. Dap provides core methods of data
      management, analysis, and graphics that are commonly used in statistical
      consulting practice (univariate statistics, correlations and regression,
      ANOVA, categorical data analysis, logistic regression, and nonparametric
      analyses).
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
