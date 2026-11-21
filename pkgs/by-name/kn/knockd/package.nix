{
  lib,
  stdenv,
  fetchFromGitHub,
  libpcap,
  autoreconfHook,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "knockd";
  version = "0.8";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "jvinet";
    repo = "knock";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-GOg6wovyr6J5qHm5EsOxrposFtwwx/FyJs7g0dagFmk=";
  };

  buildInputs = [ libpcap ];
  nativeBuildInputs = [ autoreconfHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Port-knocking server/client.";
    homepage = "https://github.com/jvinet/knock";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ geoffreyfrogeye ];
    mainProgram = "knock";
    platforms = lib.platforms.all;
  };
})
