{ stdenv, fetchFromGitHub, libav, libkeyfinder }:

let version = "20150130"; in
stdenv.mkDerivation rec {
  name = "keyfinder-cli-${version}";

  src = fetchFromGitHub {
    repo = "keyfinder-cli";
    owner = "EvanPurkhiser";
    rev = "e8a20e73f8a465a6c3c9e71dabf4b636244a9b0c";
    sha256 = "0x198ijr6wgzq24642s4pz5zxn4gvcc7dxmb6d1bfn3dwzi3j8lp";
  };

  meta = with stdenv.lib; {
    description = "Musical key detection for digital audio (command-line tool)";
    longDescription = ''
      This small utility is the automation-oriented DJ's best friend. By making
      use of Ibrahim Sha'ath's high quality libKeyFinder library, it can be
      used to estimate the musical key of many different audio formats.
    '';
    homepage = https://github.com/EvanPurkhiser/keyfinder-cli;
    license = with licenses; gpl3Plus;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ nckx ];
  };

  buildInputs = [ libav libkeyfinder ];

  makeFlagsArray = "PREFIX=$(out)";

  enableParallelBuilding = true;
}
