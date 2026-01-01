{
  lib,
  stdenv,
  fetchFromGitHub,
  m2libc,
  mescc-tools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "m2-mesoplanet";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "oriansj";
    repo = "M2-Mesoplanet";
    rev = "Release_${finalAttrs.version}";
    hash = "sha256-hE7xvX84q3tk0XakveYDJhrhfBnpoItQs456NCzFfws=";
  };

  # Don't use vendored M2libc
  postPatch = ''
    rmdir M2libc
    ln -s ${m2libc}/include/M2libc M2libc
  '';

  # Upstream overrides the optimisation to be -O0, which is incompatible with fortify. Let's disable it.
  hardeningDisable = [ "fortify" ];

  doCheck = true;
  checkTarget = "test";
  nativeCheckInputs = [ mescc-tools ];

  installPhase = ''
    runHook preInstall

    install -D bin/M2-Mesoplanet $out/bin/M2-Mesoplanet

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    description = "Macro Expander Saving Our m2-PLANET";
    homepage = "https://github.com/oriansj/M2-Mesoplanet";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.minimal-bootstrap ];
=======
  meta = with lib; {
    description = "Macro Expander Saving Our m2-PLANET";
    homepage = "https://github.com/oriansj/M2-Mesoplanet";
    license = licenses.gpl3Only;
    teams = [ teams.minimal-bootstrap ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    inherit (m2libc.meta) platforms;
    mainProgram = "M2-Mesoplanet";
  };
})
