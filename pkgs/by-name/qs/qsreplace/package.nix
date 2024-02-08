{ lib
, fetchFromGitHub
, buildGoPackage
}:

buildGoPackage rec {
  pname = "qsreplace";
  version = "0.0.3";

  goPackagePath = "github.com/tomnomnom/qsreplace";

  src = fetchFromGitHub {
    owner = "tomnomnom";
    repo = "qsreplace";
    rev = "v${version}";
    hash = "sha256-j9bqO2gp4RUxZHGBCIxI5nA3nD1dG4nCpJ1i4TM/fbo=";
  };

  meta = with lib; {
    homepage = "https://github.com/tomnomnom/qsreplace";
    description = "Accept URLs on stdin, replace all query string values with a user-supplied value";
    mainProgram = "qsreplace";
    maintainers = with maintainers; [ averagebit ];
    platforms = platforms.unix;
    sourceProvenance = with sourceTypes; [ fromSource ];
    license = licenses.mit;
  };
}
