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
    rev = "f7a06d9131a5686c1b58c56f42f9fda9ea5e620d";
    hash = "sha256-qoteYmliUha3lY21PRM0FaeYu9aD5MsygBTsTYog9SE=";
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
