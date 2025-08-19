{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "automatic-ripping-machine";
  version = "2.17.4";

  src = fetchFromGitHub {
    owner = "automatic-ripping-machine";
    repo = "automatic-ripping-machine";
    tag = "${finalAttrs.version}";
    sha256 = "sha256-1EoRiNQUvV/PdI77n+vkE0tSHUP6NtidpCcfdwI2tCc=";
  };

  # No compilation needed; just copy the source files
  buildPhase = "true";

  installPhase = ''
    # Copy all files to /opt/arm in the output
    mkdir -p "$out/opt/arm"
    cp -r --no-preserve=ownership . "$out/opt/arm"
    # Install default configuration files
    install -D -m644 setup/arm.yaml       "$out/opt/arm/setup/arm.yaml"
    install -D -m644 setup/apprise.yaml   "$out/opt/arm/setup/apprise.yaml"
    install -D -m644 setup/.abcde.conf    "$out/opt/arm/setup/.abcde.conf"
    # Udev rule and systemd unit (for reference in NixOS module)
    install -D -m644 setup/51-automedia.rules "$out/lib/udev/rules.d/51-automedia.rules"
    install -D -m644 setup/armui.service     "$out/lib/systemd/system/armui.service"
    # License
    install -D -m644 LICENSE "$out/share/licenses/${finalAttrs.pname}/LICENSE"
  '';

  # ARM is a set of Python scripts, so ensure Python is available at runtime
  # (Dependencies will be provided via NixOS module using python with packages)
  buildInputs = [ ];

  meta = {
    description = "Automatic Ripping Machine – scripts for ripping and encoding optical discs";
    homepage = "https://github.com/automatic-ripping-machine/automatic-ripping-machine";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ adam248 ];
    platforms = lib.platforms.linux;
  };
})
