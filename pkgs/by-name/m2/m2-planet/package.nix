{ lib
, stdenv
, fetchFromGitHub
, m2libc
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "m2-planet";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "oriansj";
    repo = "M2-Planet";
    rev = "Release_${finalAttrs.version}";
    hash = "sha256-xVwUO67PlRiBj/YBnnTXFGh3jH470fcbaNjABoyYes4=";
  };

  # Don't use vendored M2libc
  postPatch = ''
    rmdir M2libc
    ln -s ${m2libc}/include/M2libc M2libc
  '';

  # Upstream overrides the optimisation to be -O0, which is incompatible with fortify. Let's disable it.
  hardeningDisable = [ "fortify" ];

  installPhase = ''
    runHook preInstall

    install -D bin/M2-Planet $out/bin/M2-Planet

    runHook postInstall
  '';

  meta = with lib; {
    description = "PLAtform NEutral Transpiler";
    homepage = "https://github.com/oriansj/M2-Planet";
    license = licenses.gpl3Only;
    maintainers = teams.minimal-bootstrap.members;
    inherit (m2libc.meta) platforms;
    mainProgram = "M2-Planet";
  };
})
