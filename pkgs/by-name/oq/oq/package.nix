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
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "Blacksmoke16";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-W0iGE1yVOphooiab689AFT3rhGGdXqEFyYIhrx11RTE=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/Blacksmoke16/oq/commit/4f9ef2a73770465bfe2348795461fc8a90a7b9b0.diff";
      hash = "sha256-Ljvf2+1vsGv6wJHl27T7DufI9rTUCY/YQZziOWpW8Do=";
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

  meta = with lib; {
    description = "Performant, and portable jq wrapper";
    mainProgram = "oq";
    homepage = "https://blacksmoke16.github.io/oq/";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
    platforms = platforms.unix;
  };
}
