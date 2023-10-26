{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, substituteAll
, just
, pkg-config
, wrapGAppsHook4
, cairo
, gdk-pixbuf
, glib
, graphene
, gtk3
, gtk4
, libadwaita
, libappindicator-gtk3
, librclone
, pango
, rclone
}:

rustPlatform.buildRustPackage rec {
  pname = "celeste";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "hwittenborn";
    repo = "celeste";
    rev = "v${version}";
    hash = "sha256-fqPAQCbuPnFyn3wioWDETmcXu53808nvnlEzcdUevI4=";
  };

  cargoHash = "sha256-mVl7CsCX7HMlGC2EIKEfHnPNjmrexjsrpDK/Uq/GwpY=";

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

  # Cargo.lock is outdated
  preConfigure = ''
    cargo update --offline
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
    gdk-pixbuf
    glib
    graphene
    gtk3
    gtk4
    libadwaita
    librclone
    pango
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libappindicator-gtk3 ]}"
      --prefix PATH : "${lib.makeBinPath [ rclone ]}"
    )
  '';

  postInstall = ''
    just install
  '';

  meta = {
    changelog = "https://github.com/hwittenborn/celeste/blob/${src.rev}/CHANGELOG.md";
    description = "GUI file synchronization client that can sync with any cloud provider";
    homepage = "https://github.com/hwittenborn/celeste";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
