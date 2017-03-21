{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
    name = "terminal-parrot-1.1.0";
    version = "1.1.0";
    goPackagePath = "github.com/jmhobbs/terminal-parrot";

    src = fetchFromGitHub {
        owner = "jmhobbs";
        repo = "terminal-parrot";
        rev = "22c9bde916c12d8b13cf80ab252995dbf47837d1";
        sha256 = "1mrxmifsmndf6hdq1956p1gyrrp3abh3rmwjcmxar8x2wqbv748y";
    };

    meta = with stdenv.lib; {
        description = "Shows colorful, animated party parrot in your terminial";
        homepage = https://github.com/jmhobbs/terminal-parrot;
        license = licenses.mit;
        platforms = platforms.all;
        maintainers = [ maintainers.heel ];
    };
}
