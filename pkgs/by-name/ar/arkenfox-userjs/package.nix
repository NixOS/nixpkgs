{
  lib,
  fetchurl,
  stdenvNoCC,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "arkenfox-userjs";
  version = "133.0";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/arkenfox/user.js/${finalAttrs.version}/user.js";
    hash = "sha256-rPcH24YqEBOzoPB9yxMlke/3tqpi9L7GVMsZ3MUP8WY=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 $src $out/user.js
    install -Dm644 $src $out/user.cfg
    substituteInPlace $out/user.cfg \
      --replace-fail "user_pref" "defaultPref"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A comprehensive user.js template for configuration and hardening";
    homepage = "https://github.com/arkenfox/user.js";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      linsui
      Guanran928
    ];
    platforms = lib.platforms.all;
  };
})
