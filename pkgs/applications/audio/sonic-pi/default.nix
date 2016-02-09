{ stdenv
, fetchFromGitHub
, qscintilla
, supercollider
, ruby
, cmake
, pkgconfig
, qt48Full
, bash
, makeWrapper
}:

stdenv.mkDerivation rec {
  version = "2.8.0";
  name = "sonic-pi-${version}";

  src = fetchFromGitHub {
    owner = "samaaron";
    repo = "sonic-pi";
    rev = "v${version}";
    sha256 = "1yyavgazb6ar7xnmjx460s9p8nh70klaja2yb20nci15k8vngq9h";
  };

  buildInputs = [
    qscintilla
    supercollider
    ruby
    qt48Full
    cmake
    pkgconfig
    bash
    makeWrapper
  ];

  meta = {
    homepage = http://sonic-pi.net/;
    description = "Free live coding synth for everyone originally designed to support computing and music lessons within schools";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.Phlogistique ];
    platforms = stdenv.lib.platforms.linux;
  };

  dontUseCmakeConfigure = true;

  buildPhase = ''
    pushd app/server/bin
    ${ruby}/bin/ruby compile-extensions.rb
    popd

    pushd app/gui/qt
    ${bash}/bin/bash rp-build-app
    popd
  '';

  installPhase = ''
    cp -r . $out
    wrapProgram $out/bin/sonic-pi --prefix PATH : \
      ${ruby}/bin:${bash}/bin
  '';
}
