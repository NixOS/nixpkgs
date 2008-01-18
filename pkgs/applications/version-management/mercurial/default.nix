{stdenv, fetchurl, python, makeWrapper}:

stdenv.mkDerivation {
  name = "mercurial-0.9.4";
  src = fetchurl {
    url = http://www.selenic.com/mercurial/release/mercurial-0.9.4.tar.gz;
    sha256 = "26996df67d508e129d2f0a264e25072764e5c2d21606e1658d77c8984e6ed64a";
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
