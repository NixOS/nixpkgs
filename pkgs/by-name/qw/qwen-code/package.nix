{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  git,
  ripgrep,
  pkg-config,
  glib,
  libsecret,
  versionCheckHook,
  clang_20,
  makeSetupHook,
  writeText,
}:

let
  # https://github.com/numtide/llm-agents.nix/blob/main/packages/darwinOpenptyHook/package.nix
  darwinOpenptyHook =
    let
      header = writeText "darwin-openpty-shim.h" ''
        #ifndef DARWIN_OPENPTY_SHIM_H
        #define DARWIN_OPENPTY_SHIM_H
        /*
         * https://github.com/NixOS/nixpkgs/issues/457238
         *
         * macOS node-gyp builds sometimes see src/util.h from Node.js instead of
         * the SDK's util.h. That header does not declare openpty(3)/forkpty(3),
         * which causes node-pty (and other consumers) to fail to build. Including
         * this shim restores the missing declarations without depending on the
         * system header lookup.
         */
        #include <sys/types.h>
        struct termios;
        struct winsize;
        #ifdef __cplusplus
        extern "C" {
        #endif
        int openpty(int *, int *, char *, struct termios *, struct winsize *);
        pid_t forkpty(int *, char *, struct termios *, struct winsize *);
        #ifdef __cplusplus
        }
        #endif
        #endif /* DARWIN_OPENPTY_SHIM_H */
      '';
      hookScript = writeText "darwin-openpty-hook.sh" ''
        # shellcheck shell=bash
        if [ -z "''${darwinOpenptyHookApplied-}" ]; then
          export NIX_CFLAGS_COMPILE="''${NIX_CFLAGS_COMPILE-} -include ${header}"
          darwinOpenptyHookApplied=1
        fi
      '';
    in
    makeSetupHook {
      name = "darwin-openpty-hook";
      meta = {
        description = "Setup hook that injects openpty/forkpty prototypes on Darwin";
        platforms = lib.platforms.darwin;
      };
      passthru = {
        hideFromDocs = true;
      };
    } hookScript;
in
buildNpmPackage (finalAttrs: {
  pname = "qwen-code";
  version = "0.23.4";

  src = fetchFromGitHub {
    owner = "QwenLM";
    repo = "qwen-code";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AWmZhul7/p1atYkLZd/pojGaO80gydGfx+mnSP9SHnY=";
  };

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-tyLLtckMO/jFQHvdhHBWIE2Gx5vdHJBYHssVdq/abBU=";

  makeCacheWritable = true;

  nativeBuildInputs = [
    pkg-config
    git
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    clang_20 # Works around node-addon-api constant expression issue with clang 21+ (keytar)
    darwinOpenptyHook
  ];

  buildInputs = [
    ripgrep
    glib
    libsecret
  ];

  buildPhase = ''
    runHook preBuild

    # Increase Node.js heap size on Darwin to prevent OOM during
    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      export NODE_OPTIONS="--max-old-space-size=8192"
    ''}

    # npmConfigHook only patches the root node_modules. Workspaces with
    # nested .bin (web-shell's vite) keep /usr/bin/env otherwise.
    patchShebangs packages/*/node_modules

    npm run generate

    # The CLI esbuild bundle resolves imports against workspace dist/ output.
    # Use upstream's --cli-only build order so every workspace the bundle pulls
    # in (core, channels, acp-bridge, sdk-typescript, ...) is built, without
    # us having to track the dependency list by hand across releases.
    node scripts/build.js --cli-only

    npm run bundle

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/qwen-code

    cp -r dist/* $out/share/qwen-code/

    # The bundled dist/cli.js has no shebang; upstream ships a bin wrapper
    # (scripts/cli-entry.js) that relaunches cli.js with node --expose-gc and
    # reads package.json for the reported version. Install both next to cli.js.
    cp scripts/cli-entry.js $out/share/qwen-code/cli-entry.js
    cp package.json $out/share/qwen-code/package.json

    # Install production dependencies only
    npm prune --production
    cp -r node_modules $out/share/qwen-code/

    # Remove broken symlinks that cause issues in Nix environment
    find $out/share/qwen-code/node_modules -type l -delete || true

    patchShebangs $out/share/qwen-code

    ln -s $out/share/qwen-code/cli-entry.js $out/bin/qwen

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Coding agent that lives in digital world";
    homepage = "https://github.com/QwenLM/qwen-code";
    mainProgram = "qwen";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      lonerOrz
    ];
  };
})
