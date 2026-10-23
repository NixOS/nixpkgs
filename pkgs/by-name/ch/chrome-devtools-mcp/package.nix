{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchgit,
  installAgentSkills,
  makeWrapper,
  nix-update-script,
  versionCheckHook,
}:

buildNpmPackage (finalAttrs: {
  pname = "chrome-devtools-mcp";
  version = "1.12.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ChromeDevTools";
    repo = "chrome-devtools-mcp";
    tag = "chrome-devtools-mcp-v${finalAttrs.version}";
    hash = "sha256-Y/9jlYVHGbRtD8w8Y93WP0O2nzKspVBKcisewxC1Tew=";
  };

  # Git submodule third_party/devtools-frontend, fetched with the same sparse
  # checkout upstream's scripts/prepare.ts uses (the full repository is huge).
  # Update the rev together with the version: `git ls-tree <tag> third_party/`.
  devtools-frontend = fetchgit {
    url = "https://github.com/ChromeDevTools/devtools-frontend.git";
    rev = "f22c645573adc85e4553747c577eebb874c3fb43";
    sparseCheckout = [
      "/*"
      "!/*/"
      "/front_end/"
      "!/front_end/panels/"
      "!/front_end/ui/"
      "/mcp/"
      "/extension-api/"
    ];
    nonConeMode = true;
    fetchSubmodules = false;
    hash = "sha256-uwOZ4PPDn68BOWugtst2NAUK+dzJ6/58nZMfhFn66NA=";
  };

  npmDepsHash = "sha256-CEYtrmCDO+EeKoScH8IO+jsJCrkvzJKqqeoT+yqD1FU=";

  nativeBuildInputs = [
    installAgentSkills
    makeWrapper
  ];

  env.PUPPETEER_SKIP_DOWNLOAD = "1";

  postPatch = ''
    cp -r --no-preserve=mode ${finalAttrs.devtools-frontend}/. third_party/devtools-frontend/
  '';

  # `npm rebuild` does not run the root package's prepare script, which strips a
  # conflicting global declaration from @paulirish/trace_engine.
  preBuild = ''
    node scripts/prepare.ts
  '';

  # Bundles all dependencies into build/src with rollup.
  npmBuildScript = "bundle";

  # the source tree and node_modules contain SKILL.md files of other projects
  dontInstallAgentSkills = true;

  postInstall = ''
    for skill in skills/*/; do
      installSkill "$skill"
    done
  '';

  postFixup = ''
    for bin in $out/bin/*; do
      wrapProgram "$bin" --set-default CHROME_DEVTOOLS_MCP_NO_UPDATE_CHECKS 1
    done
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "chrome-devtools-mcp-v(.*)"
    ];
  };

  meta = {
    description = "MCP server that lets coding agents control and inspect a live Chrome browser";
    longDescription = ''
      Chrome DevTools MCP lets coding agents control and inspect a live Chrome
      browser: automation through Puppeteer, performance traces, network and
      console inspection, screenshots and Lighthouse audits.

      It looks for Chrome at the standard Google Chrome install location. On
      NixOS, pass `--executable-path` (for example the path of `chromium` or
      `google-chrome-stable`), or connect to a running browser with
      `--browser-url`.
    '';
    homepage = "https://github.com/ChromeDevTools/chrome-devtools-mcp";
    changelog = "https://github.com/ChromeDevTools/chrome-devtools-mcp/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ slopinger ];
    mainProgram = "chrome-devtools-mcp";
  };
})
