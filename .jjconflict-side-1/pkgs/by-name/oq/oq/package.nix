{
  lib,
  fetchFromGitHub,
  fetchpatch,
  crystal,
  jq,
  libxml2,
  makeWrapper,
}:

crystal.buildCrystalPackage rec {
  pname = "oq";
  version = "1.3.5";

  src = fetchFromGitHub {
    owner = "Blacksmoke16";
    repo = "oq";
    tag = "v${version}";
    sha256 = "sha256-AgUVHlk39J1V1Vv91FjglT4mSbP4IHiRlTrlfmrJxfY=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/Blacksmoke16/oq/commit/151b5b1d60ed1cafa9fc2a1ec175dcd1732a3961.diff";
      hash = "sha256-xWZ1U2A1ClwviSdGMvBeBgA16qKLuUzdBRmJblM7DAc=";
    })
  ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ libxml2 ];
  nativeCheckInputs = [ jq ];

  format = "shards";

  postInstall = ''
    wrapProgram "$out/bin/oq" \
      --prefix PATH : "${lib.makeBinPath [ jq ]}"
  '';

  meta = {
    description = "Performant, and portable jq wrapper";
    mainProgram = "oq";
    homepage = "https://blacksmoke16.github.io/oq/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
