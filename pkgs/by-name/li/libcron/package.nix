{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
  catch2,

  howard-hinnant-date,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcron";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "PerMalmberg";
    repo = "libcron";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DENyjZHG0xBJU/+e/K4xhhoMLSqHIV1VoYcAHX/mQqw=";
  };

  patches = [
    # To avoid using the vendored dependencies
    ./0001-build-find-date-from-system-libaries.patch
  ];

  nativeBuildInputs = [
    cmake
    catch2
  ];

  buildInputs = [ howard-hinnant-date ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "C++ scheduling library using cron formatting";
    homepage = "https://github.com/PerMalmberg/libcron";
    changelog = "https://github.com/PerMalmberg/libcron/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
  };
})
