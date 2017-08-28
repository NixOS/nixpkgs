{ stdenv,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  makeWrapper,
  expat,
  pkgconfig,
  freetype,
  fontconfig,
  libX11,
  gperf,
  libXcursor,
  libXxf86vm,
  libXi,
  xclip }:

with rustPlatform;

let
  rpathLibs = [
    expat
    freetype
    fontconfig
    libX11
    libXcursor
    libXxf86vm
    libXi
  ];
in

buildRustPackage rec {
  name = "alacritty-unstable-2017-08-28";

  src = fetchFromGitHub {
    owner = "jwilm";
    repo = "alacritty";
    rev = "c4ece6dde3c9dcf825a44aa775535a65c0c376a6";
    sha256 = "1n1ncz45h0zgprsm2wkj11i9wwpg3kba4wv5mcs1xx793aq16x82";
  };

  depsSha256 = "19lrj4i6vzmf22r6xg99zcwvzjpiar8pqin1m2nvv78xzxx5yvgb";

  buildInputs = [
    cmake
    makeWrapper
    pkgconfig
  ] ++ rpathLibs;

  patchPhase = ''
    substituteInPlace copypasta/src/x11.rs \
      --replace Command::new\(\"xclip\"\) Command::new\(\"${xclip}/bin/xclip\"\)
  '';

  installPhase = ''
    mkdir -p $out/bin
    for f in $(find target/release -maxdepth 1 -type f); do
      cp $f $out/bin
    done;
    patchelf --set-rpath "${stdenv.lib.makeLibraryPath rpathLibs}" $out/bin/alacritty
  '';

  dontPatchELF = true;

  meta = with stdenv.lib; {
    description = "GPU-accelerated terminal emulator";
    homepage = https://github.com/jwilm/alacritty;
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.linux;
  };
}
