{
  lib,
  stdenv,
  fetchFromGitHub,
  writeShellScriptBin,
  gcc-arm-embedded,
  pynitrokey,
  python3,

  # The make target to run
  makeTarget ? "release-buildv",
  # Whether the firmware should include the production public key for the bootloader
  release ? true,
}:

let
  # The latest release is found on the releases page; do not rely on the latest tag.
  # They normally contain the suffix `.nitrokey`.
  # https://github.com/Nitrokey/nitrokey-fido2-firmware/releases
  version = "2.4.1";

  # The firmware version is pulled from `git` so we stub it here to avoid pulling the whole program.
  fakeGit = writeShellScriptBin "git" ''
    echo "${version}.nitrokey"
  '';

in
stdenv.mkDerivation {
  pname = "nitrokey-fido2-firmware";
  inherit version;

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nitrokey-fido2-firmware";
    rev = "${version}.nitrokey";
    hash = "sha256-7AsnxRf8mdybI6Mup2mV01U09r5C/oUX6fG2ymkkOOo=";
    fetchSubmodules = true;
  };

  postPatch = ''
    # Remove a duplicate firmware_version definition. Without this,
    # firmware_version is defined multiple times, triggering a build error.
    substituteInPlace fido2/version.h \
      --replace-fail "const version_t firmware_version ;" ""
  '';

  nativeBuildInputs = [
    fakeGit
    # only gcc-arm-embedded includes libc_nano.a
    gcc-arm-embedded
    pynitrokey
    python3
  ];

  preBuild = ''
    cd targets/stm32l432
  '';

  makeFlags = [
    "${makeTarget}"
    "RELEASE=${toString release}"
  ];

  installPhase = ''
    runHook preInstall
    cp -r release $out
    runHook postInstall
  '';

  meta = {
    description = "Firmware for the Nitrokey FIDO2 device";
    homepage = "https://github.com/Nitrokey/nitrokey-fido2-firmware";
    maintainers = with lib.maintainers; [
      amerino
      kiike
      imadnyc
    ];
    license = with lib.licenses; [
      asl20
      mit
    ];
    platforms = lib.platforms.unix;
  };
}
