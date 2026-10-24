{
  fetchurl,
  lib,
  makeWrapper,
  stdenv,
  writeScript,
  jdk21,
  libXext,
  libXtst,
}:
stdenv.mkDerivation rec {
  pname = "defold-bob";
  version = "1.10.1";

  src = fetchurl {
    url = "https://github.com/defold/defold/releases/download/${version}/bob.jar";
    hash = "sha256-DlLfzQ+dztPJ1n/Nx1een8Z5h6SQK+cwegDeSW/tVI4=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    jdk21
    libXext
    libXtst
  ];

  dontBuild = true;
  dontConfigure = true;
  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    install -m 444 -D $src $out/bob.jar
    makeWrapper ${jdk21}/bin/java $out/bin/defold-bob \
      --add-flags "-jar $out/bob.jar"
    runHook postInstall
  '';

  passthru = {
    updateScript = writeScript "update.sh" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl jq nix-update
      version=$(curl -s https://d.defold.com/editor-alpha/info.json | jq -r .version)
      nix-update defold-bob --version "$version"
    '';
  };

  meta = {
    description = "Bob is a command line tool for building Defold projects outside of the normal editor workflow.";
    homepage = "https://defold.com/manuals/bob/";
    license = lib.licenses.free;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ flexiondotorg ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "defold-bob";
  };
}
