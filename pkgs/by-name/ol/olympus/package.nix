{
  lib,
  makeWrapper,
  olympus-unwrapped,
  symlinkJoin,
  buildFHSEnv,
  writeShellScript,
  # These need overriding if you launch Celeste/Loenn/MiniInstaller from Olympus.
  # Some examples:
  # - null: Use default wrapper.
  # - "": Do not use wrapper.
  # - steam-run: Use steam-run.
  # - "steam-run": Use steam-run command available from PATH.
  # - writeShellScriptBin { ... }: Use a custom script.
  # - ./my-wrapper.sh: Use a custom script.
  # In any case, it can be overridden at runtime by OLYMPUS_{CELESTE,LOENN,MINIINSTALLER}_WRAPPER.
  celesteWrapper ? null,
  loennWrapper ? null,
  miniinstallerWrapper ? null,
  skipHandlerCheck ? false, # whether to skip olympus xdg-mime check, true will override it
  finderHints ? [ ],
}:
let

  wrapper-to-env =
    wrapper:
    if lib.isDerivation wrapper then
      lib.getExe wrapper
    else if wrapper != null then
      wrapper
    else
      "";

  # When installing Everest, Olympus uses MiniInstaller, which is dynamically linked.
  miniinstaller-fhs = buildFHSEnv {
    pname = "olympus-miniinstaller-fhs";
    version = "1.0.0"; # remains constant, just to prevent complains
    targetPkgs =
      pkgs:
      (with pkgs; [
        icu
        openssl
        dotnet-runtime # Without this, MiniInstaller will install dotnet itself.
      ]);
  };

  miniinstaller-wrapper =
    if miniinstallerWrapper == null then
      (writeShellScript "miniinstaller-wrapper" "exec ${lib.getExe miniinstaller-fhs} -c \"$@\"")
    else
      (wrapper-to-env miniinstallerWrapper);

  finderHints' =
    if lib.isList finderHints then
      lib.concatMapStringsSep ":" (hint: "${hint}") finderHints
    else
      "${finderHints}";

in
symlinkJoin {

  inherit (olympus-unwrapped) version meta;
  pname = "olympus";

  paths = [
    olympus-unwrapped
  ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/olympus \
      --set-default OLYMPUS_CELESTE_WRAPPER "${wrapper-to-env celesteWrapper}" \
      --set-default OLYMPUS_LOENN_WRAPPER "${wrapper-to-env loennWrapper}"  \
      --set-default OLYMPUS_MINIINSTALLER_WRAPPER "${miniinstaller-wrapper}" \
      --set-default OLYMPUS_SKIP_SCHEME_HANDLER_CHECK "${if skipHandlerCheck then "1" else "0"}" \
      --suffix OLYMPUS_FINDER_HINTS : "${finderHints'}"
  '';
}
