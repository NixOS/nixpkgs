{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bashmarks";
  version = "0-unstable-2026-10-06";

  src = fetchFromGitHub {
    owner = "huyng";
    repo = "bashmarks";
    rev = "f051b9ded1f4869dd72fc7763d428efc06b290ea";
    hash = "sha256-uECAo/RRcRO5dosIoQn9Tvh5C1uA67IIY+iAXiaw34Q=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  # Pure shell scrip
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # Upstream's `make install` just copies the script
    # into ~/.local/bin.

    # The file is meant to be sourced, not executed, so
    # it goes into share/.

    install -Dm644 bashmarks.sh $out/share/bashmarks/bashmarks.sh

    runHook postInstall
  '';

  # Small check to make sure script parse under bash.
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    bash -n $out/share/bashmarks/bashmarks.sh
    runHook postInstallCheck
  '';

  meta = {
    description = "Directory bookmarks for the shell";
    homepage = "https://github.com/huyng/bashmarks";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
