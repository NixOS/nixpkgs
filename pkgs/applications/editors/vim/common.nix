{ lib, fetchFromGitHub }:
rec {
  version = "8.0.0005";

  src = fetchFromGitHub {
    owner = "vim";
    repo = "vim";
    rev = "v${version}";
    sha256 = "0ys3l3dr43vjad1f096ch1sl3x2ajsqkd03rdn6n812m7j4wipx0";
  };

  enableParallelBuilding = true;

  hardeningDisable = [ "fortify" ];

  meta = with lib; {
    description = "The most popular clone of the VI editor";
    homepage    = http://www.vim.org;
    license     = licenses.vim;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
