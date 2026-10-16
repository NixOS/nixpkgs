{
  runCommand,
  meson,
  git,
  lib,
}:
{
  pname,
  version,
  name ? "${pname}-${version}",
  hash ? lib.fakeHash,
  src,
}:
runCommand "${name}-subprojects"
  {
    inherit src;

    outputHashAlgo = if hash == "" then "sha256" else null;
    outputHashMode = "recursive";
    outputHash = hash;

    nativeBuildInputs = [
      meson
      git
    ];
  }
  ''
    runHook unpackPhase
    cd $sourceRoot
    meson subprojects download
    cp -r subprojects $out
    cd $out
    # contains nix store references
    rm -rf **/.git
  ''
