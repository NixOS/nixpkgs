{ lib
, buildGoModule
, fetchFromGitea
, chromaprint
, makeWrapper
,
}:

buildGoModule rec {
  pname = "soundalike";
  version = "0.1.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "derat";
    repo = "soundalike";
    rev = "v0.1.2";
    hash = "sha256-mpYUVTj3Zll6kNuK5Mdzv1R7k5FZy6XFghhzmAPPVM8=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ chromaprint ];
  postInstall = ''
    wrapProgram $out/bin/soundalike \
      --prefix PATH : ${ lib.makeBinPath [ chromaprint ]}
  '';

  vendorHash = "sha256-7hRezOBcjB2wsx/SwV519wg3Azh+0kHMcAoc9aYPM3A=";
  doCheck = true;
  checkFlags = [
    "-skip=TestMain_Scan|TestMain_Compare"
  ];

  meta = with lib; {
    description = "Find duplicate audio files using acoustic fingerprints";
    homepage = "https://codeberg.org/derat/soundalike";
    changelog =
      "https://codeberg.org/derat/soundalike/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ atar13 ];
    mainProgram = "soundalike";
  };
}
