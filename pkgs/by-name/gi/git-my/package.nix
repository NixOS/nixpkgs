{
  bash,
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "git-my";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "davidosomething";
    repo = "git-my";
    rev = finalAttrs.version;
    sha256 = "0jji5zw25jygj7g4f6f3k0p0s9g37r8iad8pa0s67cxbq2v4sc0v";
  };

  buildInputs = [ bash ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm 755 -t "$out/bin" -- git-my

    runHook postInstall
  '';

  meta = {
    description = "List remote branches if they're merged and/or available locally";
    homepage = "https://github.com/davidosomething/git-my";
    license = lib.licenses.free;
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = "git-my";
  };
})
