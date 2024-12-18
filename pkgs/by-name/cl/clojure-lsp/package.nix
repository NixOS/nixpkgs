{
  lib,
  buildGraalvmNativeImage,
  fetchurl,
  fetchFromGitHub,
  writeScript,
  testers,
  clojure-lsp,
}:

buildGraalvmNativeImage rec {
  pname = "clojure-lsp";
  version = "2024.11.08-17.49.29";

  src = fetchFromGitHub {
    owner = "clojure-lsp";
    repo = "clojure-lsp";
    rev = version;
    hash = "sha256-pvIfW96RaJXMIDPKHfJjds9dU6IuC2f1TwdI8X/JTw0=";
  };

  jar = fetchurl {
    url = "https://github.com/clojure-lsp/clojure-lsp/releases/download/${version}/clojure-lsp-standalone.jar";
    hash = "sha256-QMc62p6qFTh+y4C5aBGuZX/pQZQSywbYCFA1nYIY/80=";
  };

  extraNativeImageBuildArgs = [
    # These build args mirror the build.clj upstream
    # ref: https://github.com/clojure-lsp/clojure-lsp/blob/2024.08.05-18.16.00/cli/build.clj#L141-L144
    "--no-fallback"
    "--native-image-info"
    "--features=clj_easy.graal_build_time.InitClojureClasses"
  ];

  doCheck = true;
  checkPhase =
    ''
      runHook preCheck

      export HOME="$(mktemp -d)"
      ./clojure-lsp --version | fgrep -q '${version}'
    ''
    # TODO: fix classpath issue per https://github.com/NixOS/nixpkgs/pull/153770
    #${babashka}/bin/bb integration-test ./clojure-lsp
    + ''
      runHook postCheck
    '';

  passthru.tests.version = testers.testVersion {
    inherit version;
    package = clojure-lsp;
    command = "clojure-lsp --version";
  };

  passthru.updateScript = writeScript "update-clojure-lsp" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl common-updater-scripts gnused jq nix

    set -eu -o pipefail

    latest_version=$(curl -s https://api.github.com/repos/clojure-lsp/clojure-lsp/releases/latest | jq --raw-output .tag_name)

    old_jar_hash=$(nix-instantiate --eval --strict -A "clojure-lsp.jar.drvAttrs.outputHash" | tr -d '"' | sed -re 's|[+]|\\&|g')

    curl -o clojure-lsp-standalone.jar -sL https://github.com/clojure-lsp/clojure-lsp/releases/download/$latest_version/clojure-lsp-standalone.jar
    new_jar_hash=$(nix-hash --flat --type sha256 clojure-lsp-standalone.jar | sed -re 's|[+]|\\&|g')

    rm -f clojure-lsp-standalone.jar

    nixFile=$(nix-instantiate --eval --strict -A "clojure-lsp.meta.position" | sed -re 's/^"(.*):[0-9]+"$/\1/')

    sed -i "$nixFile" -re "s|\"$old_jar_hash\"|\"$new_jar_hash\"|"
    update-source-version clojure-lsp "$latest_version"
  '';

  meta = {
    description = "Language Server Protocol (LSP) for Clojure";
    homepage = "https://github.com/clojure-lsp/clojure-lsp";
    changelog = "https://github.com/clojure-lsp/clojure-lsp/releases/tag/${version}";
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ericdallo ];
  };
}
