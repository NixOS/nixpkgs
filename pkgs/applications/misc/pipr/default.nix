{ stdenv
, fetchFromGitHub
, rustPlatform
, bubblewrap
, makeWrapper
, lib
}:

rustPlatform.buildRustPackage rec {
  pname = "pipr";
  version = "0.0.15";

  src = fetchFromGitHub {
    owner = "ElKowar";
    repo = pname;
    rev = "v${version}";
    sha256 = "1pbj198nqi27kavz9bm31a3h7h70by6l00046x09yf9n8qjpp01w";
  };

  cargoSha256 = "1dcrafpf252dpjvimaibb93082nymb26wwbvr34zd6j7z285vach";

  nativeBuildInputs = [ makeWrapper ];
  postFixup = ''
    wrapProgram "$out/bin/pipr" --prefix PATH : ${lib.makeBinPath [ bubblewrap ]}
  '';

  meta = with stdenv.lib; {
    description = "A commandline-tool to interactively write shell pipelines";
    homepage = "https://github.com/ElKowar/pipr";
    license = licenses.mit;
    maintainers = with maintainers; [ elkowar ];
    platforms = platforms.all;
  };
}
