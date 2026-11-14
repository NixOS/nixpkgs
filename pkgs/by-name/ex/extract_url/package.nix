{
  stdenv,
  lib,
  fetchFromGitHub,
  makeWrapper,
  perlPackages,
  cursesSupport ? true,
  uriFindSupport ? true,
}:

let
  perlDeps = [
    perlPackages.MIMETools
    perlPackages.HTMLParser
  ]
  ++ lib.optional cursesSupport perlPackages.CursesUI
  ++ lib.optional uriFindSupport perlPackages.URIFind;

in
stdenv.mkDerivation (finalAttrs: {
  pname = "extract_url";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "m3m0ryh0l3";
    repo = "extracturl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3kJb4WHXSNLggJ4tT2rG+glrXIVDJU/kuqzKEi5NqBQ=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ perlPackages.perl ] ++ perlDeps;

  makeFlags = [ "prefix=$(out)" ];
  installFlags = [ "INSTALL=install" ];

  postFixup = ''
    wrapProgram "$out/bin/extract_url" \
      --set PERL5LIB "${perlPackages.makeFullPerlPath perlDeps}"
  '';

  meta = {
    homepage = "https://www.memoryhole.net/~kyle/extract_url/";
    description = "Extracts URLs from MIME messages or plain text";
    mainProgram = "extract_url";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.qyliss ];
    platforms = lib.platforms.unix;
  };
})
