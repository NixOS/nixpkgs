{
  stdenv,
  lib,
  gitaly,
  fetchFromGitLab,
  curl,
  pcre2,
  zlib,
  git,
  pkg-config,
  openssl,
}:
let
  data = lib.importJSON ./git-data.json;
in
stdenv.mkDerivation (finalAttrs: {
  inherit (data) version;
  pname = "gitaly-git";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "git";
    inherit (data) rev hash;
    fetchSubmodules = true;
  };

  # Use gitaly and their build system as source root
  unpackPhase = ''
    cp -r ${gitaly.src} source
    chmod -R +w source
    git config --global --add safe.directory '*'
  '';

  # This is a patch for gitaly, not git
  patches = [
    ./dont-clone-git-repo.patch
  ];

  sourceRoot = "source";

  buildFlags = [ "install-git" ];
  GIT_REPO_PATH = finalAttrs.src;
  HOME = "/build";

  nativeBuildInputs = [
    git # clones our repo from the store
    pkg-config
  ];
  # git inputs
  buildInputs = [
    openssl
    zlib
    pcre2
    curl
  ];

  # required to support pthread_cancel()
  NIX_LDFLAGS =
    lib.optionalString (stdenv.cc.isGNU && stdenv.hostPlatform.libc == "glibc") "-lgcc_s"
    + lib.optionalString stdenv.isFreeBSD "-lthr";

  # The build phase already installs it all
  GIT_PREFIX = placeholder "out";
  dontInstall = true;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    HOME=/build PAGER=cat $out/bin/git config -l
    file $out/bin/git | grep -qv 'too large section header'

    runHook postInstallCheck
  '';

  meta = {
    homepage = "https://git-scm.com/";
    description = "Distributed version control system - with Gitaly patches";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    teams = [ lib.teams.gitlab ];
  };
})
