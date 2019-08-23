{ stdenv, lib, fetchFromGitHub, makeWrapper, perlPackages
, cursesSupport ? true
, uriFindSupport ? true
}:

let
  perlDeps =
    [ perlPackages.MIMEtools perlPackages.HTMLParser ]
    ++ lib.optional cursesSupport perlPackages.CursesUI
    ++ lib.optional uriFindSupport perlPackages.URIFind;

in stdenv.mkDerivation rec {
  name = "extract_url-${version}";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "m3m0ryh0l3";
    repo = "extracturl";
    rev = "v${version}";
    sha256 = "05589lp15jmcpbj4y9a3hmf6n2gsqrm4ybcyh3hd4j6pc7hmnhny";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ perlPackages.perl ] ++ perlDeps;

  makeFlags = [ "prefix=$(out)" ];
  installFlags = [ "INSTALL=install" ];

  postFixup = ''
    wrapProgram "$out/bin/extract_url" \
      --set PERL5LIB "${perlPackages.makeFullPerlPath perlDeps}"
  '';

  meta = with lib; {
    homepage = https://www.memoryhole.net/~kyle/extract_url/;
    description = "Extracts URLs from MIME messages or plain text";
    license = licenses.bsd2;
    maintainers = [ maintainers.qyliss ];
    platforms = platforms.unix;
  };
}
