{
  lib,
  fetchFromGitHub,
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
