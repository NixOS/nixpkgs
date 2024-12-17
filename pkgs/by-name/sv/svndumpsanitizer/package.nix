{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "svndumpsanitizer";
  version = "2.0.7";
  src = fetchFromGitHub {
    owner = "dsuni";
    repo = "svndumpsanitizer";
    # https://github.com/dsuni/svndumpsanitizer/issues/22
    rev = "cbf917c000ee42fbb31a8667014a4357bbfdd6a6";
    hash = "sha256-lkVX11t0AF4y1EQQFXjPTrJmsfJhgx5Y1xj1VDlsbH0=";
  };
  buildPhase = ''
    runHook preBuild
    cc svndumpsanitizer.c -o svndumpsanitizer
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    install -Dm555 svndumpsanitizer -t $out/bin
    runHook postInstall
  '';
  meta = with lib; {
    description = "Alternative to svndumpfilter that discovers which nodes should actually be kept";
    homepage = "https://miria.homelinuxserver.org/svndumpsanitizer";
    downloadPage = "https://github.com/dsuni/svndumpsanitizer";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ lafrenierejm ];
    mainProgram = "svndumpsanitizer";
    platforms = platforms.unix;
  };
}
