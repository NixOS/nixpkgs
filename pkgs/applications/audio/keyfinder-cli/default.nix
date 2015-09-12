{ stdenv, fetchFromGitHub, libav, libkeyfinder }:

let version = "2015-09-11"; in
stdenv.mkDerivation rec {
  name = "keyfinder-cli-${version}";

  src = fetchFromGitHub {
    repo = "keyfinder-cli";
    owner = "EvanPurkhiser";
    rev = "94df5e6c012a2643a4e5eda49a80cdc57d2e1bb2";
    sha256 = "04276z5xrpgf1zga565awypy5r7g054fwl4x75l7j308x0xcp12j";
  };

  buildInputs = [ libav libkeyfinder ];

  makeFlagsArray = "PREFIX=$(out)";

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    inherit version;
    inherit (src.meta) homepage;
    description = "Musical key detection for digital audio (command-line tool)";
    longDescription = ''
      This small utility is the automation-oriented DJ's best friend. By making
      use of Ibrahim Sha'ath's high quality libKeyFinder library, it can be
      used to estimate the musical key of many different audio formats.
    '';
    license = licenses.gpl3Plus;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };
}
