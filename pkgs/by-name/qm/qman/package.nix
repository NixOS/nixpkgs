{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  python3Packages,
  ncurses,
  man,
  groff,
  xdg-utils,
  writeShellScript,
  zlib,
  bzip2,
  xz,
  cunit,
  nix-update-script,
  versionCheckHook,
}:

let
  # on darwin, skip xdg-utils and just use /usr/bin/open
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
  # We substitute some paths into the manpage. Sticking a full store path with hash in there causes
  # layout problems so we get rid of the hash.
  escapedPathForMan =
    path:
    lib.escapeShellArg (
      # I don't know manpage syntax but the existing paths in there escape hyphens so we will too
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

  src = fetchFromGitHub {
    owner = "plp13";
    repo = "qman";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z3ILbbwcCYZT8qabVaGnMCyZRag8djEI32i6G7cLL2A=";
  };

  strictDeps = true;

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

  checkInputs = [ cunit ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doCheck = true;
  doInstallCheck = true;

  # qman crashes if the TERM env var isn't present
  versionCheckKeepEnvironment = [ "TERM" ];

  mesonFlags = [
    (lib.mesonEnable "tests" finalAttrs.doCheck)
    # qman by default will install a config file into /etc/xdg/qman.
    # Rather than disable that, we're just redirecting that here, because it also installs
    # themes and we want the themes to be available somewhere. qman will still check
    # /etc/xdg/qman/qman.conf even with changing this, as long as we remember to delete the
    # qman.conf file it installs into the configdir.
    (lib.mesonOption "configdir" "${placeholder "out"}/etc/xdg/qman")
  ];

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

  # Here's where we remember to remove the qman.conf file at our new configdir,
  # so that way /etc/xdg/qman/qman.conf and /etc/qman/qman.conf will work. That
  # file does tweak a few settings away from their defaults, but that means it
  # better matches its documentation (e.g. qman docs say mouse support is disabled
  # by default, but the sample qman.conf file it installs enables it).
  postInstall = ''
    rm $out/etc/xdg/qman/qman.conf
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/plp13/qman";
    description = "Modern man page viewer";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    mainProgram = "qman";
    maintainers = with lib.maintainers; [
      yiyu
      kpbaks
      lilyball
    ];
  };
})
