args: with args;

stdenv.mkDerivation {
  name = "mercurial-0.9.5";
  src = fetchurl {
    url = http://www.selenic.com/mercurial/release/mercurial-0.9.5.tar.gz;
    sha256 = "1n34yl4z7nc3vmsgpkmqc94hsmy846ny86xgpgv3m371ljm2pq6g";
  };

  buildInputs = [ python makeWrapper ];
  makeFlags = "PREFIX=$(out)";
  postInstall = ''
    for i in $(cd $out/bin && ls); do
      wrapProgram $out/bin/$i \
        --prefix PYTHONPATH : "$(toPythonPath $out)"
    done
  '';

  meta = {
    description = "A fast, lightweight SCM system for very large distributed projects";
    homepage = http://www.selenic.com/mercurial/;
  };
}
