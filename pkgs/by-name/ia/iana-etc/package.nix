{
  lib,
  fetchzip,
  stdenvNoCC,
  writeText,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "iana-etc";
  version = "20251215";

  src = fetchzip {
    url = "https://github.com/Mic92/iana-etc/releases/download/${finalAttrs.version}/iana-etc-${finalAttrs.version}.tar.gz";
    hash = "sha256-BUGhVHvWSdFJdqaoPasLt87lTUFVF2B7X7sfigwrJss=";
  };

  strictDeps = true;

  installPhase = ''
    install -D -m0644 -t $out/etc services protocols
  '';

  setupHook = writeText "setup-hook" ''
    export NIX_ETC_PROTOCOLS=@out@/etc/protocols
    export NIX_ETC_SERVICES=@out@/etc/services
  '';

  __structuredAttrs = true;

  meta = {
    homepage = "https://github.com/Mic92/iana-etc";
    description = "IANA protocol and port number assignments (/etc/protocols and /etc/services)";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
  };
})
