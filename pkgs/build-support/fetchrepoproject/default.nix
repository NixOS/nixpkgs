{ stdenv, git, gitRepo, gnupg ? null, cacert }:

{ name, manifest, rev ? "HEAD", sha256 ? "", repoRepoURL ? "", repoRepoRev ? "", referenceDir ? ""
, localManifests ? []
}:

assert repoRepoRev != "" -> repoRepoURL != "";

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
    mkdir ./.repo
    mkdir ./.repo/local_manifests
    for local_manifest in ${concatMapStringsSep " " toString localManifests}
    do
      cp $local_manifest ./.repo/local_manifests/$(stripHash $local_manifest; echo $strippedName)
    done

    export HOME=.repo
    repo init --manifest-url=${manifest} --manifest-branch=${rev} --depth=1 --no-clone-bundle \
        ${concatStringsSep " " extraRepoInitFlags}

    repo sync --jobs=$NIX_BUILD_CORES --current-branch
    rm -rf $out/.repo
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
