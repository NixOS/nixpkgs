{ stdenv, fetchFromGitHub
, meson, ninja, pkg-config, wayland, scdoc, makeWrapper
, wlroots, wayland-protocols, pixman, libxkbcommon
, cairo , pango, fontconfig, pandoc, systemd
, withXwayland ? true, xwayland
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "cagebreak";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "project-repo";
    repo = "cagebreak";
    rev = version;
    hash = "sha256-+Ww1rsUR7qe/BixLPR8GiRc3C6QmpLzWpT2wym8b4/M=";
  };

  nativeBuildInputs = [ meson ninja pkg-config wayland scdoc makeWrapper ];

  buildInputs = [
    wlroots wayland wayland-protocols pixman libxkbcommon cairo
    pango fontconfig pandoc systemd
  ];

  outputs = [ "out" "contrib" ];

  mesonFlags = [
    "-Dxwayland=${stdenv.lib.boolToString withXwayland}"
    "-Dversion_override=${version}"
  ];

  postInstall = ''
    mkdir -p $contrib/share/cagebreak
    cp $src/examples/config $contrib/share/cagebreak/config
  '';

  postFixup = stdenv.lib.optionalString withXwayland ''
    wrapProgram $out/bin/cagebreak --prefix PATH : "${xwayland}/bin"
  '';

  passthru.tests.basic = nixosTests.cagebreak;

  meta = with stdenv.lib; {
    description = "A Wayland tiling compositor inspired by ratpoison";
    homepage = "https://github.com/project-repo/cagebreak";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ berbiche ];
  };
}
