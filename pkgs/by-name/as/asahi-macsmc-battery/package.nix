{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  udevCheckHook,
  bash,
  coreutils,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "asahi-macsmc-battery";
  version = "20250713";

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "asahi-scripts";
    tag = "20250713";
    hash = "sha256-4NqPaCrqr4R5xyI6aASEAQBtO996BqKCOAkxGoM0k4E=";
  };

  postPatch =
    # Prevent the Makefile from running the "install" target as a
    # prerequisite which leads to a build failure
    ''
      substituteInPlace Makefile \
        --replace-fail "install-macsmc-battery: install" \
                       "install-macsmc-battery:"
    '';

  makeFlags = [ "PREFIX=$(out)" ];

  dontBuild = true;

  installTargets = "install-macsmc-battery";

  nativeInstallCheckInputs = [ udevCheckHook ];
  doInstallCheck = true;

  fixupPhase = ''
    runHook preFixup

    substituteInPlace $out/lib/systemd/system/macsmc-battery-charge-control-end-threshold.service \
       --replace-fail "ExecStart=sh" "ExecStart=${bash}/bin/sh" \
       --replace-fail "cat" "${coreutils}/bin/cat"

    runHook postFixup
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Control battery limits on Apple Silicon laptops";
    longDescription = ''
      To control the charging threshold: edit the value contained in
      `/sys/class/power_supply/macsmc-battery/charge_control_end_threshold`
      and the threshold should be automatically changed.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ normalcea ];
    platforms = [ "aarch64-linux" ];
  };
})
