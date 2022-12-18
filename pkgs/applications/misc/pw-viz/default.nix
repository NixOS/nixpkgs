{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libGL
, pipewire
, xorg
}:

rustPlatform.buildRustPackage rec {
  pname = "pw-viz";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "ax9d";
    repo = pname;
    rev = "v${version}";
    sha256 = "1d46m7w6rzzjpxc2fxwka9xbz49szbfrl63kxlv6kw4lknrladjn";
  };

  cargoSha256 = "sha256-jx1mUP6ezpwUhmDD9tCJBhHCHU8fEMlB738yYfB1psc=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libGL
    pipewire
    rustPlatform.bindgenHook
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libxcb
  ];

  postFixup = ''
    patchelf $out/bin/pw-viz --add-rpath ${lib.makeLibraryPath [ libGL xorg.libXrandr ]}
  '';

  meta = with lib; {
    description = "A simple and elegant pipewire graph editor ";
    homepage = "https://github.com/ax9d/pw-viz";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
    platforms = platforms.linux;
  };
}
