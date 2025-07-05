{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
}:
stdenv.mkDerivation rec {
  pname = "rp";
  version = "2.1.4";

  nativeBuildInputs = [
    cmake
    ninja
  ];
  buildInputs = lib.optionals (stdenv.hostPlatform.isLinux) [ stdenv.cc.libc.static ];

  src = fetchFromGitHub {
    owner = "0vercl0k";
    repo = "rp";
    rev = "a60f8117443e421bb572df890341b5a0f982c267";
    hash = "sha256-lkyuV+yC3NTsdipyJkoxgh1N8/+15N15nQpjItUgyb0=";
  };
  sourceRoot = "${src.name}/src";

  installPhase = ''
    mkdir -p $out/bin
    cp rp-${if stdenv.hostPlatform.isDarwin then "osx" else "lin"} $out/bin/rp
  '';

  meta = with lib; {
    description = "Fast C++ ROP gadget finder for PE/ELF/Mach-O x86/x64/ARM/ARM64 binaries";
    homepage = "https://github.com/0vercl0k/rp";
    license = licenses.mit;
    maintainers = with maintainers; [ sportshead ];
    platforms = platforms.all;
    mainProgram = "rp";
  };
}
