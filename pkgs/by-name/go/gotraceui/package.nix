{
  lib,
  fetchFromGitHub,
  pkg-config,
  buildGoModule,
  libGL,
  libX11,
  libxcb,
  libXcursor,
  libXfixes,
  libxkbcommon,
  vulkan-headers,
  wayland,
  fetchpatch,
}:

buildGoModule rec {
  pname = "gotraceui";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "dominikh";
    repo = "gotraceui";
    tag = "v${version}";
    sha256 = "sha256-Rforuh9YlTv/mTpQm0+BaY+Ssc4DAiDCzVkIerP5Uz0=";
  };

  patches = [
    (fetchpatch {
      name = "switch-to-gio-fork.patch";
      url = "https://github.com/dominikh/gotraceui/commit/00289f5f4c1da3e13babd2389e533b069cd18e3c.diff";
      hash = "sha256-dxsVMjyKkRG4Q6mONlJAohWJ8YTu8KN7ynPVycJhcs8=";
    })
  ];

  vendorHash = "sha256-9rzcSxlOuQC5bt1kZuRX7CTQaDHKrtGRpMNLrOHTjJk=";
  subPackages = [ "cmd/gotraceui" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    vulkan-headers
    libxkbcommon
    wayland
    libX11
    libxcb
    libXcursor
    libXfixes
    libGL
  ];

  ldflags = [ "-X gioui.org/app.ID=co.honnef.Gotraceui" ];

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
