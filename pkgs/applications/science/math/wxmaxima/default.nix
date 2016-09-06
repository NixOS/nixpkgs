{ stdenv, fetchFromGitHub, maxima, wxGTK, makeWrapper, autoconf, automake, texinfo, gettext }:

let
  name    = "wxmaxima";
  version = "16.04.2";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchFromGitHub {
    owner = "andrejv";
    repo = "wxmaxima";
    rev = "Version-${version}";
    sha256 = "1sx1q4xgiz3v33s3960ki2d6c0daskxh6v2s26ihxqbf1awvhsgi";
  };

  preConfigure = ''
    ./bootstrap
  '';

  patches = [
    # needed to run wxmaxima outside of an app bundle
    ./darwin.patch
  ];

  nativeBuildInputs = [ autoconf automake texinfo gettext ];

  buildInputs = [wxGTK maxima makeWrapper];

  postInstall = ''
    # Make sure that wxmaxima can find its runtime dependencies.
    for prog in "$out/bin/"*; do
      wrapProgram "$prog" --prefix PATH ":" "${maxima}/bin"
    done
  '';

  doCheck = true;

  enableParallelBuilding = true;

  meta = {
    description = "Cross platform GUI for the computer algebra system Maxima";
    license = stdenv.lib.licenses.gpl2;
    homepage = http://wxmaxima.sourceforge.net;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.peti ];
  };
}
