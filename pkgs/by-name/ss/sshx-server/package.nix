{
  lib,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
  buildNpmPackage,
}:

rustPlatform.buildRustPackage rec {
  pname = "sshx-server";
  version = "0.4.1";

  cargoHash = "sha256-QftBUGDQvCSHoOBLnEzNOe1dMTpVTvMDXNp5qZr0C2M=";

  src = fetchFromGitHub {
    owner = "ekzhang";
    repo = "sshx";
    tag = "v${version}";
    hash = "sha256-+IHV+dJb/j1/tmdqDXo6bqhvj3nBQ7i4AsUeHFA3+NU=";
  };

  nativeBuildInputs = [ protobuf ];

  cargoBuildFlags = [
    "--package"
    "sshx-server"
  ];

  cargoTestFlags = cargoBuildFlags;

  postPatch = ''
    substituteInPlace crates/sshx-server/src/web.rs \
      --replace-fail 'ServeDir::new("build")' 'ServeDir::new("${passthru.web.outPath}")' \
      --replace-fail 'ServeFile::new("build/spa.html")' 'ServeFile::new("${passthru.web.outPath}/spa.html")'
  '';

  passthru.web = buildNpmPackage {
    pname = "sshx-web";

    inherit
      version
      src
      ;

    postPatch = ''
      substituteInPlace vite.config.ts \
        --replace-fail 'execSync("git rev-parse --short HEAD").toString().trim()' '"${src.rev}"'
    '';

    npmDepsHash = "sha256-QdgNtQMjK229QzB5LbCry1hKVPon8IWUnj+v5L7ydfI=";

    installPhase = ''
      cp -r build $out
    '';
  };

  meta = {
    description = "Fast, collaborative live terminal sharing over the web";
    homepage = "https://github.com/ekzhang/sshx";
    changelog = "https://github.com/ekzhang/sshx/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      pinpox
    ];
    mainProgram = "sshx-server";
  };
}
