{
  lib,
  buildNpmPackage,
  fetchurl,
  makeWrapper,
  nodejs_24,
  procps,
  versionCheckHook,
}:

buildNpmPackage (
  finalAttrs:
  let
    # Anchors rewritten by update.sh
    version = "6.5.0";
    srcHash = "sha256-UxcXoG6SymUaq1JpEZD5FvrARCcsAfh14ixeKTIY5pk=";
    lockfileHash = "sha256-BIIIU3LFY8mbMlGfUTOesoCtwr2D79umqO/XzUpJ6fA=";

    # The npm tarball ships prebuilt dist/ (building from source would require
    # the upstream turbo monorepo toolchain) but no lockfile; take the lockfile
    # from the matching release tag instead of vendoring it into the tree.
    # Tag names have no "v" prefix.
    lockfile = fetchurl {
      name = "rea-agents-${version}-package-lock.json";
      url = "https://raw.githubusercontent.com/morluto/rea/rea-agents-${version}/package-lock.json";
      hash = lockfileHash;
    };
  in
  {
    pname = "rea";
    inherit version;
    __structuredAttrs = true;

    src = fetchurl {
      url = "https://registry.npmjs.org/rea-agents/-/rea-agents-${version}.tgz";
      hash = srcHash;
    };

    postPatch = ''
      cp ${lockfile} package-lock.json
    '';

    npmDepsHash = "sha256-EQKhS1S7Hsfjbo5GikMeAFc2HFtALsDcw6XnJATUryw=";

    # frida (optional dependency) installs a platform binary via
    # prebuild-install, which cannot work in the sandbox. None of the other
    # dependencies have install scripts.
    npmFlags = [ "--ignore-scripts" ];

    # dist/ in the npm tarball is already built
    dontNpmBuild = true;

    # engines: ^22.19.0 || ^24.11.0 || >=26.0.0
    nodejs = nodejs_24;

    nativeBuildInputs = [ makeWrapper ];

    postInstall = ''
      # Without its platform binary the frida JS binding fails at load time
      # with a misleading error; remove it so that frida reports as missing.
      rm -rf "$out/lib/node_modules/rea-agents/node_modules/frida"

      # Upstream requires ps for Linux owned-process analysis
      wrapProgram "$out/bin/rea" --prefix PATH : ${lib.makeBinPath [ procps ]}
      wrapProgram "$out/bin/rea-agents" --prefix PATH : ${lib.makeBinPath [ procps ]}
    '';

    doInstallCheck = true;
    nativeInstallCheckInputs = [ versionCheckHook ];

    passthru.updateScript = ./update.sh;

    meta = {
      description = "Reverse engineer anything from your terminal or agent with one CLI and MCP server";
      homepage = "https://github.com/morluto/rea";
      changelog = "https://github.com/morluto/rea/releases/tag/rea-agents-${version}";
      license = lib.licenses.mit;
      mainProgram = "rea";
      maintainers = with lib.maintainers; [ luochen1990 ];
      platforms = lib.platforms.linux;
    };
  }
)
