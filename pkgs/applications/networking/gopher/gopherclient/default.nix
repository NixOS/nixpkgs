{ stdenv, buildGoPackage, fetchgit, makeWrapper, pkgconfig, qtbase, qtdeclarative, qtwebengine }:

buildGoPackage rec {
  name = "gopherclient-${version}";
  version = "2016-10-02";
  rev = "91c41b5542d08001636708e2a5054521a6004702";

  goPackagePath = "github.com/prologic/gopherclient";

  src = fetchgit {
    inherit rev;
    url = "https://github.com/prologic/gopherclient";
    sha256 = "0b1gvxhv4zg930hvric9mmbfp0lnww0sqlkkfbzfkif3wz9ni5y9";
  };

  nativeBuildInputs = [ makeWrapper pkgconfig ];

  buildInputs = [ qtbase qtdeclarative qtwebengine ];

  preBuild = ''
    # Generate gopherclient resources with genqrc.
    ln -s ${goPackagePath}/vendor/gopkg.in go/src/
    GOBIN="$(pwd)" go install -v gopkg.in/qml.v1/cmd/genqrc
    PATH="$(pwd):$PATH" go generate ${goPackagePath}
  '';

  NIX_CFLAGS_COMPILE = [
    # go-qml needs private Qt headers.
    "-I${qtbase.dev}/include/QtCore/${qtbase.version}"
  ];

  postInstall = ''
    # https://github.com/prologic/gopherclient/#usage
    wrapProgram $bin/bin/gopherclient --prefix GODEBUG , cgocheck=0
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/prologic/gopherclient;
    description = "Gopher Qt GUI client";
    license = licenses.mit;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.linux;
    broken = true;
  };
}
