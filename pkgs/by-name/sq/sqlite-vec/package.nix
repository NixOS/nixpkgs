{
  lib,
  gettext,
  fetchFromGitHub,
  sqlite,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sqlite-vec";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "asg017";
    repo = "sqlite-vec";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8vof4gfESfWHAW+MBYdhyte2bKnVk+VEiowDK42/G/0=";
  };

  nativeBuildInputs = [ gettext ];

  buildInputs = [ sqlite ];

  makeFlags = [
    "loadable"
    "static"
  ];
  installPhase = ''
    runHook preInstall

    install -Dm444 -t "$out/lib" \
      "dist/libsqlite_vec0${stdenv.hostPlatform.extensions.staticLibrary}" \
      "dist/vec0${stdenv.hostPlatform.extensions.sharedLibrary}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Vector search SQLite extension that runs anywhere";
    homepage = "https://github.com/asg017/sqlite-vec";
    changelog = "https://github.com/asg017/sqlite-vec/releases/tag/${finalAttrs.src.rev}";
    license = licenses.mit;
    maintainers = [ maintainers.anmonteiro ];
    platforms = platforms.unix;
  };
})
