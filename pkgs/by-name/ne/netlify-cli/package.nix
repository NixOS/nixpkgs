{
  buildNpmPackage,
  callPackage,
  fetchFromGitHub,
  lib,
  nix-update-script,
  nodejs,
  pkg-config,
  vips,
  installShellFiles,
}:

buildNpmPackage rec {
  pname = "netlify-cli";
  version = "23.9.2";

  src = fetchFromGitHub {
    owner = "netlify";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-rjxm/TrKsvYCKwoHkZRZXFpFTfLd0s0D/H6p5Bull0E=";
  };

  # Prevent postinstall script from running before package is built
  # See https://github.com/netlify/cli/blob/v23.9.2/scripts/postinstall.js#L70
  postPatch = ''
    touch .git
  '';

  # Completions instalation CLI depends on an interactive user prompt for shell and confirmation
  # Use @pnpm/tabtab API to generate them in separate files without trying to install them.
  postInstall = ''
    completer="$out/lib/node_modules/netlify-cli/dist/lib/completion/script.js"
    chmod a+x "$completer"
    node <<EOF
    import { writeFile } from 'node:fs/promises';
    import { getCompletionScript } from '@pnpm/tabtab';
    const name = 'netlify';
    const completer = '$completer';
    await Promise.all(["bash", "zsh", "fish"].map(async shell =>
      await writeFile('netlify.' + shell, await getCompletionScript({name, completer, shell}))
    ));
    EOF
    installShellCompletion netlify.{bash,fish,zsh}
  '';

  npmDepsHash = "sha256-itzEmCOBXxspGiwxt8t6di7/EuCo2Qkl5JVSkMfUemI=";

  inherit nodejs;

  buildInputs = [ vips ];
  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  passthru = {
    tests.test = callPackage ./test.nix { };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Netlify command line tool";
    homepage = "https://github.com/netlify/cli";
    changelog = "https://github.com/netlify/cli/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ roberth ];
    mainProgram = "netlify";
  };
}
