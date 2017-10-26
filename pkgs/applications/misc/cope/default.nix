{ stdenv, fetchFromGitHub, buildPerlPackage, perlPackages }:

buildPerlPackage rec {
    name = "cope";
    src = fetchFromGitHub {
      repo = "cope";
      owner = "lotrfan";
      rev = "0dc82a939a9498ff80caf472841c279dfe03efae";
      sha256 = "11haq6lrjxais7jb788296yrzkg3hshqr7bvs80sb7cqrvlgcjsf";
      # owner = "nichivo";
      # rev = "4f458b7c39b6eb819e078871d75703fae4a19056";
      # sha256 = "1273qf4pd0qf77f26n9paiwf3jvbpl5cswybhn8066gnwwfq5yqh";
    };

    meta = with stdenv.lib; {
      description = "A colourful wrapper for terminal programs.";
      # license = licenses.mit;
      # maintainers = [ maintainers.afldcr ];
      platforms = platforms.unix;
    };

    propagatedBuildInputs = with perlPackages; [EnvPath FileShareDir IOTty IOStty ListMoreUtils RegexpCommon RegexpIPv6];
}
