{
  lib,
  coreutils,
  curl,
  fetchFromGitHub,
  gawk,
  gnutar,
  stdenv,
  unixtools,
  writeShellApplication,
  nix-update-script,
  displays ? { },
}:

# Usage:
#   let
#     edids = linuxhw-edid-fetcher.override {
#       displays.PG278Q_2014 = [ "PG278Q" "2560x1440" "2014" ];
#     };
#   in
#     "${edids}/lib/firmware/edid/PG278Q_2014.bin";
stdenv.mkDerivation rec {
  pname = "linuxhw-edid-fetcher";
  version = "0-unstable-2023-05-08";

  src = fetchFromGitHub {
    owner = "linuxhw";
    repo = "EDID";
    rev = "98bc7d6e2c0eaad61346a8bf877b562fee16efc3";
    hash = "sha256-+Vz5GU2gGv4QlKO4A6BlKSETxE5GAcehKZL7SEbglGE=";
  };

  fetch = lib.getExe (writeShellApplication {
    name = "linuxhw-edid-fetch";
    runtimeInputs = [
      gawk
      coreutils
      unixtools.xxd
      curl
      gnutar
    ];
    text = ''
      repo="''${repo:-"${src}"}"
      ${builtins.readFile ./linuxhw-edid-fetch.sh}
    '';
  });

  configurePhase = lib.pipe displays [
    (lib.mapAttrsToList (
      name: patterns: ''
        "$fetch" ${lib.escapeShellArgs patterns} > "${name}.bin"
      ''
    ))
    (builtins.concatStringsSep "\n")
  ];

  installPhase = ''
    mkdir -p "$out/bin"
    ln -s "$fetch" "$out/bin/"
    ${lib.optionalString (displays != { }) ''
      install -D --mode=444 --target-directory="$out/lib/firmware/edid" *.bin
    ''}
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=master" ]; };

  meta = {
    description = "Fetcher for EDID binaries from Linux Hardware Project's EDID repository";
    homepage = "https://github.com/linuxhw/EDID";
    license = lib.licenses.cc-by-40;
    maintainers = with lib.maintainers; [ nazarewk ];
    platforms = lib.platforms.all;
    mainProgram = "linuxhw-edid-fetch";
  };
}
