{ stdenv, fetchFromGitHub, buildGoPackage}:

buildGoPackage rec {
  pname = "dnscontrol";
  version = "3.2.0";

  goPackagePath = "github.com/StackExchange/dnscontrol";

  src = fetchFromGitHub {
    owner = "StackExchange";
    repo = pname;
    rev = "v${version}";
    sha256 = "1lrn1whmx9zkyvs505zxrsmnr5s6kpj3kjkr6rblfwdlnadkgfj7";
  };

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "Synchronize your DNS to multiple providers from a simple DSL";
    homepage = "https://stackexchange.github.io/dnscontrol/";
    license = licenses.mit;
    maintainers = with maintainers; [ mmahut ];
  };
}
