{ stdenv
, fetchFromGitHub
, rustPlatform
, bubblewrap
, makeWrapper
, lib
}:

rustPlatform.buildRustPackage rec {
  pname = "pipr";
  version = "0.0.12";

  src = fetchFromGitHub {
    owner = "ElKowar";
    repo = pname;
    rev = "v${version}";
    sha256 = "0l7yvpc59mbzh87lngj6pj8w586fwa07829l5x9mmxnkf6srapmc";
  };

  cargoSha256 = "1xzc1x5mjvj2jgdhwmjbdbqi8d7ln1ss7akn72d96kmy1wsj1qsa";

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
