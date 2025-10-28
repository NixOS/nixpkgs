{
  cmake,
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "colorized-logs";
  version = "2.7";

  src = fetchFromGitHub {
    owner = "kilobyte";
    repo = "colorized-logs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-m7M/1OuWDUflxTA4E6cSeg7BqkEW8eB/wIgq+z97K/g=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Tools for logs with ANSI color";
    homepage = "https://github.com/kilobyte/colorized-logs";
    changelog = "https://github.com/kilobyte/colorized-logs/blob/v${finalAttrs.version}/ChangeLog";
    license = with lib.licenses; [ mit ];
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ CobaltCause ];
  };
})
