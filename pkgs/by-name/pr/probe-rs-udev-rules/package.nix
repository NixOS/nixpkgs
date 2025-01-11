{
  lib,
  stdenv,
  fetchurl,
}:

## Usage
# In NixOS, simply add this package to services.udev.packages:
#   services.udev.packages = [ pkgs.probe-rs-udev-rules ];

stdenv.mkDerivation rec {
  pname = "probe-rs-udev-rules";

  # There is no versioning scheme upstream, so we set this to the date of the commit that most
  # recently changed the udev rules.
  version = "0-unstable-2024-02-25";

  src = fetchurl {
    url = "https://github.com/probe-rs/webpage/raw/c8dbcf00cef641117578aa3eccd26541b0e259f6/src/static/files/69-probe-rs.rules";
    sha256 = "sha256-SdwESnOuvOKMsTvxyA5c4UwtcS3kU33SlNttepMm7HY=";
  };

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -D $src $out/lib/udev/rules.d/69-probe-rs.rules
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://probe.rs/docs/getting-started/probe-setup/#udev-rules";
    description = "probe-rs udev rules list, granting users in the plugdev group access to use compatible USB debug probes";
    platforms = platforms.linux;
    license = licenses.gpl2Only; # As noted in licence header for the file itself
    maintainers = with maintainers; [ reivilibre ];
  };
}
