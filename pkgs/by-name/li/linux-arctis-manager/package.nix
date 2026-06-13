{
  python3Packages,
  fetchFromGitHub,
  rustPlatform,
  udevCheckHook,
  lib,
}:

let
  uv-build = python3Packages.uv-build.overrideAttrs (old: rec {
    pname = "uv-build";
    version = "0.10.9";
    src = fetchFromGitHub {
      owner = "astral-sh";
      repo = "uv";
      tag = version;
      hash = "sha256-IAbewFab4X21SYqhjfxfWI9LsNSNVMIChbNc3j3EJQA=";
    };
    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit pname version src;
      hash = "sha256-LqrHze1MVaWq31Td/EGDeJCG+hRmPOSV1t7+ayQorlA=";
    };
  });
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "linux-arctis-manager";
  version = "2.4.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "elegos";
    repo = "Linux-Arctis-Manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wrhuHB2/Hz6jAMLT5VzTqNHa5djtDjljMmkcmlNrMGU=";
  };

  pyproject = true;

  nativeBuildInputs = [
    udevCheckHook
  ];

  propagatedBuildInputs = with python3Packages; [
    dbus-next
    pulsectl
    pyside6
    pyudev
    pyusb
    ruamel-yaml
  ];

  build-system = [
    uv-build
  ];

  postInstall = ''
    $out/bin/lam-cli udev write-rules --force --rules-path ./91-steelseries-arctis.rules
    install -Dm444 -t $out/etc/udev/rules.d ./91-steelseries-arctis.rules

    mkdir -p $out/share/{applications,icons}
    cp $src/src/linux_arctis_manager/desktop/* $out/share/applications/.
    cp $src/src/linux_arctis_manager/gui/images/steelseries_logo.svg $out/share/icons/.

    # Remove as this is only required for setup (desktop files, udev rules)
    rm -rf $out/bin/lam-cli
  '';

  meta = {
    description = "An open-source replacement for SteelSeries GG, to manage your Arctis headset on Linux!";
    homepage = "https://github.com/elegos/Linux-Arctis-Manager";
    license = lib.licenses.gpl3Only;
    mainProgram = "lam-gui";
    maintainers = with lib.maintainers; [
      Svenum
    ];
    platforms = lib.platforms.linux;
  };

})
