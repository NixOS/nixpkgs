{ stdenv, fetchFromGitHub, buildGoPackage}:

buildGoPackage rec {
  pname = "dnscontrol";
  version = "3.0.0";

  goPackagePath = "github.com/StackExchange/dnscontrol";

  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "StackExchange";
    repo = pname;
    rev = "v${version}";
    sha256 = "1j8i4k7bqkqmi6dmc9fxfab49a7qigig72rlbga902lw336p6cc7";
  };

  postInstall = ''
    rm $bin/bin/{build,convertzone,generate,validate}
  '';

  meta = with stdenv.lib; {
    description = "Synchronize your DNS to multiple providers from a simple DSL";
    homepage = "https://stackexchange.github.io/dnscontrol/";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut ];
  };
}
