{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
}:

let
  version = "129";

  src = fetchFromGitHub {
    owner = "mostlygeek";
    repo = "llama-swap";
    rev = "v${version}";
    hash = "sha256-4PKQpX6jnvLGNfGoVIf34Nntm05ncfmioqRS51Z3LXg=";
  };

  ui = buildNpmPackage (finalAttrs: {
    pname = "llama-swap-ui";
    inherit version src;

    postPatch = ''
      substituteInPlace vite.config.ts \
      --replace '../proxy/ui_dist' '${placeholder "out"}/ui_dist'
    '';

    sourceRoot = "source/ui";

    npmDepsHash = "sha256-smdqD1X9tVr0XMhQYpLBZ57/3iP8tYVoVJ2wR/gAC3w=";

    postInstall = ''
      rm -rf $out/lib
    '';

    meta = {
      description = "llama-swap - UI";
      license = lib.licenses.mit;
      platforms = lib.platforms.linux;
    };
  });

in
buildGoModule rec {
  pname = "llama-swap";
  inherit version src;

  vendorHash = "sha256-5mmciFAGe8ZEIQvXejhYN+ocJL3wOVwevIieDuokhGU=";

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
    platforms = lib.platforms.linux;
    mainProgram = "llama-swap";
  };
}
