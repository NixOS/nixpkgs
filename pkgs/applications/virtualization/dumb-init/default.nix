{ stdenv, fetchFromGitHub, glibc }:

stdenv.mkDerivation rec {
  pname = "dumb-init";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "Yelp";
    repo = pname;
    rev = "v${version}";
    sha256 = "15hgl8rz5dmrl5gx21sq5269l1hq539qn68xghjx0bv9hgbx0g20";
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
