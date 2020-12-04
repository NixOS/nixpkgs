{ stdenv, fetchFromGitHub, glibc }:

stdenv.mkDerivation rec {
  pname = "dumb-init";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "Yelp";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ws944y8gch6h7iqvznfwlh9hnmdn36aqh9w6cbc7am8vbyq0ffa";
  };

  buildInputs = [ glibc.static ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin dumb-init

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "A minimal init system for Linux containers";
    homepage = "https://github.com/Yelp/dumb-init";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
    platforms = platforms.linux;
  };
}
