{
  lib,
  fetchFromGitHub,
  rustPlatform,
  enableAppletSymlinks ? true,
}:

let
  version = "1.4";
in
rustPlatform.buildRustPackage {
  pname = "rsbkb";
  inherit version;

  src = fetchFromGitHub {
    owner = "trou";
    repo = "rsbkb";
    rev = "release-${version}";
    hash = "sha256-c5+Q/y2tZfhXQIAs1W67/xfB+qz1Xn33tKXRGDAi3qs=";
  };

  cargoPatches = [
    ./time.patch
  ];
  cargoHash = "sha256-jRkwfIEB9DEzoV5xogTDz1cHfdsvLM6E27E7hQBa9JY=";

  # Setup symlinks for all the utilities,
  # busybox style
  postInstall = lib.optionalString enableAppletSymlinks ''
    cd $out/bin || exit 1
    path="$(realpath --canonicalize-missing ./rsbkb)"
    for i in $(./rsbkb list) ; do ln -s $path $i ; done
  '';

  meta = with lib; {
    description = "Command line tools to encode/decode things";
    homepage = "https://github.com/trou/rsbkb";
    changelog = "https://github.com/trou/rsbkb/releases/tag/release-${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ProducerMatt ];
  };
}
