{
  writeShellApplication,
  common-updater-scripts,
  nix-update,
  yq-go,
  dart,
  nix,
}:
let
  name = "update-pana";
  packageName = "pana";
  packageDir = toString ./.;
in
writeShellApplication {
  inherit name;
  runtimeInputs = [
    common-updater-scripts
    nix-update
    yq-go
    dart
    nix
  ];
  text = ''
    pname="''${UPDATE_NIX_PNAME:-${packageName}}"

    main() {
      old_version="''${UPDATE_NIX_OLD_VERSION:-$(get_version)}"
      nix-update "$pname" --version stable
      new_version=$(get_version)
      if [[ "$new_version" == "$old_version" ]]; then
        exit 0
      fi
      generate_lockfile
    }

    get_version() {
      nix-instantiate --raw --eval --strict -A "$pname.version"
    }

    generate_lockfile() {
      tmp_dir=$(mktemp -d)
      trap 'rm -rf "$tmp_dir"' EXIT

      src=$(nix-build --no-link . -A "$pname.src")

      cp -r "$src/." "$tmp_dir/"
      chmod -R +w "$tmp_dir"
      cd "$tmp_dir"

      # Generate lockfile because it's not included in the source
      if ! test -f pubspec.lock; then
        dart pub get
      fi

      # Convert to JSON
      yq -o=json . pubspec.lock > "${packageDir}/pubspec.lock.json"
    }

    main
  '';
}
