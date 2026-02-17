{
  nix-update-script,
  fetchFromGitHub,
  lib,
  stdenvNoCC,
  alsa-utils-nhlt ? null,
  coreutils,
  kmod ? null,
  alsa-lib,
}@attrs:

stdenvNoCC.mkDerivation (finalAttrs: {
  __structuredAttrs = true;

  pname = "alsa-ucm-conf";
  version = "1.2.15.3-unstable-2026-01-29";

  src = fetchFromGitHub {
    owner = "alsa-project";
    repo = "alsa-ucm-conf";
    rev = "4b0668f670409e13f98ffa6ee434bac886212762";
    hash = "sha256-CbgYe2/CTFBcjEdiJx+eVFIOmLwQRiPH47HdYbSvn3M=";
  };

  dontBuild = true;
  doInstallCheck = true;

  executablePkgs = {
    alsa-utils-nhlt = [ "nhlt-dmic-info" ];

    coreutils = [
      "mkdir"
      "rm"
    ];

    kmod = [ "modprobe" ];
  };

  postPatch = ''
    # substitute executable paths in exec directives with absolute store paths
    find . -type f -name \*.conf -print0 | xargs -0 -r -- sed -E -i \
    ${
      lib.concatStringsSep " \\\n" (
        lib.mapAttrsToList (
          name: exes:
          let
            pkg = attrs.${name};
          in
          "  -e "
          +
            lib.escapeShellArg
              # matches exec directives with opening quote and executable names,
              # optionally prefixed with ‘-’ and ‘/bin/’ or ‘/sbin/’, capturing
              # the directive with opening quote and optional ‘-’ (\1), the path
              # prefix (\2) and the executable name (\3)
              ''s:(\<exec\>\s+"-?)(/s?bin/)?\<(${lib.concatStringsSep "|" exes})\>:\1${
                if pkg != null && lib.meta.availableOn stdenvNoCC.hostPlatform pkg then
                  lib.getBin pkg + "/bin/\\3"
                else
                  # fall back to ‘false’ for unavailable packages
                  lib.getExe' coreutils "false"
              }:''

        ) finalAttrs.executablePkgs
      )
    } \
      --
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/alsa"
    cp -r ucm ucm2 "$out/share/alsa"

    runHook postInstall
  '';

  installCheckPhase = ''
    runHook preInstallCheck

    if grep -E -r '\<exec\>\s+"-?/s?bin/' "$out"; then
      echo found at least one unattended exec directive >&2
      exit 1
    fi

    runHook postInstallCheck
  '';

  passthru = {
    tests = { inherit alsa-lib; };
    updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
    };
  };

  meta = {
    homepage = "https://www.alsa-project.org/";
    description = "ALSA Use Case Manager configuration";

    longDescription = ''
      The Advanced Linux Sound Architecture (ALSA) provides audio and
      MIDI functionality to the Linux-based operating system.
    '';

    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      roastiek
      mvs
    ];

    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
  };
})
