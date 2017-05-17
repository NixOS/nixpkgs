{ stdenv, fetchFromGitHub, qtbase, vcg, glew, qmake, mesa }:


stdenv.mkDerivation {
  name = "openbrf-unstable-2016-01-09";

  src = fetchFromGitHub {
    owner = "cfcohen";
    repo = "openbrf";
    rev = "4bdc66e38def5e5184f5379c84a7558b7484c70a";
    sha256 = "16254cnr60ihcn7bki7wl1qm6gkvzb99cn66md1pnb7za8nvzf4j";
  };

  buildInputs = [ qtbase vcg glew ];

  enableParallelBuilding = true;
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
      --set-rpath "${stdenv.lib.makeLibraryPath [ qtbase glew stdenv.cc.cc mesa ]}" \
      $out/share/openBrf/openBrf

    ln -s "$out/share/openBrf/openBrf" "$out/bin/openBrf"
  '';

  dontPatchELF = true;

  meta = with stdenv.lib; {
    description = "A tool to edit resource files (BRF)";
    homepage = "https://github.com/cfcohen/openbrf";
    maintainers = with stdenv.lib.maintainers; [ abbradar ];
    license = licenses.free;
    platforms = platforms.linux;
  };
}
