{
  stdenv,
  lib,
  writers,
  buildNpmPackage,
  fetchFromGitHub,
  python3,
  ffmpeg,
  jq,
  moreutils,
  makeWrapper,
  nix-update-script,
}:
let
  python = python3.withPackages (
    p: with p; [
      pip
      debugpy
    ]
  );
in
buildNpmPackage (finalAttrs: {
  pname = "scrypted-unwrapped";
  version = "0.139.0";

  src = fetchFromGitHub {
    owner = "koush";
    repo = "scrypted";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LrT0wQ7LpKuUy3Ys7jvJHe+gZVBnztdr1A6lEg3cMGU=";
  };

  # replace @scrypted/node-pty (which has an incorrect package.json) with the
  # official MSFT version
  postPatch = ''
    ${jq}/bin/jq --sort-keys \
      ' del(.dependencies["@scrypted/node-pty"])
      | .dependencies["node-pty"] |= "1.0.0"
      | .dependencies.py |= "npm:@bjia56/portable-python@^0.1.131"' \
      package.json \
      | ${moreutils}/bin/sponge package.json

    cp ${./package-lock.json} package-lock.json
  '';

  sourceRoot = "${finalAttrs.src.name}/server";
  npmDepsHash = "sha256-4UaaymGbOJcanccgv3OHQGANC+MdXfDNe9rTsHkzq4g=";

  env = {
    SCRYPTED_PYTHON_PATH = "${python.interpreter}";
    SCRYPTED_FFMPEG_PATH = "${lib.getExe ffmpeg}";
  };

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    cp ${writers.writeJSON "install.json" { inherit (finalAttrs) version; }} $out/install.json
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "High-performance home video integration platform";
    longDescription = ''
      Scrypted is a high-performance home video integration platform and NVR with smart detections
    '';
    mainProgram = "scrypted-serve";
    homepage = "https://github.com/koush/scrypted";
    changelog = "https://github.com/koush/scrypted/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix; # openpty()
    # use of undeclared identifier 'openpty', upstream `node-pty` incorrectly doesn't link against `-lutil` on MacOS and Solaris
    broken = with stdenv.hostPlatform; isMacOS || isSunOS;
  };
})
