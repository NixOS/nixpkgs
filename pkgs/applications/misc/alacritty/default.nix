{ stdenv,
  fetchgit,
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
  name = "alacritty-unstable-${version}";
  version = "2017-10-22";

  # At the moment we cannot handle git dependencies in buildRustPackage.
  # This fork only replaces rust-fontconfig/libfontconfig with a git submodules.
  src = fetchgit {
    url = https://github.com/Mic92/alacritty.git;
    rev = "rev-${version}";
    sha256 = "02wvwi72hnqmy12n0b248wzhajni9ipyayz6vnn3ryhnrccrrp7j";
    fetchSubmodules = true;
  };

  cargoSha256 = "14bmm1f7hqh8i4mpb6ljh7szrm4g6mplzpq9zbgjrgxnc01w3s0i";

  buildInputs = [
    cmake
    makeWrapper
    pkgconfig
  ] ++ rpathLibs;

  postPatch = ''
    substituteInPlace copypasta/src/x11.rs \
      --replace Command::new\(\"xclip\"\) Command::new\(\"${xclip}/bin/xclip\"\)
  '';

  installPhase = ''
    runHook preInstall

    install -D target/release/alacritty $out/bin/alacritty
    patchelf --set-rpath "${stdenv.lib.makeLibraryPath rpathLibs}" $out/bin/alacritty

    install -D Alacritty.desktop $out/share/applications/alacritty.desktop

    runHook postInstall
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
