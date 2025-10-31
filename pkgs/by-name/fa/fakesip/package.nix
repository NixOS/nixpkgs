{
  lib,
  stdenv,
  fetchFromGitHub,
  libnetfilter_queue,
  libnfnetlink,
  libmnl,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fakesip";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "MikeWang000000";
    repo = "FakeSIP";
    tag = finalAttrs.version;
    hash = "sha256-iY9EAvy4E6aM59B1sn9d0xoUMdOsX75LslVzB/Cf5XM=";
  };

  buildInputs = [
    libnetfilter_queue
    libnfnetlink
    libmnl
  ];

  makeFlags = [
    "CROSS_PREFIX=${stdenv.cc.targetPrefix}"
    "VERSION=${finalAttrs.version}"
  ];

  installFlags = [ "PREFIX=$(out)" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Disguise your UDP traffic as SIP protocol to evade DPI detection";
    homepage = "https://github.com/MikeWang000000/FakeSIP";
    changelog = "https://github.com/MikeWang000000/FakeSIP/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "fakesip";
    platforms = lib.platforms.linux;
  };
})
