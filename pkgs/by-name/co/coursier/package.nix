{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre,
  writeShellApplication,
  common-updater-scripts,
  gnugrep,
  coreutils,
  git,
  gnused,
  nix,
  zlib,
}:

let
  libPath = lib.makeLibraryPath [
    zlib # libz.so.1
  ];
in
stdenv.mkDerivation rec {
  pname = "coursier";
  version = "2.1.24";

  src = fetchurl {
    url = "https://github.com/coursier/coursier/releases/download/v${version}/coursier";
    hash = "sha256-eql18SRpcm1ruHhSEHr+C41vPIKxKknvQ8xmR8TgV8o=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -Dm555 $src $out/bin/cs
    patchShebangs $out/bin/cs
    wrapProgram $out/bin/cs \
      --prefix PATH ":" ${lib.makeBinPath [ jre ]} \
      --set JAVA_HOME ${jre.home} \
      --prefix LD_LIBRARY_PATH ":" ${libPath}

    runHook postInstall
  '';

  passthru.updateScript = {
    command = lib.getExe (writeShellApplication {
      name = "update-coursier";

      runtimeInputs = [
        common-updater-scripts
        coreutils
        git
        gnugrep
        gnused
        nix
      ];

      text = ''
        # stdout is reserved for the JSON --print-changes emits below, everything
        # else has to go to stderr.
        attr_path="''${UPDATE_NIX_ATTR_PATH:-coursier}"

        nixpkgs=$(git rev-parse --show-toplevel)
        position=$(nix-instantiate --eval --raw --attr "$attr_path.meta.position" "$nixpkgs")
        package_nix="''${position%:*}"
        old_version=$(nix-instantiate --eval --raw --attr "$attr_path.version" "$nixpkgs")

        # 'v*.*.*' also matches milestones such as v2.1.25-M26, which are not
        # releases, so keep only plain X.Y.Z and take the highest.
        new_version=$(git -c 'versionsort.suffix=-' ls-remote --exit-code --refs \
          --sort='version:refname' --tags https://github.com/coursier/coursier.git 'v*.*.*' \
          | cut --delimiter='/' --fields=3 \
          | grep -E '^v[0-9]+\.[0-9]+\.[0-9]+$' \
          | tail --lines=1 \
          | sed 's|^v||')

        if [[ -z "$new_version" ]]; then
          echo "no plain X.Y.Z tag found upstream" >&2
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

        # update-source-version rewrites package.nix with a fake hash and rebuilds
        # to discover the real one, so put the file back if that fails.
        backup=$(mktemp)
        cp "$package_nix" "$backup"
        trap 'cp "$backup" "$package_nix"; rm -f "$backup"' EXIT

        update-source-version "$attr_path" "$new_version" --version-key=version --print-changes

        trap - EXIT
        rm -f "$backup"
      '';
    });
    supportedFeatures = [ "commit" ];
  };

  meta = {
    homepage = "https://get-coursier.io/";
    changelog = "https://github.com/coursier/coursier/releases/tag/v${version}";
    description = "Scala library to fetch dependencies from Maven / Ivy repositories";
    mainProgram = "cs";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      adelbertc
      agilesteel
    ];
    # a shell script wrapping a java launcher, so it runs wherever the jre does
    platforms = jre.meta.platforms;
  };
}
