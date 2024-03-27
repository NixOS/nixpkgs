{ buildNpmPackage
, lib
, electron
, fetchFromGitHub
, ollama
, makeWrapper
, nix-update-script
}:

buildNpmPackage rec {
  pname = "chatd";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "BruceMacD";
    repo = "chatd";
    rev = "v${version}";
    hash = "sha256-3VtF2vLs+bdT9VX3A+A8hntzNZZ+SL5UZqs5Cm/1264=";
  };

  npmDepsHash = "sha256-RwugV6548zaxuAHoWImNKKokPkMnCWQWaUvQhH/AxGU=";

  dontNpmBuild = true;

  npmFlags = [ "--ignore-scripts" ];

  nativeBuildInputs = [
    makeWrapper
    electron
  ];

  postPatch = ''
    # basically https://github.com/BruceMacD/chatd/pull/35
    # requires a new release to work with remote ollama instances
    substituteInPlace src/service/ollama/ollama.js \
      --replace 'this.host = "http://127.0.0.1:11434";' 'this.host = process.env.OLLAMA_HOST || "http://127.0.0.1:11434";'
  '';

  buildPhase = ''
  runHook preBuild

  runHook postBuild
  '';

  installPhase = ''
    mkdir -p $out/{bin,share}
    cp -r . $out/share/chatd
    rm -rf $out/share/electron{,-winstaller} $(find $out -name 'win32')

    for bin in ollama-darwin ollama-linux; do
      makeWrapper ${lib.getExe ollama} $out/share/chatd/src/service/ollama/runners/$bin
    done

    makeWrapper ${lib.getExe electron} $out/bin/chatd \
      --add-flags $out/share/chatd/src/index.js
  '';

  passthru.updateScript = nix-update-script {};

  meta = with lib; {
    mainProgram = "chatd";
    description = "Chat with your documents using local AI";
    homepage = "https://github.com/BruceMacD/chatd";
    maintainers = [ maintainers.lucasew ];
    platforms = electron.meta.platforms;
    license = licenses.mit;
  };
}
