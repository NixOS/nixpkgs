{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, darwin
, just
, pkg-config
, wrapGAppsHook4
, cairo
, dbus
, gdk-pixbuf
, glib
, graphene
, gtk4
, libadwaita
, librclone
, pango
, rclone
}:

rustPlatform.buildRustPackage rec {
  pname = "celeste";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "hwittenborn";
    repo = "celeste";
    rev = "v${version}";
    hash = "sha256-Yj2PvAlAkwLaSE27KnzEmiRAD5K/YVGbF4+N3uhDVT8=";
  };

  cargoHash = "sha256-nlYkFgm5r6nAbJvtrXW2VxzVYq1GrSs8bzHYWOglL1c=";

  postPatch = ''
    pushd $cargoDepsCopy/librclone-sys
    oldHash=$(sha256sum build.rs | cut -d " " -f 1)
    patch -p2 < ${./librclone-path.patch}
    substituteInPlace build.rs \
      --subst-var-by librclone ${librclone}
    substituteInPlace .cargo-checksum.json \
      --replace $oldHash $(sha256sum build.rs | cut -d " " -f 1)
    popd

    substituteInPlace justfile \
      --replace "{{ env_var('DESTDIR') }}/usr" "${placeholder "out"}"
    # buildRustPackage takes care of installing the binary
    sed -i "#/bin/celeste#d" justfile
  '';

  RUSTC_BOOTSTRAP = 1;

  nativeBuildInputs = [
    just
    pkg-config
    rustPlatform.bindgenHook
    wrapGAppsHook4
  ];

  buildInputs = [
    cairo
    dbus
    gdk-pixbuf
    glib
    graphene
    gtk4
    libadwaita
    librclone
    pango
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Foundation
    darwin.apple_sdk.frameworks.Security
  ];

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.isDarwin [
    "-Wno-error=incompatible-function-pointer-types"
  ]);

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ rclone ]}"
    )
  '';

  postInstall = ''
    just install
  '';

  meta = {
    changelog = "https://github.com/hwittenborn/celeste/blob/${src.rev}/CHANGELOG.md";
    description = "GUI file synchronization client that can sync with any cloud provider";
    mainProgram = "celeste";
    homepage = "https://github.com/hwittenborn/celeste";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
