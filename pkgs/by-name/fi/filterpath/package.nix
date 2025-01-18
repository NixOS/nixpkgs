{
  stdenv,
  fetchFromGitHub,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "filterpath";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "Sigmanificient";
    repo = "filterpath";
    rev = finalAttrs.version;
    hash = "sha256-9rHooXgpvfNNeWxS8UF6hmb8vCz+xKABrJNd+AgKFJs=";
  };

  makeFlags = [
    "CC=cc"
    "PREFIX=${placeholder "out"}/bin"
  ];

  doCheck = true;
  checkPhase = ''
    runHook preCheck

    echo "[`pwd`]" | ./filterpath | grep "`pwd`"

    runHook postCheck
  '';

  meta = with lib; {
    homepage = "https://github.com/Sigmanificient/filterpath";
    description = "Retrieve a valid path from a messy piped line";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ sigmanificient ];
    mainProgram = "filterpath";
    platforms = platforms.linux;
  };
})
