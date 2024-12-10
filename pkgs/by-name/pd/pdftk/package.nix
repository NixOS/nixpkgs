{
  lib,
  stdenv,
  fetchFromGitLab,
  gradle,
  jre,
  runtimeShell,
}:

stdenv.mkDerivation rec {
  pname = "pdftk";
  version = "3.3.3";

  src = fetchFromGitLab {
    owner = "pdftk-java";
    repo = "pdftk";
    rev = "v${version}";
    hash = "sha256-ciKotTHSEcITfQYKFZ6sY2LZnXGChBJy0+eno8B3YHY=";
  };

  nativeBuildInputs = [ gradle ];

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  __darwinAllowLocalNetworking = true;

  gradleFlags = [ "-Dfile.encoding=utf-8" ];

  gradleBuildTask = "shadowJar";

  installPhase = ''
    mkdir -p $out/{bin,share/pdftk,share/man/man1}
    cp build/libs/pdftk-all.jar $out/share/pdftk

    cat  << EOF > $out/bin/pdftk
    #!${runtimeShell}
    exec ${jre}/bin/java -jar "$out/share/pdftk/pdftk-all.jar" "\$@"
    EOF
    chmod a+x "$out/bin/pdftk"

    cp ${src}/pdftk.1 $out/share/man/man1
  '';

  meta = with lib; {
    description = "Command-line tool for working with PDFs";
    homepage = "https://gitlab.com/pdftk-java/pdftk";
    sourceProvenance = with sourceTypes; [
      fromSource
      binaryBytecode # deps
    ];
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      raskin
      averelld
    ];
    platforms = platforms.unix;
    mainProgram = "pdftk";
  };
}
