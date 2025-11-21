{
  ndpi,
  fetchFromGitHub,
  lib,
  stdenv,
  autoreconfHook,
  autoconf,
  automake,
  fixDarwinDylibNames,
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

    nativeBuildInputs =
      lib.remove autoreconfHook prevAttrs.nativeBuildInputs
      ++ [
        autoconf
        automake
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [ fixDarwinDylibNames ];
  }
)
