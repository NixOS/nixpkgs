{ lib
, buildNpmPackage
, fetchFromGitHub
, typescript
, esbuild
, makeWrapper
, nodejs
}:
buildNpmPackage rec {
  pname = "opcua-commander";
  version = "0.37.0";

  src = fetchFromGitHub {
    owner = "node-opcua";
    repo = "opcua-commander";
    rev = version;
    hash = "sha256-wQXSSNinY85Ti+D/zklYP2N8IP3OsN9xQNJuuQr4kVU=";
  };

  npmDepsHash = "sha256-Ux1X/3sam9WHrTfqoWv1r9p3pJOs6BaeFsxHizAvjXA=";
  nativeBuildInputs = [ esbuild typescript makeWrapper ];

  postPatch = ''
    substituteInPlace package.json \
      --replace-warn "npx -y esbuild" "esbuild"
  '';

  # We need to add `nodejs` to PATH for `opcua-commander` to properly work
  # when connected to an OPC-UA server.
  # Test it with:
  # ./opcua-commander -e opc.tcp://opcuademo.sterfive.com:26543
  postFixup = ''
    wrapProgram $out/bin/opcua-commander \
      --prefix PATH : "${lib.makeBinPath [nodejs]}"
  '';

  meta = with lib; {
    description = "Opcua client with blessed (ncurses)";
    homepage = "https://github.com/node-opcua/opcua-commander";
    license = licenses.mit;
    maintainers = with maintainers; [ jonboh ];
    mainProgram = "opcua-commander";
  };
}
