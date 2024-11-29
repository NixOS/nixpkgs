{ lib, bundlerApp, bundlerUpdateScript }:

bundlerApp {
  pname = "fpm";
  gemdir = ./.;
  exes = [ "fpm" ];

  passthru.updateScript = bundlerUpdateScript "fpm";

  meta = with lib; {
    description = "Tool to build packages for multiple platforms with ease";
    homepage    = "https://github.com/jordansissel/fpm";
    license     = licenses.mit;
    maintainers = with maintainers; [ manveru nicknovitski ];
    platforms   = platforms.unix;
    mainProgram = "fpm";
  };
}
