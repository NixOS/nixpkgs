{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "rns-over-icmp";
  version = "0-unstable-2025-11-24";
  pyproject = true;
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "matvik22000";
    repo = "rns-over-icmp";
    rev = "c307047c79de2e9781d1f827596506c3066994de";
    hash = "sha256-XxjoinQAHKq8xW+VJkEu2ohrOE312c6KFZKWZcxj6wI=";
  };

  postPatch = ''
    cp ${./pyproject.toml} pyproject.toml
    cp ${./cli.py} cli.py
  '';

  build-system = [
    python3Packages.setuptools
  ];

  dependencies = [
    python3Packages.scapy
  ];

  postFixup = ''
    wrapProgram $out/bin/rns-over-icmp \
      --set-default ICMP_TUNNEL_LOG_FILE "/tmp/rns-over-icmp.log" \
      --set PYTHONPATH $PYTHONPATH
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Script that allows using ICMP PING packets as a transport layer for Reticulum";
    homepage = "https://github.com/matvik22000/rns-over-icmp";
    license = lib.licenses.unfree; # FIXME: nix-init did not find a license
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "rns-over-icmp";
    platforms = lib.platforms.all;
  };
})
