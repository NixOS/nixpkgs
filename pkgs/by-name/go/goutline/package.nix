{
  buildGoModule,
  fetchFromGitHub,
  go,
  lib,
}:

buildGoModule rec {
  pname = "goutline";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "1pkg";
    repo = "goutline";
    rev = "v${version}";
    hash = "sha256-YZM+pQobuFGlxX+t1rgiM8JMc4n1AWveQr0W3LE9yPc=";
    postFetch = ''
      export GOCACHE=$TMPDIR/go-build
      export GOPATH=$TMPDIR/go
      export GOMODCACHE=$TMPDIR/go/pkg/mod
      cd $out
      ${lib.getExe go} mod init github.com/1pkg/goutline
      ${lib.getExe go} mod tidy
    '';
  };

  vendorHash = "sha256-RNRvYpbAqKoKPnF1acIX3wbuSvu3k0tppi6ncWd6hIM=";

  meta = with lib; {
    description = "Go AST Declaration Extractor";
    homepage = "https://github.com/1pkg/goutline";
    license = licenses.mit;
    maintainers = with maintainers; [ wwmoraes ];
  };
}
