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
stdenv.mkDerivation (finalAttrs: {
  pname = "linuxhw-edid-fetcher";
  version = "0-unstable-2026-01-08";

  src = fetchFromGitHub {
    owner = "linuxhw";
    repo = "EDID";
    rev = "9c0c1bffc9c0f1cb2044115149a5ecb1652803f8";
    hash = "sha256-kdGUAbdlS736iB9oGo46HLK3ne3BV4LmUv/3fliyQBA=";
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
      repo="''${repo:-"${finalAttrs.src}"}"
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
})
