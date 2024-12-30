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
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  name = "nixos-option";

  src = ./nixos-option.sh;

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
    shellcheck
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

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    shellcheck $out/bin/nixos-option

    runHook postInstallCheck
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

  passthru.tests.installer-simpleUefiSystemdBoot = nixosTests.installer.simpleUefiSystemdBoot;

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
