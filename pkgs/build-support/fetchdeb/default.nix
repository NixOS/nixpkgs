{
  lib,
  fetchurl,
  dpkg,
}:

args:

let
  basename = builtins.baseNameOf (args.url or (lib.head args.urls));
  name = args.name or (
    if lib.match ".*\\.deb$" basename != null
    then lib.substring 0 (lib.stringLength basename - 4) basename
    else basename
  );
in
fetchurl (
  args
  // {
    inherit name;
    nativeBuildInputs = [ dpkg ];
    downloadToTemp = true;
    recursiveHash = true;
    postFetch = ''
      # Step 1: Unpack and extract
      dpkg-deb -x $downloadedFile $out

      # Step 2: Fix dangling symlinks
      find "$out" -type l | while read -r symlink; do
        target=$(readlink "$symlink")
        
        # Skip if the symlink is not dangling
        if [ -e "$symlink" ]; then
          continue
        fi

        echo "Dangling symlink: $symlink -> $target"

        # Try resolving with parent directories as potential roots
        current_dir=$(dirname "$symlink")
        while [ "$current_dir" != "/" ]; do
          new_target="$current_dir/$target"
          if [ -e "$new_target" ]; then
            # Calculate a relative path from the symlink's directory to the resolved target
            relative_target=$(realpath --relative-to="$(dirname "$symlink")" "$new_target")
            echo "Resolved to: $symlink -> $relative_target"

            # Replace the symlink with the resolved relative path
            ln -sf "$relative_target" "$symlink"
            break
          fi
          current_dir=$(dirname "$current_dir") # Move to the parent directory
        done

        # If unresolved, delete the symlink
        if [ ! -e "$symlink" ]; then
          echo "Unable to resolve: $symlink"
          rm $symlink
        fi
      done

      # Step 3: Fix permissions
      find $out -exec chmod ugo+rX {} +
      find $out -exec chmod ugo-ws {} +
    '';
  }
)
