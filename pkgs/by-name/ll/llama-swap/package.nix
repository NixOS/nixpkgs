{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
}:

let
  version = "137";

  src = fetchFromGitHub {
    owner = "mostlygeek";
    repo = "llama-swap";
    rev = "v${version}";
    hash = "sha256-DyAbZMTy4gvmF8HnUJ5B4ypIqhL9MDS7zBzeQfapFD8=";
  };

  ui = buildNpmPackage (finalAttrs: {
    pname = "llama-swap-ui";
    inherit version src;

    postPatch = ''
      substituteInPlace vite.config.ts \
        --replace-fail '../proxy/ui_dist' '${placeholder "out"}/ui_dist'
    '';

    sourceRoot = "source/ui";

    npmDepsHash = "sha256-smdqD1X9tVr0XMhQYpLBZ57/3iP8tYVoVJ2wR/gAC3w=";

    postInstall = ''
      rm -rf $out/lib
    '';

    meta = {
      description = "llama-swap - UI";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ peterhoeg ];
      platforms = lib.platforms.unix;
    };
  });

in
buildGoModule rec {
  pname = "llama-swap";
  inherit version src;

  vendorHash = "sha256-nSdvqYVBBVIdoa991bLVwfHPGAO4OHzW8lEQPQ6cuMs=";

  preBuild = ''
    cp -r ${ui}/ui_dist proxy/
  '';

  subPackages =
    [
      "."
      "proxy"
    ]
    ++ lib.optionals doCheck [
      "misc/process-cmd-test"
      "misc/simple-responder"
    ];

  nativeBuildInputs = [ versionCheckHook ];

  ldflags = [
    "-X main.version=${version}"
    "-X main.date=unknown"
    "-X main.commit=v${version}"
  ];

  postInstall = ''
    install -Dm444 -t $out/share/doc/${pname} *.md *.yaml
    cp -r examples $out/share/doc/${pname}/
  '';

  # need to adjust proxy/helpers_test.go for it to find the binaries
  doCheck = false;
  # if we run the tests in installCheckPhase instead, adjust this
  postCheck = ''
    rm -f $out/bin/{process-cmd-test,simple-responder}
  '';

  doInstallCheck = true;
  versionCheckProgramArg = "-version";

  meta = {
    description = "Model swapping for llama.cpp (or any local OpenAPI compatible server)";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = lib.platforms.unix;
    mainProgram = "llama-swap";
  };
}
