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
    version = "4.14";

    src = fetchFromGitHub {
      inherit (prevAttrs.src) owner repo;
      tag = finalAttrs.version;
      hash = "sha256-W8ZBWMQH6bRHl+fXmG3XLO37UxEnSgCVCgzfwy8N+OM=";
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
