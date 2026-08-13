{
  lib,
  stdenv,
  fetchgit,
  pkg-config,
  luajit,
  git,
  makeWrapper,
  nix-update-script,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pkgit";
  version = "1.1.3";

  src = fetchgit {
    url = "https://git.symlinx.net/pkgit";
    tag = finalAttrs.version;
    hash = "sha256-xGrhkVA5H/expArfUbfJ8p1odUAeJiL/vbsPedd92EE=";
  };

  __structuredAttrs = true;

  patches = [
    # main() loads the Lua config (which requires ~/.config/pkgit/init.lua)
    # before parsing arguments, so `pkgit --version` and `--help` abort without
    # a config. Answer those informational flags first so they work standalone
    # and can be used by versionCheckHook.
    ./0001-main-handle-version-help-before-loading-the-Lua-config.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [ luajit ];

  # The Makefile defaults CC to clang via `?=`; stdenv exports CC, which wins.
  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  enableParallelBuilding = true;

  # pkgit shells out to git at runtime (src/fetch_git.c execvp's "git").
  postInstall = ''
    wrapProgram $out/bin/pkgit \
      --prefix PATH : ${lib.makeBinPath [ git ]}
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Unconventional package manager that compiles and installs packages directly from Git repositories";
    homepage = "https://git.symlinx.net/pkgit";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ Ra77a3l3-jar ];
    mainProgram = "pkgit";
    platforms = lib.platforms.unix;
  };
})
