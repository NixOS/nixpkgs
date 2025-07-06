{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  python3,
  makeWrapper,
}:

buildNpmPackage rec {
  pname = "mcpm-aider";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "lutzleonhardt";
    repo = "mcpm-aider";
    tag = "v${version}";
    hash = "sha256-ycMErD3m4+pfrtaRZRO1Qud7jwlM21JZg7Dqr4TocSc=";
  };

  postPatch = ''
    cp ${./package-lock.json.patch} package-lock.json
  '';

  npmDepsHash = "sha256-JhV1hdjvk0Z7BXtOU4asNVd2+bDDfUoSOZpT7AjNR6M=";

  nativeBuildInputs = [ makeWrapper ];

  npmBuildScript = "build";
  npmFlags = [ "--ignore-scripts" ];

  postInstall = ''
    mkdir -p $out/bin
    ln -sf $out/lib/node_modules/@poai/mcpm-aider/bin/index.js $out/bin/mcpm-aider
  '';

  postFixup = ''
    wrapProgram $out/bin/mcpm-aider \
      --set NODE_ENV production \
      --prefix PATH : ${lib.makeBinPath [ python3 ]}
  '';

  meta = with lib; {
    description = "A command-line tool for managing MCP servers in Claude App and for use with aider";
    homepage = "https://github.com/lutzleonhardt/mcpm-aider";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ wvhulle ];
    mainProgram = "mcpm-aider";
  };
}
