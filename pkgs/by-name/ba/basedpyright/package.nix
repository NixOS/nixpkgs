{
  lib,
  fetchFromGitHub,
  runCommand,
  stdenv,
  clang_20,
  nodejs,
  pnpm_11,
  pnpmConfigHook,
  fetchPnpmDeps,
  makeWrapper,
  docify,
  testers,
  writeText,
  jq,
  basedpyright,
  pkg-config,
  libsecret,
  nix-update-script,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "basedpyright";
  version = "1.40.2";

  src = fetchFromGitHub {
    owner = "detachhead";
    repo = "basedpyright";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HiF6TaZWuRisPBJ8a39SwnTGL+ghv4LQ0v5zuq/RPaA=";
  };

  # packages/pyright bundles ../pyright-internal, so both workspaces' deps are needed.
  # names must match "name" in packages/pyright/package.json and packages/pyright-internal/package.json
  pnpmWorkspaces = [
    "basedpyright"
    "pyright-internal"
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    pnpm = pnpm_11;
    fetcherVersion = 5;
    hash = "sha256-/81bd9hAeNQweWk8UOTDZHewbCT55Sa2GbYGYYvMR5c=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    nodejs
    pnpm_11
    pnpmConfigHook
    makeWrapper
    docify
    pkg-config
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin clang_20; # clang_21 breaks keytar

  buildInputs = [ libsecret ];

  buildPhase = ''
    runHook preBuild

    # Build the docstubs
    cp -r packages/pyright-internal/typeshed-fallback docstubs
    docify docstubs/stdlib --builtins-only --in-place

    pnpm --filter basedpyright run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    pkg=$out/lib/node_modules/basedpyright
    mkdir -p $pkg $out/bin
    cp -r packages/pyright/{dist,index.js,langserver.index.js,package.json} $pkg/

    makeWrapper ${lib.getExe nodejs} $out/bin/basedpyright \
      --add-flags $pkg/index.js
    makeWrapper ${lib.getExe nodejs} $out/bin/basedpyright-langserver \
      --add-flags $pkg/langserver.index.js

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      # We are expecting 4 errors. Any other amount would indicate not working
      # stub files, for instance.
      simple = testers.testEqualContents {
        assertion = "simple type checking";
        expected = writeText "expected" ''
          4
        '';
        actual =
          runCommand "actual"
            {
              nativeBuildInputs = [
                jq
                basedpyright
              ];
              base = writeText "test.py" ''
                import sys
                from time import tzset

                def print_string(a_string: str):
                    a_string += 42
                    print(a_string)

                if sys.platform == "win32":
                    print_string(69)
                    this_function_does_not_exist("nice!")
                else:
                    result_of_tzset_is_None: str = tzset()
              '';
              configFile = writeText "pyproject.toml" ''
                [tool.pyright]
                typeCheckingMode = "strict"
              '';
            }
            ''
              (basedpyright --outputjson $base || true) | jq -r .summary.errorCount > $out
            '';
      };
    };
  };

  meta = {
    changelog = "https://github.com/detachhead/basedpyright/releases/tag/${finalAttrs.src.tag}";
    description = "Type checker for the Python language";
    homepage = "https://github.com/detachhead/basedpyright";
    license = lib.licenses.mit;
    mainProgram = "basedpyright";
    maintainers = with lib.maintainers; [
      kiike
      misilelab
      sachin-sankar
    ];
  };
})
