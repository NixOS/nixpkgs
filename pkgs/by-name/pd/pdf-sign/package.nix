{
  lib,
  stdenv,
  fetchFromGitHub,

  python3,
  ghostscript,
  qpdf,
  poppler-utils,
  makeBinaryWrapper,
}:

let
  python = python3.withPackages (ps: with ps; [ tkinter ]);

  binPath = lib.makeBinPath [
    ghostscript
    qpdf
    poppler-utils
  ];
in
stdenv.mkDerivation {
  pname = "pdf-sign";
  version = "0-unstable-2024-07-16";

  src = fetchFromGitHub {
    owner = "svenssonaxel";
    repo = "pdf-sign";
    rev = "6c373e3df2ac53af74ea84c3b5f299b13d7dae9c";
    hash = "sha256-yx1ff1JMTydCd5sCIoiT30zRwxNEwFbgEM9++nkJKY4=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  buildInputs = [ python ];

  installPhase = ''
    runHook preInstall

    for exe in "pdf-sign" "pdf-create-empty" "pdf-from-text"; do
      # Install wrapped programs into $out/lib so that they are not renamed.
      # Renaming them, like wrapProgram does, would produce the wrong output
      # from `--help`.
      install -Dm755 $exe -t $out/lib
      makeWrapper $out/lib/$exe $out/bin/$exe --prefix PATH : ${binPath}
    done

    runHook postInstall
  '';

  meta = {
    description = "Tool to visually sign PDF files";
    homepage = "https://github.com/svenssonaxel/pdf-sign";
    license = lib.licenses.mit;
    mainProgram = "pdf-sign";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.unix;
  };
}
