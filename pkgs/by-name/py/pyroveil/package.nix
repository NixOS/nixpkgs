{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  python3,
  makeWrapper,
}:
stdenv.mkDerivation (final: {
  pname = "pyroveil";
  version = "0-unstable-2025-06-24";

  src = fetchFromGitHub {
    owner = "HansKristian-Work";
    repo = "pyroveil";
    rev = "6b8adb0b0ed2cbdbd8c69e848280890a041bc7dc";
    fetchSubmodules = true;
    hash = "sha256-G5scUXWrDcLXouWOrHfl4vUIl6baQIOHNFQRgXL7UVg=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    python3
    makeWrapper
  ];

  postInstall = ''
    mkdir -p "$out/share/pyroveil"
    cp -r ../hacks "$out/share/pyroveil"
    install -D '${./init.sh}' "$out/bin/pyroveil-init"

    wrapProgram "$out/bin/pyroveil-init" \
      --inherit-argv0 \
      --set-default pyroveil_package_path "$out"
  '';

  meta = {
    description = "Vulkan layer to replace shaders or roundtrip them to workaround driver bugs";
    homepage = "https://github.com/HansKristian-Work/pyroveil";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ shved ];
    mainProgram = "pyroveil-init";
  };
})
