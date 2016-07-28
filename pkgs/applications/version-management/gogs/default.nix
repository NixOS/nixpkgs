{ stdenv, buildGoPackage, fetchgit, makeWrapper, git, sqliteSupport ? true  }:

buildGoPackage rec {
  name = "gogs-${version}";
  version = "20160728-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "ad7ea88923e371df7558835d8f3e0236cfdf69ba";

  buildInputs = [ makeWrapper ];
  buildFlags = stdenv.lib.optional (sqliteSupport) "-tags sqlite";
  goPackagePath = "github.com/gogits/gogs";

  postInstall = ''
    wrapProgram $bin/bin/gogs \
      --prefix PATH : ${git}/bin \
      --run 'export GOGS_WORK_DIR=''${GOGS_WORK_DIR:-$PWD}' \
      --run 'cd "$GOGS_WORK_DIR"' \
      --run "ln -fs $out/share/go/src/${goPackagePath}/{public,templates} ."
  '';

  src = fetchgit {
    inherit rev;
    url = "https://github.com/gogits/gogs";
    sha256 = "0vgkhpwvj79shpi3bq2sr1nza53fidmnbmh814ic09jnb2dilnrm";
  };

  goDeps = ./deps.json;
}
