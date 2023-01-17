{ lib, stdenvNoCC, gitRepo, cacert, copyPathsToStore }:

{ name, manifest, rev ? "HEAD", sha256
# Optional parameters:
, repoRepoURL ? "", repoRepoRev ? "", referenceDir ? "", manifestName ? ""
, localManifests ? [], createMirror ? false, useArchive ? false
}:

assert repoRepoRev != "" -> repoRepoURL != "";
assert createMirror -> !useArchive;

let
  extraRepoInitFlags = [
    (lib.optionalString (repoRepoURL != "") "--repo-url=${repoRepoURL}")
    (lib.optionalString (repoRepoRev != "") "--repo-branch=${repoRepoRev}")
    (lib.optionalString (referenceDir != "") "--reference=${referenceDir}")
    (lib.optionalString (manifestName != "") "--manifest-name=${manifestName}")
  ];

  repoInitFlags = [
    "--manifest-url=${manifest}"
    "--manifest-branch=${rev}"
    "--depth=1"
    (lib.optionalString createMirror "--mirror")
    (lib.optionalString useArchive "--archive")
  ] ++ extraRepoInitFlags;

  local_manifests = copyPathsToStore localManifests;

in stdenvNoCC.mkDerivation {
  inherit name;

  inherit cacert manifest rev repoRepoURL repoRepoRev referenceDir; # TODO

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  preferLocalBuild = true;
  enableParallelBuilding = true;

  impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
    "GIT_PROXY_COMMAND" "SOCKS_SERVER"
  ];

  nativeBuildInputs = [ gitRepo cacert ];

  GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  buildCommand = ''
    # Path must be absolute (e.g. for GnuPG: ~/.repoconfig/gnupg/pubring.kbx)
    export HOME="$(pwd)"

    mkdir $out
    cd $out

    mkdir .repo
    ${lib.optionalString (local_manifests != []) ''
      mkdir .repo/local_manifests
      for local_manifest in ${lib.concatMapStringsSep " " toString local_manifests}; do
        cp $local_manifest .repo/local_manifests/$(stripHash $local_manifest; echo $strippedName)
      done
    ''}

    repo init ${lib.concatStringsSep " " repoInitFlags}
    repo sync --jobs=$NIX_BUILD_CORES --current-branch

    # TODO: The git-index files (and probably the files in .repo as well) have
    # different contents each time and will therefore change the final hash
    # (i.e. creating a mirror probably won't work).
    ${lib.optionalString (!createMirror) ''
      rm -rf .repo
      find -type d -name '.git' -prune -exec rm -rf {} +
    ''}
  '';
}
