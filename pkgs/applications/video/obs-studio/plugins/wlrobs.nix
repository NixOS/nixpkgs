{ lib, stdenv, fetchFromSourcehut
, meson, pkg-config, ninja
, wayland, obs-studio, libX11
}:

stdenv.mkDerivation {
  pname = "wlrobs";
  version = "unstable-2022-10-06";

  src = fetchFromSourcehut {
    vc = "hg";
    owner = "~scoopta";
    repo = "wlrobs";
    rev = "78be323b25e1365f5c8f9dcba6938063ca10f71f";
    sha256 = "sha256-/VemJkk695BdSDsODmYIPdhPwggzIhBi/0m6P+AYfx0=";
  };

  nativeBuildInputs = [ meson pkg-config ninja ];
  buildInputs = [ wayland obs-studio libX11 ];

  meta = with lib; {
    description = "An obs-studio plugin that allows you to screen capture on wlroots based wayland compositors";
    homepage = "https://hg.sr.ht/~scoopta/wlrobs";
    maintainers = with maintainers; [ grahamc V ];
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
  };
}
