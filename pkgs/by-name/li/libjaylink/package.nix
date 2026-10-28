{
  fetchFromGitLab,
  lib,
  libusb1,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libjaylink";
  version = "0.5.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitLab {
    domain = "gitlab.zapb.de";
    owner = "libjaylink";
    repo = "libjaylink";
    tag = finalAttrs.version;
    hash = "sha256-bwFmJuezMURM7JEInG/q5TP7g+QloyQ4V1rsUZVcmvE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [ libusb1 ];

  doInstallCheck = true;

  postPatch = ''
    substituteInPlace contrib/60-libjaylink.rules \
      --replace-fail 'GROUP="plugdev"' 'GROUP="jlink"'
  '';

  postInstall = ''
    install -Dm644 ../contrib/60-libjaylink.rules $out/lib/udev/rules.d/60-libjaylink.rules
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://gitlab.zapb.de/libjaylink/libjaylink";
    description = "Shared library written in C to access SEGGER J-Link and compatible devices";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ felixsinger ];
    platforms = lib.platforms.unix;
  };
})
