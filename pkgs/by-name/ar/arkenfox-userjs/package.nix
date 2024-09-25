{
  lib,
  fetchurl,
  stdenvNoCC,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "arkenfox-userjs";
  version = "128.0";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/arkenfox/user.js/${finalAttrs.version}/user.js";
    hash = "sha256-CJk9sni0+cYC9rBHSL2mDQRtpsQJobQ1u3tq991Oi1c=";
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
