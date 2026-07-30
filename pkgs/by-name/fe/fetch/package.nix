{
  lib,
  stdenv,
  fetchFromGitHub,
  # linux dependencies
  makeWrapper,
  fastfetch,
  pciutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fetch";
  version = "2.1.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "areofyl";
    repo = "fetch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9ixx7XJcY4ktcN/lUfjvFljvHIEO2ktOebeGgL0ulHg=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];
  nativeBuildInputs = [ makeWrapper ];
  postInstall = ''
    wrapProgram $out/bin/fetch \
    --prefix PATH : ${
      lib.makeBinPath [
        fastfetch
        pciutils
      ]
    }
  '';

  meta = {
    description = "Animated 3D fetch tool that renders your distro logo as a spinning bas-relief";
    homepage = "https://github.com/areofyl/fetch";
    changelog = "https://github.com/areofyl/fetch/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ ghastrum ];
    mainProgram = "fetch";
    platforms = lib.platforms.linux;
  };
})
