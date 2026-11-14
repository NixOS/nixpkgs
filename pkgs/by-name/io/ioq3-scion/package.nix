{
  ioquake3,
  fetchFromGitHub,
  pan-bindings,
  libsodium,
  nix-update-script,
  lib,
}:
ioquake3.overrideAttrs (old: {
  pname = "ioq3-scion";
  version = "0-unstable-2026-08-17";
  buildInputs = old.buildInputs ++ [
    pan-bindings
    libsodium
  ];
  src = fetchFromGitHub {
    owner = "lschulz";
    repo = "ioq3-scion";
    rev = "698e6719662c81ab294c77e9e29f99f69be0b313";
    hash = "sha256-uCK0zp0rPuVQr6ovJle5XfbC5an5n41R713lQUx3l40=";
  };
  # follow the dev branch, main still uses the old Makefile build
  passthru = old.passthru // {
    updateScript = nix-update-script { extraArgs = [ "--version=branch=dev" ]; };
  };
  meta = {
    description = "ioquake3 with support for path aware networking";
    homepage = "https://github.com/lschulz/ioq3-scion";
    maintainers = with lib.maintainers; [ matthewcroughan ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
})
