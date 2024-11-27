{ lib
, stdenvNoCC
, fetchurl
, autoPatchelfHook
, unzip
, installShellFiles
, makeWrapper
, openssl
, writeShellScript
, curl
, jq
, common-updater-scripts
, darwin
}:

stdenvNoCC.mkDerivation rec {
  version = "1.1.34";
  pname = "bun";

  src = passthru.sources.${stdenvNoCC.hostPlatform.system} or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");

  strictDeps = true;
  nativeBuildInputs = [ unzip installShellFiles makeWrapper ] ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs = [ openssl ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm 755 ./bun $out/bin/bun
    ln -s $out/bin/bun $out/bin/bunx

    runHook postInstall
  '';

  postPhases = [ "postPatchelf"];
  postPatchelf =
    lib.optionalString stdenvNoCC.hostPlatform.isDarwin ''
      wrapProgram $out/bin/bun \
        --prefix DYLD_LIBRARY_PATH : ${lib.makeLibraryPath [ darwin.ICU ]}
    ''
    # We currently cannot generate completions for x86_64-darwin because bun requires avx support to run, which is:
    # 1. Not currently supported by the version of Rosetta on our aarch64 builders
    # 2. Is not correctly detected even on macOS 15+, where it is available through Rosetta
    #
    # The baseline builds are no longer an option because they too now require avx support.
    + lib.optionalString
      (
        stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform
        && !(stdenvNoCC.hostPlatform.isDarwin && stdenvNoCC.hostPlatform.isx86_64)
      )
      ''
        completions_dir=$(mktemp -d)

        SHELL="bash" $out/bin/bun completions $completions_dir
        SHELL="zsh" $out/bin/bun completions $completions_dir
        SHELL="fish" $out/bin/bun completions $completions_dir

        installShellCompletion --name bun \
          --bash $completions_dir/bun.completion.bash \
          --zsh $completions_dir/_bun \
          --fish $completions_dir/bun.fish
      '';

  passthru = {
    sources = {
      "aarch64-darwin" = fetchurl {
        url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-aarch64.zip";
        hash = "sha256-unFn4bexupfjtFA6Nxzi/vC1stzuBXYP5jPfwXbZDig=";
      };
      "aarch64-linux" = fetchurl {
        url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-aarch64.zip";
        hash = "sha256-BIYlEyRuyUdvipsCVEHTORlJoAnH+rv1ogv10JUHyOA=";
      };
      "x86_64-darwin" = fetchurl {
        url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-x64-baseline.zip";
        hash = "sha256-gpcDIY1IYHO0N9Quw79VonhFHdgb/NFZns2hGNuQe9g=";
      };
      "x86_64-linux" = fetchurl {
        url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64.zip";
        hash = "sha256-S8AA/1CWxTSHZ60E2ZNQXyEAOalYgCc6dte9CvD8Lx8=";
      };
    };
    updateScript = writeShellScript "update-bun" ''
      set -o errexit
      export PATH="${lib.makeBinPath [ curl jq common-updater-scripts ]}"
      NEW_VERSION=$(curl --silent https://api.github.com/repos/oven-sh/bun/releases/latest | jq '.tag_name | ltrimstr("bun-v")' --raw-output)
      if [[ "${version}" = "$NEW_VERSION" ]]; then
          echo "The new version same as the old version."
          exit 0
      fi
      for platform in ${lib.escapeShellArgs meta.platforms}; do
        update-source-version "bun" "$NEW_VERSION" --ignore-same-version --source-key="sources.$platform"
      done
    '';
  };
  meta = with lib; {
    homepage = "https://bun.sh";
    changelog = "https://bun.sh/blog/bun-v${version}";
    description = "Incredibly fast JavaScript runtime, bundler, transpiler and package manager – all in one";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    longDescription = ''
      All in one fast & easy-to-use tool. Instead of 1,000 node_modules for development, you only need bun.
    '';
    license = with licenses; [
      mit # bun core
      lgpl21Only # javascriptcore and webkit
    ];
    mainProgram = "bun";
    maintainers = with maintainers; [ DAlperin jk thilobillerbeck cdmistman coffeeispower diogomdp ];
    platforms = builtins.attrNames passthru.sources;
    # Broken for Musl at 2024-01-13, tracking issue:
    # https://github.com/NixOS/nixpkgs/issues/280716
    broken = stdenvNoCC.hostPlatform.isMusl;

    # Hangs when run via Rosetta 2 on Apple Silicon
    hydraPlatforms = lib.lists.remove "x86_64-darwin" lib.platforms.all;
  };
}
