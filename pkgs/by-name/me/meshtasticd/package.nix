{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  i2c-tools,
  libX11,
  libgpiod_1,
  libinput,
  libusb1,
  libuv,
  libxkbcommon,
  udevCheckHook,
  ulfius,
  yaml-cpp,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "meshtasticd";
  version = "2.6.11.25";

  src = fetchurl {
    url = "https://download.opensuse.org/repositories/network:/Meshtastic:/beta/Debian_12/amd64/meshtasticd_${finalAttrs.version}~obs60ec05e~beta_amd64.deb";
    hash = "sha256-7JCv+1YgsCLwboGE/2f+8iyLLoUsKn3YdJ9Atnfj7Zw=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  dontConfigure = true;
  dontBuild = true;

  strictDeps = true;

  buildInputs = [
    i2c-tools
    libX11
    libgpiod_1
    libinput
    libusb1
    libuv
    libxkbcommon
    ulfius
    yaml-cpp
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libyaml-cpp.so.0.7"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p {$out,$out/bin}
    cp -r {usr,lib} $out/

    patchelf --replace-needed libyaml-cpp.so.0.7 libyaml-cpp.so.0.8 $out/usr/bin/meshtasticd

    ln -s $out/usr/bin/meshtasticd $out/bin/meshtasticd

    substituteInPlace $out/lib/systemd/system/meshtasticd.service \
      --replace-fail "/usr/bin/meshtasticd" "$out/bin/meshtasticd" \
      --replace-fail 'User=meshtasticd' 'DynamicUser=yes' \
      --replace-fail 'Group=meshtasticd' ""

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ udevCheckHook ];

  meta = {
    description = "Meshtastic daemon for communicating with Meshtastic devices";
    longDescription = ''
      This package has `udev` rules installed as part of the package.
      Add `services.udev.packages = [ pkgs.meshtasticd ]` into your NixOS
      configuration to enable them.
    '';
    homepage = "https://github.com/meshtastic/firmware";
    mainProgram = "meshtasticd";
    license = lib.licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ drupol ];
  };
})
