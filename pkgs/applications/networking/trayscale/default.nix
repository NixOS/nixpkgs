{ lib
, buildGoModule
, fetchFromGitHub
, pkg-config
, wrapGAppsHook4
, tailscale
, gtk4
, gobject-introspection
, libadwaita
}:

buildGoModule rec {
  pname = "trayscale";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "DeedleFake";
    repo = "trayscale";
    rev = "v${version}";
    hash = "sha256-uOPTF6AD70POD1y0R5aXo7t9WtyFGbRrgL8U++nTRl0=";
  };

  vendorHash = "sha256-8lrszfxTKLA3KRuuQ312s+1GfK63DwQEK8xDwb1JdrI=";

  subPackages = [ "cmd/trayscale" ];

  ldflags = [
    "-s"
    "-w"
    "-X=deedles.dev/trayscale/internal/version.version=${version}"
  ];

  nativeBuildInputs = [ pkg-config gobject-introspection wrapGAppsHook4 ];
  buildInputs = [ gtk4 libadwaita ];

  # there are no actual tests, and it takes 20 minutes to rebuild
  doCheck = false;

  postInstall = ''
    sh ./dist.sh install $out
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${tailscale}/bin")
  '';

  meta = with lib; {
    changelog = "https://github.com/DeedleFake/trayscale/releases/tag/${src.rev}";
    description = "Unofficial GUI wrapper around the Tailscale CLI client";
    homepage = "https://github.com/DeedleFake/trayscale";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "trayscale";
    platforms = platforms.linux;
  };
}
