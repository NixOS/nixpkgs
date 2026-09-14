{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  miniupnpc,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "autoupnp";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "projg2";
    repo = "autoupnp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QGFgHV5qF53YLXbg2chf/HeMf/rGAAg8A0TrXUEX9hU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [ miniupnpc ];

  mesonFlags = [ "-Dlibnotify=disabled" ];

  doCheck = true;

  postInstall = ''
    # 1) patch shebangs in installed scripts
    patchShebangs "$out/bin"

    # 2) teach the wrapper to LD_PRELOAD the absolute .so path
    #    Only change the line that actually appends to LD_PRELOAD.
    substituteInPlace "$out/bin/autoupnp" \
      --replace-fail "set -- libautoupnp.so" "set -- $out/lib/libautoupnp.so"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Automatic UPnP/NAT-PMP port forwarder via LD_PRELOAD wrapper";
    homepage = "https://github.com/projg2/autoupnp";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "autoupnp";
    maintainers = with lib.maintainers; [ peigongdsd ];
  };
})
