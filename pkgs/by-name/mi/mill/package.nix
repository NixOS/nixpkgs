{
  autoPatchelfHook,
  fetchurl,
  jre,
  lib,
  makeWrapper,
  stdenvNoCC,
  zlib,
  writeShellApplication,
  stdenv,
  common-updater-scripts,
  coreutils,
  curl,
  git,
  gnugrep,
  gnused,
  jq,
  nix,
}:

let
  # One table per platform: the artifact suffix and its hash belong together, and
  # meta.platforms is derived from it so the two cannot drift.
  sources = {
    aarch64-darwin = {
      suffix = "native-mac-aarch64";
      hash = "sha256-zssJgQWY4QI0giYPGeviUbgZ2z8XtIyvkP0BoqcfRbc=";
    };
    aarch64-linux = {
      suffix = "native-linux-aarch64";
      hash = "sha256-dzIG8bO0vWtC/798LI0WjGIQ5PB1rgYIndz24P5dfbg=";
    };
    x86_64-linux = {
      suffix = "native-linux-amd64";
      hash = "sha256-umDQNXc4CpBsInPMp2VoKHBeJf71GaHpJ2Vq4Wfo9kQ=";
    };
  };

  source =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenvNoCC.mkDerivation rec {
  pname = "mill";
  version = "1.1.8";

  src = fetchurl {
    url = "https://repo1.maven.org/maven2/com/lihaoyi/mill-dist-${source.suffix}/${version}/mill-dist-${source.suffix}-${version}.exe";
    inherit (source) hash;
  };

  buildInputs = [ zlib ];
  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optional stdenvNoCC.hostPlatform.isLinux autoPatchelfHook;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  # this is mostly downloading a pre-built artifact
  preferLocalBuild = true;

  # the daemon mill starts is Java 17 bytecode; upstream's "every JVM from 11
  # onward" is about the JVMs a build may target, not the one mill runs on
  installPhase =
    assert lib.assertMsg (lib.versionAtLeast jre.version "17.0.0") ''
      mill requires Java 17 or newer, but ${jre.name} is ${jre.version}
    '';
    ''
      runHook preInstall

      install -Dm 555 $src $out/bin/.mill-wrapped
      # can't use wrapProgram because it sets --argv0
      makeWrapper $out/bin/.mill-wrapped $out/bin/mill \
        --prefix PATH : "${lib.makeBinPath [ jre ]}" \
        --set JAVA_HOME "${jre.home}"

      runHook postInstall
    '';

  passthru.updateScript = {
    command = lib.getExe (writeShellApplication {
      name = "update-mill";

      runtimeInputs = [
        common-updater-scripts
        coreutils
        curl
        git
        gnugrep
        gnused
        jq
        nix
      ];

      text = ''
        # stdout is reserved for the JSON expected by the `commit` updateScript
        # feature, everything else has to go to stderr.
        attr_path="''${UPDATE_NIX_ATTR_PATH:-mill}"

        nixpkgs=$(git rev-parse --show-toplevel)
        position=$(nix-instantiate --eval --raw --attr "$attr_path.meta.position" "$nixpkgs")
        package_nix="''${position%:*}"
        old_version=$(nix-instantiate --eval --raw --attr "$attr_path.version" "$nixpkgs")

        # Maven's <release>/<latest> just reflect whatever was published most
        # recently, which for mill includes milestones (-M1, -M2, ...) and
        # per-commit dev builds (-N-<sha>). Filter the full <version> list down to
        # plain X.Y.Z semver and take the highest.
        new_version=$(curl --silent --show-error --fail \
          "https://repo1.maven.org/maven2/com/lihaoyi/mill-dist/maven-metadata.xml" \
          | grep -oE '<version>[0-9]+\.[0-9]+\.[0-9]+</version>' \
          | sed -E 's#</?version>##g' \
          | sort -V \
          | tail -n1)

        if [[ -z "$new_version" ]]; then
          echo "no plain X.Y.Z release found in the maven metadata" >&2
          exit 1
        fi

        order=$(nix-instantiate --eval \
          --expr "builtins.compareVersions \"$new_version\" \"$old_version\"")

        case "$order" in
          0)
            echo "$attr_path is already at the latest version $new_version." >&2
            echo '[]'
            exit 0
            ;;
          -1)
            echo "refusing to downgrade $attr_path from $old_version to $new_version." >&2
            exit 1
            ;;
        esac

        # update-source-version rewrites package.nix in place, once per platform,
        # so put the file back if any of them fails rather than leaving it half
        # updated.
        backup=$(mktemp)
        cp "$package_nix" "$backup"
        trap 'cp "$backup" "$package_nix"; rm -f "$backup"' EXIT

        refresh() {
          local system="$1" suffix="$2" hash
          hash=$(nix-hash --to-sri --type sha256 "$(nix-prefetch-url \
            "https://repo1.maven.org/maven2/com/lihaoyi/mill-dist-$suffix/$new_version/mill-dist-$suffix-$new_version.exe")")

          update-source-version "$attr_path" "$new_version" "$hash" \
            --system="$system" --ignore-same-version >&2
        }

        ${lib.concatMapStrings (system: ''
          refresh ${system} ${sources.${system}.suffix}
        '') (builtins.attrNames sources)}

        trap - EXIT
        rm -f "$backup"

        jq --null-input --compact-output \
          --arg attrPath "$attr_path" \
          --arg oldVersion "$old_version" \
          --arg newVersion "$new_version" \
          --arg file "$package_nix" \
          '[ {
            attrPath: $attrPath,
            oldVersion: $oldVersion,
            newVersion: $newVersion,
            files: [ $file ],
            commitBody: "https://github.com/com-lihaoyi/mill/releases/tag/\($newVersion)"
          } ]'
      '';
    });
    supportedFeatures = [ "commit" ];
  };

  meta = {
    homepage = "https://com-lihaoyi.github.io/mill/";
    changelog = "https://github.com/com-lihaoyi/mill/releases/tag/${version}";
    license = lib.licenses.mit;
    description = "Build tool for Scala, Java and more";
    mainProgram = "mill";
    longDescription = ''
      Mill is a build tool borrowing ideas from modern tools like Bazel, to let you build
      your projects in a way that's simple, fast, and predictable. Mill has built in
      support for the Scala programming language, and can serve as a replacement for
      SBT, but can also be extended to support any other language or platform via
      modules (written in Java or Scala) or through an external subprocesses.
    '';
    maintainers = with lib.maintainers; [
      agilesteel
      zenithal
    ];
    platforms = builtins.attrNames sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
