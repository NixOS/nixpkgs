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
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "DeedleFake";
    repo = "trayscale";
    rev = "v${version}";
    hash = "sha256-qMQ0WykBHXyXZ6GkDM5l5ki27X1h8rl3sUBooqF3234=";
  };

  vendorHash = "sha256-K1Za2j4kUtsktFi9DjZYXrtfsWF1r6vIbyocLUrj5IU=";

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
    description = "An unofficial GUI wrapper around the Tailscale CLI client";
    homepage = "https://github.com/DeedleFake/trayscale";
    license = licenses.mit;
    maintainers = with maintainers; [ k900 ];
  };
}
