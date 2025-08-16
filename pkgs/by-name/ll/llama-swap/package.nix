{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  npmHooks,
  fetchNpmDeps,
  nodejs,
}:

let
  canExecute = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
in
buildGoModule (finalAttrs: {
  pname = "llama-swap";
  version = "149";

  src = fetchFromGitHub {
    owner = "mostlygeek";
    repo = "llama-swap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QTv12wTMEYeoJt4sO9L/oueXzDH7JyEO0hT4GXYCJBU=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      # '0000-00-00T00:00:00Z'
      date -u -d "@$(git log -1 --pretty=%ct)" "+'%Y-%m-%dT%H:%M:%SZ'" > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  vendorHash = "sha256-5mmciFAGe8ZEIQvXejhYN+ocJL3wOVwevIieDuokhGU=";

  nativeBuildInputs = [
    # additional requirements for the ui
    npmHooks.npmConfigHook
    nodejs
  ];
  # avoid npmConfigHook being loaded for go module fetching since it breaks it
  overrideModAttrs = oldAttrs: {
    nativeBuildInputs = lib.filter (drv: drv != npmHooks.npmConfigHook) oldAttrs.nativeBuildInputs;
  };

  npmRoot = "ui";
  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.npmRoot}";
    hash = "sha256-Sbvz3oudMVf+PxOJ6s7LsDaxFwvftNc8ZW5KPpbI/cA=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  preBuild = ''
    # ldflags based on metadata from git and source
    ldflags+=" -X main.commit=$(cat COMMIT)"
    ldflags+=" -X main.date=$(cat SOURCE_DATE_EPOCH)"

    # if npmHooks.npmConfigHook has ran
    if [ -n "$npmRoot" ]; then
      # build the ui
      pushd "$npmRoot"
      npm run build --legacy-peer-deps
      popd
    fi
  '';

  excludedPackages = [
    # regression testing tool
    "misc/process-cmd-test"
  ]
  ++ lib.optionals (!canExecute) [
    # some tests expect to execute simple-something
    # if it can't be executed it's unneeded
    "misc/simple-responder"
  ];

  # some tests expect to execute simple-something and proxy/helpers_test.go
  # checks the file exists
  doCheck = canExecute;
  preCheck = ''
    mkdir build
    ln -s "$GOPATH/bin/simple-responder" "./build/simple-responder_''${GOOS}_''${GOARCH}"
  '';
  postCheck = ''
    rm $GOPATH/bin/simple-responder
  '';

  preInstall = ''
    mkdir -p "$out/share/llama-swap/"
    cp config.example.yaml "$out/share/llama-swap/"
  '';

  meta = {
    description = "Model swapping for llama.cpp (or any local OpenAPI compatible server";
    homepage = "https://github.com/mostlygeek/llama-swap";
    changelog = "https://github.com/mostlygeek/llama-swap/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jk
    ];
    mainProgram = "llama-swap";
  };
})
