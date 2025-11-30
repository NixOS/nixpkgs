{
  stdenv,
  lib,
  fetchFromGitHub,
  installShellFiles,
  ncurses,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cano";
  version = "0.2.0-alpha";

  src = fetchFromGitHub {
    owner = "CobbCoding1";
    repo = "Cano";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OaWj0AKw3+sEhcAbIjgOLfxwCKRG6O1k+zSp0GnnFn8=";
  };

  patches = [ ./allow-read-only-store-help-page.patch ];

  postPatch = ''
    substituteInPlace src/main.c \
      --replace-fail "@help@" "${placeholder "out"}/share/help"
  '';

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ ncurses ];

  hardeningDisable = [
    "format"
    "fortify"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 build/cano -t $out/bin

    mkdir -p $out/share
    cp -r docs/help $out/share
    installManPage docs/cano.1

    runHook postInstall
  '';

  meta = {
    description = "Text Editor Written In C Using ncurses";
    homepage = "https://github.com/CobbCoding1/Cano";
    license = lib.licenses.asl20;
    mainProgram = "Cano";
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.linux;
  };
})
