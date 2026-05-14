{
  lib,
  fetchFromGitHub,
  rustPlatform,
  enableAppletSymlinks ? true,
}:

let
  version = "1.9";
in
rustPlatform.buildRustPackage {
  pname = "rsbkb";
  inherit version;

  src = fetchFromGitHub {
    owner = "trou";
    repo = "rsbkb";
    rev = "release-${version}";
    hash = "sha256-zY8pvpz1Sg/dOb65MR/Z+rIFStwHsZ53OtybKGbjM+o=";
  };

  cargoHash = "sha256-loHsF4fCefT6I0WAbUuP2wmFAdXHNuZokoBQG65ZyoA=";

  # Setup symlinks for all the utilities,
  # busybox style
  postInstall = lib.optionalString enableAppletSymlinks ''
    cd $out/bin || exit 1
    path="$(realpath --canonicalize-missing ./rsbkb)"
    for i in $(./rsbkb list) ; do ln -s $path $i ; done
  '';

  meta = {
    description = "Command line tools to encode/decode things";
    homepage = "https://github.com/trou/rsbkb";
    changelog = "https://github.com/trou/rsbkb/releases/tag/release-${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ProducerMatt ];
  };
}
