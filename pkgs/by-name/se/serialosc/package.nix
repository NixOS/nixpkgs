{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  wafHook,
  pkg-config,
  git,
  makeWrapper,
  libmonome,
  liblo,
  libuv,
  avahi-compat,
  udev,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "serialosc";
  version = "1.4.7";

  src = fetchFromGitHub {
    owner = "monome";
    repo = "serialosc";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-zglwhRXKJCvVwGIj+72ZUUxzhHaFHVggMrJunDcY2UE=";
  };

  # Upstream's wscript calls `git rev-parse` unconditionally but only
  # catches CalledProcessError, not FileNotFoundError. Including git
  # here keeps the call from raising an unhandled exception when the
  # build runs outside a git checkout.
  nativeBuildInputs = [
    python3
    wafHook
    pkg-config
    git
    makeWrapper
  ];

  buildInputs = [
    libmonome
    liblo
    libuv
    avahi-compat
    udev
  ];

  # serialosc calls `dlopen("libdns_sd.so")` at runtime for its
  # zeroconf/Bonjour code. Wrap the daemon so LD_LIBRARY_PATH covers
  # avahi-compat's lib dir; otherwise the dlopen silently fails and
  # LAN-visible device advertisement is disabled.
  postInstall = ''
    wrapProgram $out/bin/serialoscd \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ avahi-compat ]}
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Multi-device, Bonjour-capable OSC server for monome devices";
    homepage = "https://github.com/monome/serialosc";
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
    mainProgram = "serialoscd";
    maintainers = with lib.maintainers; [ ];
  };
})
