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
  version = "2.9.0";
  name = "sonic-pi-${version}";

  src = fetchFromGitHub {
    owner = "samaaron";
    repo = "sonic-pi";
    rev = "v${version}";
    sha256 = "19db5dxrf6h1v2w3frds5g90nb6izd9ppp7cs2xi6i0m67l6jrwb";
  };

  buildInputs = [
    bash
    cmake
    makeWrapper
    pkgconfig
    qscintilla
    qt48Full
    ruby
    supercollider
  ];

  meta = {
    homepage = http://sonic-pi.net/;
    description = "Free live coding synth for everyone originally designed to support computing and music lessons within schools";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.Phlogistique ];
    platforms = stdenv.lib.platforms.linux;
  };

  dontUseCmakeConfigure = true;

  patches = [ ./fixed-prefixes.patch ];

  preConfigure = ''
    patchShebangs .
    substituteInPlace app/gui/qt/mainwindow.cpp \
      --subst-var-by ruby "${ruby}/bin/ruby" \
      --subst-var out
  '';

  buildPhase = ''
    pushd app/server/bin
      ./compile-extensions.rb
    popd

    pushd app/gui/qt
      ./rp-build-app
    popd
  '';

  installPhase = ''
    cp -r . $out
    wrapProgram $out/bin/sonic-pi --prefix PATH : \
      ${ruby}/bin:${bash}/bin
  '';
}
