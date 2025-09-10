{
  lib,
  fetchFromGitHub,
  rustPlatform,
  bubblewrap,
  makeWrapper,
}:

rustPlatform.buildRustPackage rec {
  pname = "pipr";
  version = "0.0.16";

  src = fetchFromGitHub {
    owner = "ElKowar";
    repo = "pipr";
    rev = "v${version}";
    sha256 = "sha256-6jtUNhib6iveuZ7qUKK7AllyMKFpZ8OUUaIieFqseY8=";
  };

  cargoHash = "sha256-SRIv/dZcyKm2E7c5/LtMCDnh+SDqPhJ01GZtkj0RgA0=";

  nativeBuildInputs = [ makeWrapper ];
  postFixup = ''
    wrapProgram "$out/bin/pipr" --prefix PATH : ${lib.makeBinPath [ bubblewrap ]}
  '';

  meta = with lib; {
    description = "Commandline-tool to interactively write shell pipelines";
    mainProgram = "pipr";
    homepage = "https://github.com/ElKowar/pipr";
    license = licenses.mit;
    maintainers = with maintainers; [ elkowar ];
    platforms = platforms.all;
  };
}
