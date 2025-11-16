{
  lib,
  python3Packages,
  fetchFromGitHub,
  replaceVars,
  writeShellScript,
  steam-run-free,
  fetchpatch2,
  winetricks,
  yad,
  nix-update-script,
  extraCompatPaths ? "",
}:

python3Packages.buildPythonApplication rec {
  pname = "protontricks";
  version = "1.13.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Matoking";
    repo = "protontricks";
    tag = version;
    hash = "sha256-YJUNp+8n1LPlD7lCAy6AMNxToloPBn8ZaRfREiwS9ls=";
  };

  patches = [
    # Use steam-run to run Proton binaries
    (replaceVars ./steam-run.patch {
      steamRun = lib.getExe steam-run-free;
      bash = writeShellScript "steam-run-bash" ''
        exec ${lib.getExe steam-run-free} bash "$@"
      '';
    })

    # Revert vendored vdf since our vdf includes `appinfo.vdf` v29 support
    (fetchpatch2 {
      url = "https://github.com/Matoking/protontricks/commit/4198b7ea82369a91e3084d6e185f9b370f78eaec.patch";
      revert = true;
      hash = "sha256-1U/LiAliKtk3ygbIBsmoavXN0RSykiiegtml+bO8CnI=";
    })
  ];

  build-system = with python3Packages; [ setuptools-scm ];

  dependencies = with python3Packages; [
    vdf
    pillow
  ];

  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        winetricks
        yad
      ]
    }"
    # Steam Runtime does not work outside of steam-run, so don't use it
    "--set STEAM_RUNTIME 0"
  ]
  ++ lib.optional (extraCompatPaths != "") "--set STEAM_EXTRA_COMPAT_TOOLS_PATHS ${extraCompatPaths}";

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  # From 1.6.0 release notes (https://github.com/Matoking/protontricks/releases/tag/1.6.0):
  # In most cases the script is unnecessary and should be removed as part of the packaging process.
  postInstall = ''
    rm "$out/bin/protontricks-desktop-install"
  '';

  pythonImportsCheck = [ "protontricks" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple wrapper for running Winetricks commands for Proton-enabled games";
    homepage = "https://github.com/Matoking/protontricks";
    changelog = "https://github.com/Matoking/protontricks/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kira-bruneau ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
}
