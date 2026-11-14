{ bash
, lib
, stdenv
, fetchFromGitHub
, makeWrapper
, pkgs
, pkg-config
,
}:
stdenv.mkDerivation rec {
  pname = "git-co-author";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "jamesjoshuahill";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-IdVpWVLfS3Xa2+pSwIKz6qeqETnu1Au+bCFaeyepC94=";
  };

  buidInputs = [ bash ];
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp git-co-author $out/bin
    wrapProgram $out/bin/git-co-author \
      --prefix PATH : ${lib.makeBinPath [bash]}
  '';

  meta = with lib; {
    description = "Easily use 'Co-authored-by' trailers in the commit template";
    homepage = "https://github.com/jamesjoshuahill/git-co-author";
    license = licenses.unlicense;
    maintainers = with maintainers; [ sentientmonkey ];
    mainProgram = "git-co-author";
  };
}
