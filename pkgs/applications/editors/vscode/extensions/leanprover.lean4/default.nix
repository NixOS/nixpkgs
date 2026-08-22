{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchNpmDeps,
  clang_20,
  elan,
  libsecret,
  nix-update-script,
  nodejs,
  npmHooks,
  pkg-config,
  replaceVars,
  strip-nondeterminism,
  vscode-utils,
}:

let
  vsix = stdenv.mkDerivation (finalAttrs: {
    name = "leanprover-lean4-${finalAttrs.version}.vsix";
    pname = "leanprover-lean4-vsix";
    version = "0.0.239";

    src = fetchFromGitHub {
      owner = "leanprover";
      repo = "vscode-lean4";
      tag = "v${finalAttrs.version}";
      hash = "sha256-aa3AFcxGpJMiKcoZbb5bhRglFpA2cXeUMjg/yWRyg94=";
    };

    npmDeps = fetchNpmDeps {
      name = "${finalAttrs.pname}-npm-deps";
      inherit (finalAttrs) src;
      # `npmConfigHook` diffs the lockfile in the unpacked source against the one
      # recorded here, so any patch that touches the lockfile has to be applied
      # on both sides.
      patches = [ ./sync-glob-version-with-lockfile.patch ];
      fetcherVersion = 2;
      hash = "sha256-wjimqeiqeXpHFsfarxdb2KRMAeS7X3VrXEpjb3HJv/A=";
    };

    buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libsecret ];

    nativeBuildInputs = [
      nodejs
      nodejs.python
      npmHooks.npmConfigHook
      strip-nondeterminism
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      clang_20 # clang_21 breaks @vscode/vsce's optional dependency keytar
    ];

    patches = [
      # Upstream's package-lock.json pins `glob` 11.0.1 in the `vscode-lean4`
      # workspace while its package.json asks for `^10.4.5`. `npm ci` tries to
      # resolve the range against the registry, and the offline cache only holds
      # the versions the lockfile mentions, so the build fails. Make the manifest
      # agree with the lockfile so that no resolution is needed.
      #
      # Identical to the upstream fix; drop this, along with the copy in
      # `npmDeps.patches`, once a release containing it is packaged here.
      # TODO: link the upstream pull request.
      ./sync-glob-version-with-lockfile.patch

      # Opening a Lean file with no `lean` on the PATH makes the extension offer
      # to download and install Lean's version manager Elan itself. Teach it to
      # fall back to an Elan supplied at build time instead, so that no
      # out-of-band installation is needed.
      (replaceVars ./use-builtin-elan.patch { elan = lib.getBin elan; })
    ];

    strictDeps = true;

    env.NX_DAEMON = "false";

    buildPhase = ''
      runHook preBuild

      npm run build
      # `vsce package` must run from the extension's own workspace, not the
      # repository root.
      (cd vscode-lean4 && npx vsce package --out $out)
      # `vsce` stamps every zip entry with the current time, so the vsix is not
      # reproducible as it comes out.
      strip-nondeterminism --type zip $out

      runHook postBuild
    '';
  });
in
vscode-utils.buildVscodeExtension (finalAttrs: {
  pname = "leanprover-lean4";
  inherit (finalAttrs.src) version;

  vscodeExtPublisher = "leanprover";
  vscodeExtName = "lean4";
  vscodeExtUniqueId = "${finalAttrs.vscodeExtPublisher}.${finalAttrs.vscodeExtName}";

  src = vsix;

  # The `elan` path that `use-builtin-elan.patch` bakes into the bundle only
  # survives as a registered store reference if `elan` is also an input of this
  # derivation: Nix records references to the derivation's own inputs, and the
  # inner vsix derivation cannot register it either because the string is
  # compressed inside the zip where the scanner will not find it.
  buildInputs = [ elan ];

  passthru = {
    vsix = finalAttrs.src;
    updateScript = nix-update-script {
      attrPath = "vscode-extensions.leanprover.lean4.vsix";
    };
  };

  meta = {
    description = "This extension provides VS Code support for the Lean 4 theorem prover and programming language";
    downloadPage = "https://marketplace.visualstudio.com/items?itemName=leanprover.lean4";
    homepage = "https://github.com/leanprover/vscode-lean4";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ alexstaeding ];
  };
})
