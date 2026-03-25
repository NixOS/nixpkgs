{
  lib,
  stdenv,
  fetchFromGitLab,
  glycin-thumbnailer,
  shared-mime-info,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glycin-thumbnailer-test";
  inherit (glycin-thumbnailer) version;

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "sophie-h";
    repo = "test-images";
    rev = "b148bcf70847d6f126a8e83e27e1c59d2e474adf";
    hash = "sha256-dYsUgqjiElRbz3Quy/KxAm/Wu9qAwR5BK94uRrSmQ5s=";
  };

  # Fix incorrectly detected MIME types
  preBuild = ''
    export XDG_DATA_DIRS=${shared-mime-info}/share:$XDG_DATA_DIRS
  '';

  buildPhase = ''
    runHook preBuild

    cd images/
    mkdir -p $out

    for image in color/* icon/*; do
      for size in 128 256 512 1024; do
        input="file://$(realpath "$image")"
        output="$out/$(basename "$image")-$size.png"

        ${lib.getExe glycin-thumbnailer} -i "$input" -o "$output" -s $size
        file -E "$output"
      done
    done

    runHook postBuild
  '';
})
