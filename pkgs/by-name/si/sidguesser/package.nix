{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sidguesser";
  version = "1.0.5";

  src = fetchFromGitLab {
    group = "kalilinux";
    owner = "packages";
    repo = "sidguesser";
    # the kali patch release contains required build patches
    rev = "kali/${finalAttrs.version}-1kali2";
    hash = "sha256-8rLLXtgckU9fzBjW/h0BqpoiK+9ix4fLx251IhxHCnQ=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  # applying kalilinux build patches
  prePatch = ''
    for p in debian/patches/*.patch;do
      patch -p1 < "$p"
    done
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 sidguess $out/bin/sidguess
    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Guesses SIDs/instances against an Oracle database according to a predefined dictionary file";
    homepage = "https://www.kali.org/tools/sidguesser/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ makefu ];
    mainProgram = "sidguess";
  };
})
