{
  lib,
  stdenv,
  bash,
  fetchFromGitHub,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "lse";
  version = "4.14nw";

  src = fetchFromGitHub {
    owner = "diego-treitos";
    repo = "linux-smart-enumeration";
    tag = version;
    hash = "sha256-qGLmrbyeyhHG6ONs7TJLTm68xpvxB1iAnMUApfTSqEk=";
  };

  buildInputs = [ bash ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp lse.sh $out/bin/lse.sh
    wrapProgram $out/bin/lse.sh \
      --prefix PATH : ${lib.makeBinPath [ bash ]}
  '';

  meta = {
    description = "Linux enumeration tool with verbosity levels";
    homepage = "https://github.com/diego-treitos/linux-smart-enumeration";
    changelog = "https://github.com/diego-treitos/linux-smart-enumeration/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "lse.sh";
    platforms = lib.platforms.all;
  };
}
