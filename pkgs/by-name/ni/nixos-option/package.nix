{
  lib,
  coreutils,
  installShellFiles,
  jq,
  makeWrapper,
  man-db,
  nix,
  nixosTests,
  shellcheck,
  runCommand,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  name = "nixos-option";

  src = ./nixos-option.sh;

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  env = {
    nixosOptionNix = "${./nixos-option.nix}";
    nixosOptionManpage = "${placeholder "out"}/share/man";
  };

  dontUnpack = true;
  dontConfigure = true;
  dontPatch = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm555 $src $out/bin/nixos-option
    substituteAllInPlace $out/bin/nixos-option
    installManPage ${./nixos-option.8}

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/nixos-option \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          jq
          man-db
          nix
        ]
      }
  '';

  passthru.tests = {
    installer-simpleUefiSystemdBoot = nixosTests.installer.simpleUefiSystemdBoot;
    shellcheck = runCommand "nixos-option-shellchecked" { nativeBuildInputs = [ shellcheck ]; } ''
      shellcheck ${./nixos-option.sh} && touch $out
    '';
  };

  meta = {
    description = "Evaluate NixOS configuration and return the properties of given option";
    license = lib.licenses.mit;
    mainProgram = "nixos-option";
    maintainers = with lib.maintainers; [
      FireyFly
      azuwis
      aleksana
    ];
  };
}
