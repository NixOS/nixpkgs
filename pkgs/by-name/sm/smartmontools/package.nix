{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  enableMail ? false,
  gnused,
  hostname,
  mailutils,
  systemdLibs,
  writeShellScript,
  nix-update,
}:

let
  scriptPath = lib.makeBinPath (
    [
      gnused
      hostname
    ]
    ++ lib.optionals enableMail [ mailutils ]
  );

in
stdenv.mkDerivation (finalAttrs: {
  pname = "smartmontools";
  version = "7.5";

  src = fetchFromGitHub {
    owner = "smartmontools";
    repo = "smartmontools";
    tag = "RELEASE_${lib.replaceString "." "_" finalAttrs.version}";
    hash = "sha256-/2J73F97yiPlUnGkzewWzU+sARaeqgVc/3ScjVlHhQE=";
  };

  prePatch = ''
    cd smartmontools
  '';
  patches = [
    # fixes darwin build
    ./smartmontools.patch
  ];
  postPatch = ''
    ln -sf "$drivedb" drivedb.h
  '';

  configureFlags = [
    "--with-scriptpath=${scriptPath}"
    # does not work on NixOS
    "--without-update-smart-drivedb"
  ];

  outputs = [
    "out"
    "man"
    "doc"
  ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = lib.optionals (lib.meta.availableOn stdenv.hostPlatform systemdLibs) [ systemdLibs ];
  enableParallelBuilding = true;

  drivedb = fetchFromGitHub {
    owner = "smartmontools";
    repo = "smartmontools";
    rev = "794fa5069ee298c82f93ff0a7f7ef6a5fdd10e5e";
    hash = "sha256-WBed5elI+WsIiIJ1YVkdVGJ4XMrGRFIFWqk6ffVl0bU=";
    postFetch = ''
      mv "$out/smartmontools/drivedb.h" "$TMPDIR/drivedb.h"
      rm -rf "$out"
      mv "$TMPDIR/drivedb.h" "$out"
    '';
    passthru = {
      # Necessary so that nix-update can update the drivedb
      src = finalAttrs.drivedb;
      pname = "smartmontools-drivedb";
      version = "${finalAttrs.version}-drivedb-unstable";
    };
  };

  passthru.updateScript = writeShellScript "update-smartmontools" ''
    # Set a default attribute path
    # When running maintainers/scripts/update.nix this is set automatically,
    # but this allows running this update script directly.
    UPDATE_NIX_ATTR_PATH="''${UPDATE_NIX_ATTR_PATH:-smartmontools}"

    # Update smartmontools
    ${lib.getExe nix-update} "$UPDATE_NIX_ATTR_PATH" --version-regex 'RELEASE_(\d+)_(\d+)(?:_(\d+))?'

    # Update drivedb.h
    branch="origin/$(nix-instantiate --eval --raw --attr "$UPDATE_NIX_ATTR_PATH.src.tag")_DRIVEDB"
    ${lib.getExe nix-update} "$UPDATE_NIX_ATTR_PATH.drivedb" "--version=branch=$branch"
  '';

  meta = {
    description = "Tools for monitoring the health of hard drives";
    homepage = "https://www.smartmontools.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      Frostman
      samasaur
    ];
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "smartctl";
  };
})
