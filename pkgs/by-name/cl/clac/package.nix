{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clac";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "soveran";
    repo = "clac";
    tag = finalAttrs.version;
    hash = "sha256-DcW35jKIZQqkNa5Y6am2e5/TAEg3Fo2n+fHG3nOpNzM=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    mkdir -p "$out/share/doc/clac"
    cp README* LICENSE "$out/share/doc/clac"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Interactive stack-based calculator";
    homepage = "https://github.com/soveran/clac";
    changelog = "https://github.com/soveran/clac/releases/tag/${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      gepbird
      raskin
    ];
    platforms = lib.platforms.unix;
    mainProgram = "clac";
  };
})
