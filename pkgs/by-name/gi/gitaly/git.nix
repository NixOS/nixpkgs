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

stdenv.mkDerivation rec {
  pname = "gitaly-git";
  version = "2.50.1.gl1";

  # `src` attribute for nix-update
  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "git";
    rev = "v${version}";
    hash = "sha256-q+xQAVsatw0vS4iIgAxciAVVMr33BjG0yM4AvZrXB+8=";
    leaveDotGit = true;
    # The build system clones the repo from the store (since it always expects
    # to be able to clone in the makefiles) and it looks like nix doesn't leave
    # the tag so we re-add it.
    postFetch = ''
      git -C $out tag v${version};
    '';
  };

  # Use gitaly and their build system as source root
  unpackPhase = ''
    cp -r ${gitaly.src} source
    chmod -R +w source
    git config --global --add safe.directory '*'
  '';

  sourceRoot = src.name;

  buildFlags = [ "git" ];
  GIT_REPO_URL = src;
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
}
