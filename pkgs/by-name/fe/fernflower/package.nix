{
  lib,
  stdenv,
  fetchFromGitHub,
  gradle_9,
  jre_headless,
  jre_minimal,
  runtimeShell,
}:
let
  jre = jre_minimal.override {
    jdk = jre_headless;
  };
  gradle = gradle_9;
in
stdenv.mkDerivation rec {
  pname = "fernflower";
  version = "262.8377";

  src = fetchFromGitHub {
    owner = "JetBrains";
    repo = "fernflower";
    rev = "${version}";
    hash = "sha256-brEVkZNfbxxcfxrFjAjcoui6D1VmnBqvu70MS0kBnhQ=";
  };

  nativeBuildInputs = [ gradle ];

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  installPhase = ''
    mkdir -p $out/{bin,share/fernflower}
    cp build/libs/fernflower.jar $out/share/fernflower

    cat  << EOF > $out/bin/fernflower
    #!${runtimeShell}
    exec ${jre}/bin/java -jar "$out/share/fernflower/fernflower.jar" "\$@"
    EOF
    chmod a+x "$out/bin/fernflower"
  '';

  meta = {
    description = "Analytical Java decompiler for the command line";
    homepage = "https://github.com/JetBrains/fernflower/";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode
    ];
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      poptart
    ];
    platforms = lib.platforms.unix;
    mainProgram = "fernflower";
  };
}
