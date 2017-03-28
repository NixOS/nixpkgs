{ stdenv, git, gitRepo, gnupg ? null, cacert, copyPathsToStore }:

{ name, manifest, rev ? "HEAD", sha256, repoRepoURL ? "", repoRepoRev ? "", referenceDir ? ""
, localManifests ? [], createMirror ? false, useArchive ? !createMirror
}:

assert repoRepoRev != "" -> repoRepoURL != "";
assert createMirror -> !useArchive;

with stdenv.lib;

let
  repoInitFlags = [
    "--manifest-url=${manifest}"
    "--manifest-branch=${rev}"
    "--depth=1"
    #TODO: fetching clone.bundle seems to fail spectacularly inside a sandbox.
    "--no-clone-bundle"
    (optionalString createMirror "--mirror")
    (optionalString useArchive "--archive")
    (optionalString (repoRepoURL != "") "--repo-url=${repoRepoURL}")
    (optionalString (repoRepoRev != "") "--repo-branch=${repoRepoRev}")
    (optionalString (referenceDir != "") "--reference=${referenceDir}")
  ];

  local_manifests = copyPathsToStore localManifests;

in

with stdenv.lib;

let
  extraRepoInitFlags = [
    (optionalString (repoRepoURL != "") "--repo-url=${repoRepoURL}")
    (optionalString (repoRepoRev != "") "--repo-branch=${repoRepoRev}")
    (optionalString (referenceDir != "") "--reference=${referenceDir}")
  ];
in

stdenv.mkDerivation {
  buildCommand = ''
    mkdir .repo
    ${optionalString (local_manifests != []) ''
    mkdir ./.repo/local_manifests
    for local_manifest in ${concatMapStringsSep " " toString local_manifests}

    do
      cp $local_manifest ./.repo/local_manifests/$(stripHash $local_manifest; echo $strippedName)
    done
    ''}

    export HOME=.repo
    repo init ${concatStringsSep " " repoInitFlags}

    repo sync --jobs=$NIX_BUILD_CORES --current-branch
    ${optionalString (!createMirror) "rm -rf $out/.repo"}
  '';

  GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  impureEnvVars = stdenv.lib.fetchers.proxyImpureEnvVars ++ [
    "GIT_PROXY_COMMAND" "SOCKS_SERVER"
  ];

  buildInputs = [git gitRepo cacert] ++ optional (gnupg != null) [gnupg] ;
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  preferLocalBuild = true;
  enableParallelBuilding = true;
  inherit name cacert manifest rev repoRepoURL repoRepoRev referenceDir;
}
