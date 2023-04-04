{
  lib,
  nix-prefetch-docker,
  stdenvNoCC,
  cacert,
}:

/*

                              NOTE

  This fetcher was written in order to test nix-prefetch-docker.
  We may "rebase" the existing fetchgithub onto nix-prefetch-docker,
  or call it fetchDocker (camelCase), and migrate users over to it.
  Doing so has the benefit that it more closely follows the architecture of
  some other fetchers: calling the prefetch script in the actual fetcher.
  Until then, the purpose of this function is to test nix-prefetch-docker.

*/
args@{ name, hash ? "", sha256 ? "", os ? "linux", arch, imageName, imageTag ? finalImageTag, imageDigest, finalImageName ? imageName, finalImageTag ? imageTag }:

assert args?imageTag || args?finalImageTag;
assert args?imageName || args?finalImageName;

stdenvNoCC.mkDerivation {
  inherit name;
  outputHashAlgo = if hash != "" then null else "sha256";
  outputHashMode = "flat";
  outputHash = if hash != "" then
    hash
  else if sha256 != "" then
    sha256
  else
    lib.fakeSha256;
  nativeBuildInputs = [ nix-prefetch-docker cacert ];
  __structuredAttrs = true;
  buildCommand = ''
    export IS_FETCHER=1
    nix-prefetch-docker ${lib.cli.toGNUCommandLineShell {} {
      inherit os arch;
      image-name = imageName;
      image-tag = imageTag;
      image-digest = imageDigest;
      final-image-name = finalImageName;
      final-image-tag = finalImageTag;
    }}
  '';
}
