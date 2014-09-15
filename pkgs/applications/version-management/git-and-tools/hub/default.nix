{ stdenv, fetchurl, groff, rake, makeWrapper }:

stdenv.mkDerivation rec {
  name = "hub-${version}";
  version = "1.12.2";

  src = fetchurl {
    url = "https://github.com/github/hub/archive/v${version}.tar.gz";
    sha256 = "112yfv9xklsmwv859kypv7hz0a6dj5hkrmjp7z1h40nrljc9mi79";
  };

  buildInputs = [ rake makeWrapper ];

  installPhase = ''
    rake install "prefix=$out"
  '';

  fixupPhase = ''
    wrapProgram $out/bin/hub --prefix PATH : ${groff}/bin
  '';

  meta = {
    description = "A GitHub specific wrapper for git";
    homepage = "http://defunkt.io/hub/";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ the-kenny ];
  };
}
