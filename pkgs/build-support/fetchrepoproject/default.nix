{ stdenv, gitRepo, cacert, copyPathsToStore }:

{ name, manifest, rev ? "HEAD", sha256
, repoRepoURL ? "", repoRepoRev ? "", referenceDir ? ""
, localManifests ? [], createMirror ? false, useArchive ? !createMirror
}:

assert repoRepoRev != "" -> repoRepoURL != "";
assert createMirror -> !useArchive;

with stdenv.lib;

let
  extraRepoInitFlags = [
    (optionalString (repoRepoURL != "") "--repo-url=${repoRepoURL}")
    (optionalString (repoRepoRev != "") "--repo-branch=${repoRepoRev}")
    (optionalString (referenceDir != "") "--reference=${referenceDir}")
  ];

  repoInitFlags = [
    "--manifest-url=${manifest}"
    "--manifest-branch=${rev}"
    "--depth=1"
    #TODO: fetching clone.bundle seems to fail spectacularly inside a sandbox.
    "--no-clone-bundle"
    (optionalString createMirror "--mirror")
    (optionalString useArchive "--archive")
  ] ++ extraRepoInitFlags;

  local_manifests = copyPathsToStore localManifests;

in stdenv.mkDerivation {
  inherit name;

  inherit cacert manifest rev repoRepoURL repoRepoRev referenceDir; # TODO

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  preferLocalBuild = true;
  enableParallelBuilding = true;

  impureEnvVars = fetchers.proxyImpureEnvVars ++ [
    "GIT_PROXY_COMMAND" "SOCKS_SERVER"
  ];

  buildInputs = [ gitRepo cacert ];

  GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  buildCommand = ''
    # Path must be absolute (e.g. for GnuPG: ~/.repoconfig/gnupg/pubring.kbx)
    export HOME="$(pwd)"

    mkdir .repo
    ${optionalString (local_manifests != []) ''
      mkdir .repo/local_manifests
      for local_manifest in ${concatMapStringsSep " " toString local_manifests}; do
        cp $local_manifest .repo/local_manifests/$(stripHash $local_manifest; echo $strippedName)
      done
    ''}

    repo init ${concatStringsSep " " repoInitFlags}
    repo sync --jobs=$NIX_BUILD_CORES --current-branch
    ${optionalString (!createMirror) "rm -rf $out/.repo"}
  '';
}
