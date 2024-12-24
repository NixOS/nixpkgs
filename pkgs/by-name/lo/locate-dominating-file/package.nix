{
  bats,
  bash,
  fetchFromGitHub,
  lib,
  resholve,
  coreutils,
  getopt,
}:
let
  version = "0.0.1";
in
resholve.mkDerivation {
  pname = "locate-dominating-file";
  inherit version;
  src = fetchFromGitHub {
    owner = "roman";
    repo = "locate-dominating-file";
    rev = "v${version}";
    hash = "sha256-gwh6fAw7BV7VFIkQN02QIhK47uxpYheMk64UeLyp2IY=";
  };

  postPatch = ''
    for file in $(find src tests -type f); do
      patchShebangs "$file"
    done
  '';

  buildInputs = [
    getopt
    coreutils
  ];

  checkInputs = [
    (bats.withLibraries (p: [
      p.bats-support
      p.bats-assert
    ]))
  ];

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    bats -t tests

    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp src/locate-dominating-file.sh $out/bin/locate-dominating-file

    runHook postInstall
  '';

  solutions.default = {
    scripts = [ "bin/locate-dominating-file" ];
    interpreter = "${bash}/bin/bash";
    inputs = [
      coreutils
      getopt
    ];
  };

  meta = with lib; {
    homepage = "https://github.com/roman/locate-dominating-file";
    description = "Program that looks up in a directory hierarchy for a given filename";
    license = licenses.mit;
    maintainers = [ maintainers.roman ];
    platforms = platforms.all;
    mainProgram = "locate-dominating-file";
  };
}
