{
  ndpi,
  fetchFromGitHub,
  lib,
  autoreconfHook,
  autoconf,
  automake,
}:

ndpi.overrideAttrs (
  finalAttrs: prevAttrs: {
    version = "4.0";

    src = fetchFromGitHub {
      inherit (prevAttrs.src) owner repo;
      tag = finalAttrs.version;
      hash = "sha256-vWx6IVyxPJBgOkXpHdnvstvDGJbAtndFPtowpjLd32o=";
    };

    configureScript = "./autogen.sh";

    nativeBuildInputs = lib.remove autoreconfHook prevAttrs.nativeBuildInputs ++ [
      autoconf
      automake
    ];
  }
)
