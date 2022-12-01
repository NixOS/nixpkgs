{ mkDerivation, lib, stdenv, fetchFromGitHub, qtbase, vcg, glew, qmake, libGLU, libGL }:


mkDerivation {
  pname = "openbrf";
  version = "unstable-2016-01-09";

  src = fetchFromGitHub {
    owner = "cfcohen";
    repo = "openbrf";
    rev = "4bdc66e38def5e5184f5379c84a7558b7484c70a";
    sha256 = "16254cnr60ihcn7bki7wl1qm6gkvzb99cn66md1pnb7za8nvzf4j";
  };

  buildInputs = [ qtbase vcg glew ];

  nativeBuildInputs = [ qmake ];

  qmakeFlags = [ "openBrf.pro" ];

  postPatch = ''
    sed -i 's,^VCGLIB .*,VCGLIB = ${vcg}/include,' openBrf.pro
  '';

  installPhase = ''
    install -Dm755 openBrf $out/share/openBrf/openBrf
    install -Dm644 carry_positions.txt $out/share/openBrf/carry_positions.txt
    install -Dm644 reference.brf $out/share/openBrf/reference.brf

    patchelf  \
      --set-rpath "${lib.makeLibraryPath [ qtbase glew stdenv.cc.cc libGLU libGL ]}" \
      $out/share/openBrf/openBrf

    mkdir -p "$out/bin"
    ln -s "$out/share/openBrf/openBrf" "$out/bin/openBrf"
  '';

  dontPatchELF = true;

  meta = with lib; {
    description = "A tool to edit resource files (BRF)";
    homepage = "https://github.com/cfcohen/openbrf";
    maintainers = with lib.maintainers; [ abbradar ];
    license = licenses.free;
    platforms = platforms.linux;
  };
}
