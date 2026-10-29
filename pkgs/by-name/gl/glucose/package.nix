{
  lib,
  stdenv,
  fetchurl,
  unzip,
  zlib,
  enableUnfree ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glucose" + lib.optionalString enableUnfree "-syrup";
  version = "4.2.1";

  src = fetchurl {
    url = "https://www.labri.fr/perso/lsimon/downloads/softwares/glucose-${finalAttrs.version}.zip";
    hash = "sha256-J0J9EKC/4cCiZr/y4lz+Hm7OcmJmMIIWzQ+4c+KhqXg=";
  };

  sourceRoot = "glucose-${finalAttrs.version}/sources/${if enableUnfree then "parallel" else "simp"}";

  postPatch = ''
    substituteInPlace Main.cc \
      --replace "defined(__linux__)" "defined(__linux__) && defined(__x86_64__)"
  '';

  nativeBuildInputs = [ unzip ];

  buildInputs = [ zlib ];

  makeFlags = [ "r" ];

  installPhase = ''
    runHook preInstall

    install -Dm0755 ${finalAttrs.pname}_release $out/bin/${finalAttrs.pname}
    mkdir -p "$out/share/doc/${finalAttrs.pname}-${finalAttrs.version}/"
    install -Dm0755 ../{LICEN?E,README*,Changelog*} "$out/share/doc/${finalAttrs.pname}-${finalAttrs.version}/"

    runHook postInstall
  '';

  meta = {
    description = "Modern, parallel SAT solver (${
      if enableUnfree then "parallel" else "sequential"
    } version)";
    mainProgram = "glucose";
    homepage = "https://www.labri.fr/perso/lsimon/research/glucose/";
    license = if enableUnfree then lib.licenses.unfreeRedistributable else lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
