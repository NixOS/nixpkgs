{
  callPackage,
  makeWrapper,
  lib,
  haskell,
  haskellPackages,
  versionCheckHook,
}:

let
  backend-pkg = (haskellPackages.callPackage ./generated-backend-package.nix { }).overrideScope (
    final: prev: {
      ansi-wl-pprint = final.ansi-wl-pprint_0_6_9;
    }
  );

  frontend-pkg = (callPackage ./generated-frontend-package.nix { })."gren-lang-0.5.4";
in
frontend-pkg.overrideAttrs (oldAttrs: {
  pname = "gren";

  buildInputs = oldAttrs.buildInputs or [ ] ++ [ makeWrapper ];

  postInstall =
    oldAttrs.postInstall or ""
    + ''
      wrapProgram $out/bin/gren \
        --set GREN_BIN ${lib.makeBinPath [ backend-pkg ]}/gren
    '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgram = "${placeholder "out"}/bin/gren";
  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = "./update.sh";
  };

  meta = oldAttrs.meta // {
    maintainers = with lib.maintainers; [
      tomasajt
      robinheghan
    ];
  };
})
