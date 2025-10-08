{
  fetchFromGitHub,
  gcc15Stdenv,
  lib,
  nix-update-script,
  pkg-config,
  systemd,
}:
gcc15Stdenv.mkDerivation (finalAttrs: {
  pname = "runapp";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "c4rlo";
    repo = "runapp";
    tag = finalAttrs.version;
    hash = "sha256-+dIawnBTf8QU0dv93NQUCgW60BrlUXljaoNnRQjfJZQ=";
  };

  strictDeps = true;
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ systemd ];

  postPatch = ''
    substituteInPlace Makefile --replace-fail "-march=native" ""
  '';

  buildFlags = [ "release" ];

  installFlags = [
    "prefix=$(out)"
    "install_runner="
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Application runner for Linux desktop environments that integrate with systemd";
    homepage = "https://github.com/c4rlo/runapp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ clementpoiret ];
    mainProgram = "runapp";
    platforms = lib.platforms.linux;
  };
})
