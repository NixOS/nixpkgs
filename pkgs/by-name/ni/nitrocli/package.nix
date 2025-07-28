{
  fetchFromGitHub,
  installShellFiles,
  lib,
  libnitrokey,
  rustPlatform,
  stdenv,
}:
let
  version = "0.4.1";
in
rustPlatform.buildRustPackage {
  pname = "nitrocli";
  inherit version;

  src = fetchFromGitHub {
    owner = "d-e-s-o";
    repo = "nitrocli";
    tag = "v${version}";
    hash = "sha256-j1gvh/CmRhPTeesMIK5FtaqUW7c8hN3ub+kQ2NM3dNM=";
  };

  cargoHash = "sha256-lWFleq9uxoshPMx2mYULCyEar72ZjGfgf0HlRoYfG/M=";

  # tests require a connected Nitrokey device
  doCheck = false;

  # link against packaged libnitrokey
  USE_SYSTEM_LIBNITROKEY = 1;

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ libnitrokey ];

  postInstall =
    (lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd nitrocli \
        --bash <($out/bin/shell-complete bash nitrocli) \
        --fish <($out/bin/shell-complete fish nitrocli) \
        --zsh <($out/bin/shell-complete zsh nitrocli)
    '')
    + ''
      installManPage doc/nitrocli.1
      rm $out/bin/shell-complete
    '';

  meta = {
    description = "Command line tool for interacting with Nitrokey devices";
    homepage = "https://github.com/d-e-s-o/nitrocli";
    license = lib.licenses.gpl3Plus;
    mainProgram = "nitrocli";
    maintainers = with lib.maintainers; [ robinkrahl ];
  };
}
