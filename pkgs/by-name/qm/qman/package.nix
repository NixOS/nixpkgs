{
  lib,
  stdenv,
  fetchFromGitHub,
  man,
  groff,
  xdg-utils,
  meson,
  ninja,
  pkg-config,
  python3Packages,
  ncurses,
  zlib,
  bzip2,
  xz,
  cunit,
  nix-update-script,
  versionCheckHook,
  writeShellScript,
}:

let
  # On darwin, skip xdg-utils and just use /usr/bin/open
  utils =
    if stdenv.hostPlatform.isDarwin then
      {
        open = "/usr/bin/open";
        email = writeShellScript "open-mailto" ''
          uris=()
          while (( $# )); do
            uris+=mailto:"$1"
            shift
          done
          /usr/bin/open "''${uris[@]}"
        '';
      }
    else
      {
        open = lib.getExe' xdg-utils "xdg-open";
        email = lib.getExe' xdg-utils "xdg-email";
      };
  /*
    We substitute some paths into the manpage.  Sticking a full store
    path with hash in there causes layout problems so we get rid of
    the hash.
  */
  escapedPathForMan =
    path:
    lib.escapeShellArg (
      /*
        I don't know manpage syntax, but the existing paths in there
        escape hyphens so we will too.
      */
      lib.replaceString "-" "\\-" (
        let
          result = builtins.match "${lib.escapeRegex builtins.storeDir}/[a-z0-9]{32}-(.*)" (toString path);
        in
        if result == null then toString path else "${builtins.storeDir}/…-${builtins.head result}"
      )
    );
in

stdenv.mkDerivation (finalAttrs: {
  pname = "qman";
  version = "1.5.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "plp13";
    repo = "qman";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z3ILbbwcCYZT8qabVaGnMCyZRag8djEI32i6G7cLL2A=";
  };

  postPatch = ''
    patchShebangs --build src/qman_tests_list.sh

    substituteInPlace src/config_def.py \
      --replace-fail /usr/bin/man ${lib.getExe man} \
      --replace-fail /usr/bin/groff ${lib.getExe' groff "groff"} \
      --replace-fail /usr/bin/whatis ${lib.getExe' man "whatis"} \
      --replace-fail /usr/bin/apropos ${lib.getExe' man "apropos"} \
      --replace-fail /usr/bin/xdg-open ${utils.open} \
      --replace-fail /usr/bin/xdg-email ${utils.email}

    substituteInPlace man/qman.1 \
      --replace-fail /usr/bin/man ${escapedPathForMan (lib.getExe man)} \
      --replace-fail /usr/bin/groff ${escapedPathForMan (lib.getExe' groff "groff")} \
      --replace-fail /usr/bin/whatis ${escapedPathForMan (lib.getExe' man "whatis")} \
      --replace-fail /usr/bin/apropos ${escapedPathForMan (lib.getExe' man "apropos")} \
      --replace-fail '/usr/bin/xdg\-open' ${escapedPathForMan utils.open} \
      --replace-fail '/usr/bin/xdg\-email' ${escapedPathForMan utils.email}
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3Packages.cogapp
  ];

  buildInputs = [
    ncurses
    zlib
    bzip2
    xz
  ];

  mesonFlags = [
    (lib.mesonEnable "tests" finalAttrs.doCheck)
    # Change installation config dir, themes and sample config go here.
    # Also see postInstall where we delete the sample config.
    (lib.mesonOption "configdir" "${placeholder "out"}/etc/xdg/qman")
  ];

  # Delete the sample config that we installed so that way qman will go ahead and check
  # /etc/xdg/qman/qman.conf and /etc/qman/qman.conf for configs as documented, and so initial
  # behavior will match documentation.
  postInstall = ''
    rm $out/etc/xdg/qman/qman.conf
  '';

  doCheck = true;
  checkInputs = [ cunit ];

  doInstallCheck = true;
  # qman crashes if the TERM env var isn't present
  versionCheckKeepEnvironment = [
    "TERM"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern man page viewer";
    longDescription = ''
      Unix manual pages are lovely.  They are concise, well-written,
      complete, and downright useful.  However, the standard way of
      accessing them from the command-line hasn't changed since the
      early days.

      Qman aims to change that.  It's a modern, full-featured manual
      page viewer featuring hyperlinks, web browser like navigation, a
      table of contents for each page, incremental search, on-line
      help, and more.  It also strives to be fast and tiny, so that it
      can be used everywhere.  For this reason, it's been written in
      plain C and has only minimal dependencies.
    '';
    homepage = "https://github.com/plp13/qman";
    changelog = "https://github.com/plp13/qman/tree/${finalAttrs.src.tag}#new-in-this-version";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ pborzenkov ];
    mainProgram = "qman";
    platforms = lib.platforms.all;
  };
})
