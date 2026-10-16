{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clac";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "soveran";
    repo = "clac";
    tag = finalAttrs.version;
    hash = "sha256-o/KYsiQDRva2mercTz1dmdcuXWCv7x8fy4LvPgk9Qn4=";
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
