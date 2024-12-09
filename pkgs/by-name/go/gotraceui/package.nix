{
  lib, fetchFromGitHub, pkg-config, buildGoModule,
  libGL, libX11, libXcursor, libXfixes, libxkbcommon, vulkan-headers, wayland,
}:

buildGoModule rec {
  pname = "gotraceui";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "dominikh";
    repo = "gotraceui";
    rev = "v${version}";
    sha256 = "sha256-Rforuh9YlTv/mTpQm0+BaY+Ssc4DAiDCzVkIerP5Uz0=";
  };

  vendorHash = "sha256-dNV5u6BG+2Nzci6dX/4/4WAeM/zXE5+Ix0HqIsNnm0E=";
  subPackages = ["cmd/gotraceui"];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    vulkan-headers
    libxkbcommon
    wayland
    libX11
    libXcursor
    libXfixes
    libGL
  ];

  ldflags = ["-X gioui.org/app.ID=co.honnef.Gotraceui"];

  postInstall = ''
    cp -r share $out/
  '';

  meta = with lib; {
    description = "Efficient frontend for Go execution traces";
    mainProgram = "gotraceui";
    homepage = "https://github.com/dominikh/gotraceui";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ dominikh ];
  };
}
