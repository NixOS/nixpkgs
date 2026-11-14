{
  stdenv,
  lib,
  fetchgit,
  nix-update-script,
  versionCheckHook,
}:
stdenv.mkDerivation {
  pname = "flexigif";
  version = "2018.11a";

  src = fetchgit {
    url = "https://create.stephan-brumme.com/flexigif-lossless-gif-lzw-optimization/git";
    rev = "c5ab3e172a7825f2ee7cddb3e00bc7a1d4db44bb";
    hash = "sha256-6tT7PsGy+Gx1EtiU/o/mpX25IIpcN97gIqhECuwq2a0=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "CXX = g++" "" \
      --replace-fail "CXXFLAGS +=-static" ""
  '';

  installPhase = ''
    runHook preInstall
    install -Dm0755 --target-directory=$out/bin flexiGIF
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/flexiGIF";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Shrinks GIF files by optimizing their compression scheme";
    homepage = "https://create.stephan-brumme.com/flexigif-lossless-gif-lzw-optimization/";
    license = lib.licenses.zlib;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ jwillikers ];
    mainProgram = "flexiGIF";
  };
}
