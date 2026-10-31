{
  lib,
  stdenvNoCC,
  fetchzip,
  sbcl,
  writeScript,

  installStandardLibrary ? true,
  installConcurrency ? true,
  installThorn ? true,
  installLogicLab ? true,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "shen-sbcl";
  version = "42";

  src = fetchzip {
    url = "https://shenlanguage.org/Download/S${finalAttrs.version}.zip";
    hash = "sha256-XyMkfqn5GS/92gJXYmHujf16XfRrIyNEJ3eENCm0PBI=";
  };

  nativeBuildInputs = [ sbcl ];
  strictDeps = true;
  dontStrip = true; # necessary to prevent runtime errors with sbcl

  buildPhase = ''
    runHook preBuild

    sbcl --noinform --no-sysinit --no-userinit --load install.lsp

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 sbcl-shen.exe $out/bin/shen-sbcl

    runHook postInstall
  '';

  postPatch = ''
    # allow SBCL to define *release* global
    substituteInPlace Primitives/globals.lsp \
      --replace-fail '"2.0.0"' '(LISP-IMPLEMENTATION-VERSION)'

    # remove interactive prompts during image creation
    # shen/tk requires further configuration and isn't supported by default
    substituteInPlace Lib/install.shen \
      --replace-fail '(y-or-n? "install standard library?")' '${lib.boolToString installStandardLibrary}' \
      --replace-fail '(y-or-n? "install concurrency? (required for Shen/tk)")' '${lib.boolToString installConcurrency}' \
      --replace-fail '(y-or-n? "install Shen/tk + IDE?")' 'false' \
      --replace-fail '(y-or-n? "install THORN?")' '${lib.boolToString installThorn}' \
      --replace-fail '(y-or-n? "install Logic Lab?")' '${lib.boolToString installLogicLab}'
  '';

  passthru.updateScript = writeScript "update-shen-sbcl" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl pcre2 coreutils common-updater-scripts

    set -eu -o pipefail

    version="$(
      curl -fsSL https://shenlanguage.org/download.html \
        | pcre2grep -o1 'S([0-9]+(?:\.[0-9]+)*)\.zip' \
        | sort -V \
        | tail -n1
    )"

    if [[ -z "$version" ]]; then
      echo "Could not determine latest Shen version" >&2
      exit 1
    fi

    if [[ "$version" == "$UPDATE_NIX_OLD_VERSION" ]]; then
      echo "shen-sbcl is already at version $version"
      exit 0
    fi

    update-source-version "$UPDATE_NIX_ATTR_PATH" "$version"
  '';

  meta = {
    homepage = "https://shenlanguage.org";
    description = "Port of Shen running on Steel Bank Common Lisp";
    changelog = "https://shenlanguage.org/download.html#kernel";
    platforms = sbcl.meta.platforms;
    maintainers = with lib.maintainers; [ hakujin ];
    license = lib.licenses.bsd3;
    mainProgram = "shen-sbcl";
  };
})
